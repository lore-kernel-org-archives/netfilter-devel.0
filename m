From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 15:10:12 +0100
Message-ID: <4BAB6EC4.9080006@pandora.be>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:36873 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0CYOKQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:10:16 -0400
In-Reply-To: <1269521809-29393-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

You seem to be removing all information about which module is
responsible for the message. Are you planning on a scheme to define the
pr_fmt macro for each module or did I miss something?

cheers,
Bart


Jan Engelhardt wrote:
> Supplement to 1159683ef48469de71dc26f0ee1a9c30d131cf89.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/bridge/netfilter/ebt_among.c    |   15 +++++-------
>  net/bridge/netfilter/ebt_limit.c    |    3 +-
>  net/bridge/netfilter/ebt_ulog.c     |   26 +++++++++++---------
>  net/bridge/netfilter/ebt_vlan.c     |   36 ++++++++++------------------
>  net/bridge/netfilter/ebtables.c     |    5 +--
>  net/ipv4/netfilter/ip_tables.c      |   18 ++++++--------
>  net/ipv4/netfilter/ipt_CLUSTERIP.c  |   43 ++++++++++++++++++-----------------
>  net/ipv4/netfilter/ipt_ECN.c        |   11 +++-----
>  net/ipv4/netfilter/ipt_LOG.c        |    7 ++---
>  net/ipv4/netfilter/ipt_MASQUERADE.c |    8 +++---
>  net/ipv4/netfilter/ipt_NETMAP.c     |    6 ++--
>  net/ipv4/netfilter/ipt_REDIRECT.c   |    6 ++--
>  net/ipv4/netfilter/ipt_REJECT.c     |    6 ++--
>  net/ipv4/netfilter/ipt_ULOG.c       |   40 +++++++++++++++-----------------
>  net/ipv4/netfilter/ipt_addrtype.c   |   14 +++++-----
>  net/ipv4/netfilter/ipt_ecn.c        |    5 +--
>  net/ipv6/netfilter/ip6_tables.c     |    9 +++----
>  net/ipv6/netfilter/ip6t_LOG.c       |    7 ++---
>  net/ipv6/netfilter/ip6t_REJECT.c    |   20 ++++++++--------
>  net/ipv6/netfilter/ip6t_ah.c        |    6 ++--
>  net/ipv6/netfilter/ip6t_frag.c      |    6 ++--
>  net/ipv6/netfilter/ip6t_hbh.c       |    6 ++--
>  net/ipv6/netfilter/ip6t_rt.c        |    6 ++--
>  net/netfilter/xt_TCPMSS.c           |    7 ++---
>  net/netfilter/xt_TPROXY.c           |    4 +-
>  net/netfilter/xt_esp.c              |    2 +-
>  net/netfilter/xt_iprange.c          |    1 +
>  net/netfilter/xt_recent.c           |    6 ++--
>  net/netfilter/xt_socket.c           |    5 +--
>  net/netfilter/xt_time.c             |    4 +-
>  30 files changed, 158 insertions(+), 180 deletions(-)
> 


-- 
Bart De Schuymer
www.artinalgorithms.be
