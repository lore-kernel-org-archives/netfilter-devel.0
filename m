From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC PATCH 0/5] translations from iptables to nft
Date: Mon, 14 Apr 2014 12:41:01 +0200
Message-ID: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45224 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaDNKlO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset provides the infrastructure and two new utilities to
provide one-way iptables to nft command translations. It aims to be
simple and fit into the existing nft/xtables compat userspace
infrastructure. However, most likely you will still need adapt your
rule-set to fully exploit the new nf_tables capabilities.

The new proposed utilities are:

1) iptables-restore-translate which basically takes a file that contains
   the ruleset in iptables-restore format and converts it to the nft
   syntax, eg.

 % iptables-restore-translate -f ipt-ruleset > nft-ruleset
 % cat nft-ruleset
 # Translated by iptables-restore-translate v1.4.21 on Mon Apr 14 12:18:14 2014
 add table ip filter
 add chain ip filter INPUT { type filter hook input priority 0; }
 add chain ip filter FORWARD { type filter hook forward priority 0; }
 add chain ip filter OUTPUT { type filter hook output priority 0; }
 add rule ip filter INPUT iifname lo counter accept
 # -t filter -A INPUT -m state --state INVALID -j LOG --log-prefix invalid:
 ...

The rules that cannot be translated are left commented out. Users should be
able to run this to track down the nft progress to see at what point it can
fully replace iptables and their filtering policy.

It should be possible to add some option to output the % of rules that
can be translated with some nice stats graph for people not even willing
to look into the details.

2) iptables-translate which suggests a translation for an iptables
   command:

 $ iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
 nft add rule filter OUTPUT ip protocol udp ip dst 8.8.8.8 counter accept

So you can inquire the new tool to suggest the nft command as a help
utility.

This also patchset includes two example translations for the tcp and
state matches. I think we can provide translations for ~40% of the
existing extensions. We can progressively adds more translations as
nft starts supporting more missing features.

Comments welcome.

Pablo Neira Ayuso (5):
  nft: xtables: add generic parsing infrastructure to interpret commands
  nft: xtables-restore: add generic parsing infrastructure
  nft: xtables: add the infrastructure to translate from iptables to nft
  extensions: libxt_tcp: add translation to nft
  extensions: libxt_state: add translation to nft

 extensions/libxt_conntrack.c    |   38 ++++
 extensions/libxt_tcp.c          |   80 +++++++
 include/xtables.h               |   14 ++
 iptables/Makefile.am            |    3 +
 iptables/nft-ipv4.c             |   64 +++++-
 iptables/nft-ipv6.c             |   65 +++++-
 iptables/nft-shared.h           |   52 +++++
 iptables/nft.h                  |   10 +
 iptables/xtables-compat-multi.c |    4 +
 iptables/xtables-multi.h        |    4 +
 iptables/xtables-restore.c      |  271 +++++++++++++----------
 iptables/xtables-translate.c    |  459 +++++++++++++++++++++++++++++++++++++++
 iptables/xtables.c              |  445 +++++++++++++++++++------------------
 libxtables/xtables.c            |   51 +++++
 14 files changed, 1236 insertions(+), 324 deletions(-)
 create mode 100644 iptables/xtables-translate.c

-- 
1.7.10.4

