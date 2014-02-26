From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC PATCH v2 0/6] nft events reporting
Date: Wed, 26 Feb 2014 17:09:44 +0100
Message-ID: <20140226160918.18974.64532.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60321 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751170AbaBZQJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:09:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series implements basic event reporting in the nftables CLI tool.

The first patches are some neccesary code factorization changes.
The last patch is the event reporting itself.

Its quite simple, the syntax is:
 % nft monitor [added|deleted] [tables|chains|sets|rules] [xml|json]

I've discarted using 'new|delete' keywords because 'new' collides with
the 'state new'ct option. 

Currently, 3 possible output formats:
 * A basic XML, provided by libnftnl.
 * A basic JSON, provided by libnftnl.
 * nft default-like syntax.

About this last format:

Rules are hard to print exactly as the user typed because sets.
The approach followed in the patch is:
 * keep a userspace cache of tables/anonymous sets.
 * since there are no event notifications for set_elements, query kernel
 for set_elements in the event callback.
 * since there are no event notification for deleted anon-sets, and sets names
 are reusable, scan each deleted rule to know which sets delete from the cache.
 * no need to do any caching if we are not monitoring new rule
 events in the nft default format.

So, the format with this series is as follow:

 % nft monitor -nnn
delete table ip6 filter
add table ip6 filter
add chain ip6 filter input { type filter hook input priority 0; }
add chain ip6 filter forward { type filter hook forward priority 0; }
add chain ip6 filter output { type filter hook output priority 0; }
add set ip6 filter set1 {type ipv6_address}
[...]
add rule ip filter input tcp sport { 1024-2048} tcp dport { 443, 80} counter packets 0 bytes 0 accept
delete rule ip filter input handle 94

 % nft monitor xml
<event><type>del</type><nftables>xml_object</nftables></event>

 % nft monitor json
{event:{type:"add",{"nftables":[json_object]}}}

Changes in this v2:
 * Address comments from Pablo and Patrick: Add the caching stuff and the XML/JSON format wrappers.

Please comment.
---

Arturo Borrero Gonzalez (6):
      rule: allow to print sets in plain format
      netlink: add netlink_delinearize_set() func
      rule: generalize chain_print()
      netlink: add netlink_delinearize_chain() func
      netlink: add netlink_delinearize_table() func
      src: add events reporting


 include/mnl.h     |    3 
 include/netlink.h |    8 +
 include/rule.h    |    7 +
 src/evaluate.c    |    1 
 src/mnl.c         |   45 +++-
 src/netlink.c     |  605 +++++++++++++++++++++++++++++++++++++++++++++++------
 src/parser.y      |   75 ++++++-
 src/rule.c        |  102 ++++++++-
 src/scanner.l     |    5 
 9 files changed, 757 insertions(+), 94 deletions(-)

-- 
Arturo Borrero Gonzalez
