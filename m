From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/4 iptables-nftables] compat updates
Date: Tue,  4 Feb 2014 16:32:22 +0100
Message-ID: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38371 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaBDPch (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:32:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset contains three updates for the compatibility layer:

* Don't require libmnl and libnftnl if you choose to disable the
  compatibility layer via --disable-nftables.

* Provide a mechanism to distributors to switch to the compatibility
  layer in a transparent way (by updating the symlinks to the new
  binary xtables-compat-multi). Meanwhile, it installs
  {ip,ip6,arp}tables-compat-* utilities so you can use both native and
  compatibility layer tools.

* Add a emulated xtc_ops structure to avoid dependencies with libip4tc.

* A simple fix to replace a string that is wrong.

If no concerns, I'll push this to the nft-compat branch. After this,
I'll merge this branch to master and will also prepare the first
release of iptables including the nftables compatibility layer.

Pablo Neira Ayuso (4):
  configure: rename --disable-xtables to --disable-nftables
  configure: conditional dependencies for nftables-compat
  xtables-restore: remove dependency with libip4tc
  xtables: add xtables-compat-multi for the nftables compatibility layer

 configure.ac                      |   75 +++++++++++++++++++------------------
 iptables/Makefile.am              |   41 ++++++++++++--------
 iptables/xtables-arp-standalone.c |    2 +-
 iptables/xtables-arp.c            |    2 +-
 iptables/xtables-compat-multi.c   |   39 +++++++++++++++++++
 iptables/xtables-multi.h          |   13 +++++--
 iptables/xtables-restore.c        |   28 +++++++++++---
 iptables/xtables-save.c           |   18 +++++++--
 iptables/xtables-standalone.c     |   24 ++++++++----
 9 files changed, 166 insertions(+), 76 deletions(-)
 create mode 100644 iptables/xtables-compat-multi.c

-- 
1.7.10.4

