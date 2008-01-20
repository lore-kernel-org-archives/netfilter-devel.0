From: Patrick McHardy <kaber@trash.net>
Subject: Re: [12/19] bunch o' renames
Date: Sun, 20 Jan 2008 14:35:19 +0100
Message-ID: <47934E17.9080200@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161451320.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbYATNgW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:36:22 -0500
In-Reply-To: <Pine.LNX.4.64.0801161451320.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Move a few functions from iptables.c/ip6tables.c to xtables.c
> so they are available for combined (both AF_INET and AF_INET6)
> libxt modules. Rename overlapping function names.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libipt_DNAT.c     |    4 -
>  extensions/libipt_NETMAP.c   |    4 -
>  extensions/libipt_SAME.c     |    8 +-
>  extensions/libipt_SNAT.c     |    4 -
>  extensions/libipt_policy.c   |    8 +-
>  extensions/libxt_conntrack.c |    7 +-
>  include/iptables.h           |    3 
>  include/xtables.h            |    8 ++
>  ip6tables.c                  |   91 ++------------------------
>  iptables.c                   |   84 +-----------------------
>  xtables.c                    |  148 +++++++++++++++++++++++++++++++++++++++++++
>  11 files changed, 190 insertions(+), 179 deletions(-)

Applied.
