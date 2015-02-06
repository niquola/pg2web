import re
import os
import sha
import subprocess


def parse(f):
  f = open(f,'r')
  chunks = []
  chunk = None

  for idx,line in enumerate(f):
    line = line.rstrip()
    if line == '': continue
    print '%s, %s' % (idx,line)
    if line[0] != ' ':
      if chunk: chunks.append(chunk)
      parts = re.split(' +', line)
      chunk = dict(node=parts[0], params=parts[1:-1], lines=[])
    else:
      chunk['lines'].append(line)

  if chunk: chunks.append(chunk)
  f.close()
  return chunks

def process(chunks):
  for ch in chunks:
    print '#%s' % ch['node']
    print '\n'.join(ch['lines'])

process(parse('20150205000000_init.sql'))

