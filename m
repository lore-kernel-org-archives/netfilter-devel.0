From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [NETFILTER]: xt_recent: IPv6 support
Date: Wed, 09 Apr 2008 14:48:21 +0200
Message-ID: <47FCBB15.90003@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <e6fb8173fde4f1ea0cee785b763a2b2b37a89ebb.1207668694.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44766 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYDIMsX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:48:23 -0400
In-Reply-To: <e6fb8173fde4f1ea0cee785b763a2b2b37a89ebb.1207668694.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> This updates xt_recent to support the IPv6 address family.
> The new /proc/net/xt_recent directory must be used for this.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> ---
>  Documentation/feature-removal-schedule.txt |    3 +
>  net/netfilter/xt_recent.c                  |  271 ++++++++++++++++----
>  2 files changed, 221 insertions(+), 53 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 0209a5a..9b54720 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -249,6 +249,9 @@ What (Why):
>  	- xt_mark match revision 0
>  	  (superseded by xt_mark match revision 1)
>  
> +	- xt_recent: the old ipt_recent proc dir
> +	  (superseded by /proc/net/xt_recent)
> +

Could you introduce a new option for this please? Something
like CONFIG_NF_CONNTRACK_PROC_COMPAT.

Another thing is .. while I'm very much in favour of removing
old crap, I don't think feature-removal-schedule helps much
for informing users since basically nobody reads it (I know
I don't). So perhaps we should add a WARN_ON_ONCE or something
to interfaces scheduled for removal. Just meant for discussion,
not to be done in this patch yet.
