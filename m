From: Patrick McHardy <kaber@trash.net>
Subject: Re: [04/19] libxt_owner
Date: Sun, 20 Jan 2008 14:20:53 +0100
Message-ID: <47934AB5.3000508@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161449150.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57786 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbYATNVx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:21:53 -0500
In-Reply-To: <Pine.LNX.4.64.0801161449150.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Import libxt_owner into iptables
> 
> 
> libxt_owner merges libipt_owner and libip6t_owner, and adds support
> for the xt_owner match revision 1.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libip6t_owner.c         |  240 ---------------
>  extensions/libip6t_owner.man       |   23 -
>  extensions/libipt_owner.c          |  241 ---------------
>  extensions/libipt_owner.man        |   28 -
>  extensions/libxt_owner.c           |  574 +++++++++++++++++++++++++++++++++++++
>  extensions/libxt_owner.man         |   16 +
>  include/linux/netfilter/xt_owner.h |   16 +
>  7 files changed, 606 insertions(+), 532 deletions(-)

Applied, thanks.
