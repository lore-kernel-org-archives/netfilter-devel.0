From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/5] netfilter: xtables: use __uXX guarded types for userspace
 exports
Date: Thu, 20 Jan 2011 16:16:58 +0100
Message-ID: <4D3851EA.2060905@trash.net>
References: <1295363820-14881-1-git-send-email-jengelh@medozas.de> <1295363820-14881-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38779 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab1ATPRA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:17:00 -0500
In-Reply-To: <1295363820-14881-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 18.01.2011 16:16, schrieb Jan Engelhardt:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  include/linux/netfilter_bridge/ebt_802_3.h     |   24 ++++++++++++------------
>  include/linux/netfilter_bridge/ebt_among.h     |    2 +-
>  ...


This patch introduces a bunch of warnings with CONFIG_HEADERS_CHECK:

  CHECK   include/linux/netfilter (66 files)
/home/kaber/src/nf/nf-next-2.6/usr/include/linux/netfilter/xt_CT.h:7:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/kaber/src/nf/nf-next-2.6/usr/include/linux/netfilte
/xt_TCPOPTSTRIP.h:10: found __[us]{8,16,32,64} type without #include
<linux/types.h>
/home/kaber/src/nf/nf-next-2.6/usr/include/linux/netfilter/xt_TPROXY.h:8: found
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kaber/src/nf/nf-next-2.6/usr/include/linux/netfilter/xt_cluster.h:9:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/kaber/src/nf/nf-next-2.6/usr/include/linux/netfilter/xt_connlimit.h:25:
found __[us]{8,16,32,64} type without #include <linux/types.h>
...
