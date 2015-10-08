From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 0/7] listing command updates
Date: Thu,  8 Oct 2015 22:49:23 +0200
Message-ID: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47737 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbJHUmg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset is following up after:

http://www.spinics.net/lists/netfilter-devel/msg38491.html

In a nutshell, what I'm proposing is that:

* `list {tables,chains,sets}' only display the object declaration, not its
  definition (ie. content). Moreover, if no family is specified, then they
  show all families to get this aligned with `list ruleset'.

* If you want to obtain the objects definition, then you use the
  `list {table,chain,set}' variant.

* We always provide an output that doesn't break `nft -f'.

Let me know if you have any comment,
Thanks.

Pablo Neira Ayuso (7):
  rule: display table when listing sets
  src: add `list chains' command
  rule: display table when listing one set
  evaluate: check if set exists before listing it
  rule: `list sets' only displays declaration, not definition
  rule: rework list chain
  parser_bison: show all sets via list sets with no family

 include/rule.h     |  2 ++
 src/evaluate.c     | 13 +++++++-
 src/parser_bison.y | 18 ++++------
 src/rule.c         | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 111 insertions(+), 19 deletions(-)

-- 
2.1.4

