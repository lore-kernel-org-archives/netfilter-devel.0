From: Patrick McHardy <kaber@trash.net>
Subject: Re: [14/19] libxt_hashlimit checks
Date: Sun, 20 Jan 2008 14:38:23 +0100
Message-ID: <47934ECF.8090606@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161452250.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58105 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbYATNjW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:39:22 -0500
In-Reply-To: <Pine.LNX.4.64.0801161452250.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Add checks for libxt_hashlimit so that options cannot be passed twice
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libxt_hashlimit.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Applied, thanks.
