From: Patrick McHardy <kaber@trash.net>
Subject: Re: [08/19] libxt_MARK r2
Date: Sun, 20 Jan 2008 14:30:25 +0100
Message-ID: <47934CF1.5030302@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161450190.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYATNbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:31:24 -0500
In-Reply-To: <Pine.LNX.4.64.0801161450190.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Add support for xt_MARK target revision 2.
> Also consolidate libip6t_MARK.man and libipt_MARK.man.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libip6t_MARK.man       |    6 -
>  extensions/libipt_MARK.man        |   13 ---
>  extensions/libxt_MARK.c           |  148 ++++++++++++++++++++++++++++++++++++++
>  extensions/libxt_MARK.man         |   25 ++++++
>  include/linux/netfilter/xt_MARK.h |    4 +
>  5 files changed, 177 insertions(+), 19 deletions(-)

Applied, thanks.
