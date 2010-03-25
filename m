From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 15:03:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003251502320.32573@obet.zrqbmnf.qr>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de> <4BAB604A.2090808@trash.net> <alpine.LSU.2.01.1003251414350.30248@obet.zrqbmnf.qr> <4BAB64D1.2070404@trash.net>
 <alpine.LSU.2.01.1003251443530.32573@obet.zrqbmnf.qr> <4BAB6C4F.9040002@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57670 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab0CYODK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:03:10 -0400
In-Reply-To: <4BAB6C4F.9040002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-03-25 14:59, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Thursday 2010-03-25 14:27, Patrick McHardy wrote:
>>> Fair enough, but some consistency among modules would be great. There
>>> are a few instances of pr_err/warning used for memory allocation errors
>>> or invalid parameters in this patch.
>> 
>> As far as I can see, I've been consistent.
>> 
>> pcregrep -r 'pr_(?!info)' net/ipv4/netfilter/ net/ipv6/netfilter/
>> net/bridge/netfilter/ net/netfilter/ | grep -v pr_debug |
>> grep -v pr_fmt | less
>> 
>> Only shows either lines outside .checkentry, or things that really
>> are an error, such as xt_LED.c being unable to register its ledtrigger,
>> which is not a "user parameter error" and thus would not be pr_info.
>> 
>> If you see inconsistency, could you hint me towards it?
>
>Right, I didn't notice these were all outside of checkentry.

Branch has been prepared with the requested changes.

The following changes since commit 2c46cd8163b25bf6f38e612e9f1d162f0357c8f1:
  Zhitong Wang (1):
        netfilter: remove unused headers in net/ipv4/netfilter/nf_nat_h323.c

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (5):
      netfilter: xtables: make use of caller family rather than target family
      netfilter: xt extensions: use pr_<level> (2)
      netfilter: xtables: make use of xt_request_find_target
      netfilter: xtables: consolidate code into xt_request_find_match
      netfilter: xt_recent: allow changing ip_list_[ug]id at runtime

 include/linux/netfilter/x_tables.h  |    2 +
 net/bridge/netfilter/ebt_among.c    |   15 ++++-----
 net/bridge/netfilter/ebt_limit.c    |    3 +-
 net/bridge/netfilter/ebt_ulog.c     |   23 +++++---------
 net/bridge/netfilter/ebt_vlan.c     |   36 ++++++++--------------
 net/bridge/netfilter/ebtables.c     |   23 +++-----------
 net/ipv4/netfilter/arp_tables.c     |   20 +++++-------
 net/ipv4/netfilter/ip_tables.c      |   56 +++++++++++++++--------------------
 net/ipv4/netfilter/ipt_CLUSTERIP.c  |   46 ++++++++++++++--------------
 net/ipv4/netfilter/ipt_ECN.c        |   11 ++----
 net/ipv4/netfilter/ipt_LOG.c        |    7 ++--
 net/ipv4/netfilter/ipt_MASQUERADE.c |    8 ++--
 net/ipv4/netfilter/ipt_NETMAP.c     |    6 ++--
 net/ipv4/netfilter/ipt_REDIRECT.c   |    6 ++--
 net/ipv4/netfilter/ipt_REJECT.c     |    6 ++--
 net/ipv4/netfilter/ipt_ULOG.c       |   37 +++++++++-------------
 net/ipv4/netfilter/ipt_addrtype.c   |   14 ++++----
 net/ipv4/netfilter/ipt_ecn.c        |    5 +--
 net/ipv4/netfilter/nf_nat_rule.c    |    5 ++-
 net/ipv6/netfilter/ip6_tables.c     |   47 ++++++++++++-----------------
 net/ipv6/netfilter/ip6t_LOG.c       |    7 ++--
 net/ipv6/netfilter/ip6t_REJECT.c    |   20 ++++++------
 net/ipv6/netfilter/ip6t_ah.c        |    6 ++--
 net/ipv6/netfilter/ip6t_frag.c      |    6 ++--
 net/ipv6/netfilter/ip6t_hbh.c       |    6 ++--
 net/ipv6/netfilter/ip6t_rt.c        |    6 ++--
 net/netfilter/x_tables.c            |   15 +++++++--
 net/netfilter/xt_NFQUEUE.c          |    4 +-
 net/netfilter/xt_TCPMSS.c           |    7 ++--
 net/netfilter/xt_TPROXY.c           |    4 +-
 net/netfilter/xt_esp.c              |    2 +-
 net/netfilter/xt_iprange.c          |    1 +
 net/netfilter/xt_recent.c           |   14 ++++----
 net/netfilter/xt_socket.c           |    5 +--
 net/netfilter/xt_time.c             |    4 +-
 net/sched/act_ipt.c                 |    4 +-
 36 files changed, 218 insertions(+), 269 deletions(-)
