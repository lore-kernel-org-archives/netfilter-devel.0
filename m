From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 0/8] nft event monitor
Date: Mon, 14 Apr 2014 12:17:03 +0200
Message-ID: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42751 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750898AbaDNKRP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements a basic nftables monitor via Netlink messages.

Most of the work in first patches is related to refactorization/generalization
of code.

The final patch is the big one.

About the syntax, i'm proposing:
 % nft monitor [added|deleted] [tables|chains|sets|elements|rules] [xml|json]

The straight-forward way of test this new feature is to simply run:
 % nft monitor

Other examples:
 * report new tables in XML format
   % nft monitor added tables xml
 * report deleted elements in standar nft syntax
   % nft monitor deleted elements
 * report all added/deleted rules in JSON format
   % nft monitor rules json

Handling set/set_elems is one of the harders parts of event reporting.
I've succesfully tested many cases (maps, named sets, anon-sets..), but I guess
more tuning can be done in the future, with some additional use and testing
by the community.

Please comment.

regards.
---

Arturo Borrero Gonzalez (8):
      rule: allow to print sets in plain format
      netlink: add netlink_delinearize_set() func
      rule: generalize chain_print()
      netlink: add netlink_delinearize_chain() func
      netlink: add netlink_delinearize_table() func
      netlink: refactorize set_elem conversion from netlink
      netlink: add socket error reporting helper function
      src: add events reporting


 doc/nftables.xml   |    1 
 include/mnl.h      |    3 
 include/netlink.h  |   11 +
 include/nftables.h |    1 
 include/rule.h     |   10 +
 src/evaluate.c     |    1 
 src/mnl.c          |   45 ++-
 src/netlink.c      |  746 ++++++++++++++++++++++++++++++++++++++++++++++------
 src/parser.y       |   90 ++++++
 src/rule.c         |  163 +++++++++++
 src/scanner.l      |    5 
 11 files changed, 957 insertions(+), 119 deletions(-)

-- 
Arturo Borrero Gonzalez
