From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftnl/iptables PATCH 0/8] Various fixes
Date: Tue, 11 Feb 2014 12:46:40 +0200
Message-ID: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54423 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaBKKrC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On libnftnl:

When enabling debug on iptables, I got a non proper output:
DEBUG: table: table 0L=C2=A9 unknown flags 0 ----------------	---------=
---------

when it should be:
DEBUG: table: table 0L=C2=A9 unknown flags 0
----------------        ------------------

Same on chain. So these 2 patches below fix that.
Note: I haven't been able to fix yet this garbage printing
(instead of '0L=C2=A9' there should be the proper table name)

Tomasz Bursztyka (2):
  chain: Break the line properly when printing out the chain
  table: Break the line properly when printing out the table

 src/chain.c | 2 +-
 src/table.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

On iptables (nft-compat branch):

Tomasz Bursztyka (6):
  xtables: Handle family is not related to Netlink family
  xtables: Add backward compatibility with -w option
  nft: Fix error message to output proper origin
  nft: Add useful debug output when a builtin table is created
  nft: A builtin chain might be created when restoring
  nft: Initialize according to requested table, if any

 iptables/nft.c                | 52 +++++++++++++++++++++++++++++++++++=
--------
 iptables/nft.h                |  7 ++++--
 iptables/xtables-arp.c        |  2 +-
 iptables/xtables-config.c     |  2 +-
 iptables/xtables-restore.c    | 24 +++++++++++---------
 iptables/xtables-save.c       | 16 ++++++-------
 iptables/xtables-standalone.c |  4 ++--
 iptables/xtables.c            | 12 +++++++++-
 8 files changed, 84 insertions(+), 35 deletions(-)

--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
