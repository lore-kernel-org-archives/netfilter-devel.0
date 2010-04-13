From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/6] netfilter: xtables2: make ip_tables reentrant
Date: Tue, 13 Apr 2010 13:42:38 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004131342040.21259@obet.zrqbmnf.qr>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <1270666217-27670-5-git-send-email-jengelh@medozas.de> <4BC44009.4080206@trash.net> <alpine.LSU.2.01.1004131247580.11306@obet.zrqbmnf.qr> <4BC44CB8.4080405@trash.net>
 <alpine.LSU.2.01.1004131311330.16098@obet.zrqbmnf.qr> <4BC4525A.8000507@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35772 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0DMLmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:42:39 -0400
In-Reply-To: <4BC4525A.8000507@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-13 13:15, Patrick McHardy wrote:
>
>Developers can change it in the source code. Please remove the
>parameter and hard code it.
>
>I'll then apply this patch if we can get rid of the ruleset
>duplication for each CPU.

The following changes since commit e26c28e8bffe12b27df5b828404afed9e1949191:
  Bart De Schuymer (1):
        netfilter: bridge-netfilter: update a comment in br_forward.c about ip_fragment()

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (6):
      netfilter: ipv6: move POSTROUTING invocation before fragmentation
      netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
      netfilter: xtables: inclusion of xt_TEE
      netfilter: xtables2: make ip_tables reentrant
      netfilter: xt_TEE: have cloned packet travel through Xtables too
      netfilter: xtables: remove old comments about reentrancy

 include/linux/netfilter/Kbuild     |    1 +
 include/linux/netfilter/x_tables.h |    7 +
 include/linux/netfilter/xt_TEE.h   |    8 ++
 net/ipv4/netfilter/arp_tables.c    |    6 +-
 net/ipv4/netfilter/ip_tables.c     |   67 ++++++-----
 net/ipv4/netfilter/ipt_REJECT.c    |    3 -
 net/ipv6/ip6_output.c              |   50 ++++----
 net/ipv6/netfilter/ip6_tables.c    |   58 ++++------
 net/ipv6/netfilter/ip6t_REJECT.c   |    3 -
 net/netfilter/Kconfig              |    7 +
 net/netfilter/Makefile             |    1 +
 net/netfilter/x_tables.c           |   77 ++++++++++++
 net/netfilter/xt_TEE.c             |  228 ++++++++++++++++++++++++++++++++++++
 13 files changed, 414 insertions(+), 102 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 net/netfilter/xt_TEE.c
