From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH 0/6] events
Date: Tue, 18 Feb 2014 00:18:06 +0100
Message-ID: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39312 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753982AbaBQXSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:18:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series implements basic event reporting in the nftables CLI tool.

The first patches are some neccesary code factorization changes.
The last patch is the event reporting itself.

Its quite simple, the syntax is:
 % nft event <all|table|chain|rule|set> [xml|json]

To quit, fire CTRL+C (^C).

Currently, 3 possible output formats:
 * A basic XML, provided by libnftnl.
 * A basic JSON, provided by libnftnl.
 * nft default-like syntax.

About this last format:

Rules are hard to print exactly as the user typed because sets and other
nuances. Possible solutions I've found:
 - assume that an anonymous set event will happen always before a new rule event.
 Cache the anon-set for the following rule event.
 Maybe there are many anon-sets per rule.
 - when a rule event happens, query for sets inside the event cb.
 - for this to run smoothly, we need to keep tables info in sync with the
 kernel, so in each relevant event, the netlink_ctx is needed to be updated and
 this allows to reuse netlink_delinearize_rule().

But I think this first approach is valid.

So, the format with this series is as follow:

 % nft event all
delete table ip6 filter
add table ip6 filter
add chain ip6 filter input { type filter hook input priority 0;}
add chain ip6 filter forward { type filter hook forward priority 0;}
add chain ip6 filter output { type filter hook output priority 0;}
add rule ip6 filter input handle 4
delete rule ip6 filter input handle 4
add set ip6 filter set1 {type ipv6_address}
delete chain ip6 filter input
delete set ip6 filter set1

NOTE: no way to add comments in JSON, so I decided to add that bash-like
comment by now and be consistent in both formats.

 % nft event all xml
<table><name>test</name><family>arp</family><flags>0</flags><use>0</use></table>        # add table
<chain><name>c</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>test</table><family>arp</family></chain>      # add chain
<chain><name>c</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>test</table><family>arp</family></chain>      # del chain
<table><name>test</name><family>arp</family><flags>0</flags><use>0</use></table>        # del table

 % nft event all json
{"table":{"name":"test","family":"arp","flags":0,"use":0}}      # add table
{"set":{"name":"set123","table":"test","flags":0,"family":"arp","key_type":7,"key_len":4}}      # add set

Please comment.

---

Arturo Borrero Gonzalez (6):
      rule: make family2str() public
      rule: allow to print sets in plain format
      netlink: add netlink_delinearize_set() func
      rule: generalize chain_print()
      netlink: add netlink_delinearize_rule() func
      src: add events reporting


 include/mnl.h             |    3 +
 include/netlink.h         |   15 +++
 include/rule.h            |    7 +
 src/evaluate.c            |    1 
 src/mnl.c                 |   45 +++++---
 src/netlink.c             |  268 ++++++++++++++++++++++++++++++++++++++-------
 src/netlink_delinearize.c |   57 ++++++++++
 src/parser.y              |   60 ++++++++++
 src/rule.c                |   93 +++++++++++++---
 src/scanner.l             |    2 
 10 files changed, 477 insertions(+), 74 deletions(-)

-- 
Arturo Borrero Gonzalez
