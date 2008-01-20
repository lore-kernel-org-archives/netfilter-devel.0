From: Patrick McHardy <kaber@trash.net>
Subject: Re: [06/19] libxt_TOS
Date: Sun, 20 Jan 2008 14:24:20 +0100
Message-ID: <47934B84.40601@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161449530.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57872 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYATNZV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:25:21 -0500
In-Reply-To: <Pine.LNX.4.64.0801161449530.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Move libipt_TOS revision 0 to libxt_TOS revision 0 and add support
> for xt_TOS target revision 1.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libipt_TOS.c           |  159 -----------------------
>  extensions/libipt_TOS.man         |   11 -
>  extensions/libxt_TOS.c            |  257 ++++++++++++++++++++++++++++++++++++++
>  extensions/libxt_TOS.man          |   27 +++
>  include/linux/netfilter/xt_DSCP.h |    5 
>  5 files changed, 289 insertions(+), 170 deletions(-)

Applied.
