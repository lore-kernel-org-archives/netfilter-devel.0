From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/27] xt_connmark match, revision 1
Date: Fri, 04 Jan 2008 15:47:47 +0100
Message-ID: <477E4713.3090009@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022127380.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48559 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbYADOut (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:50:49 -0500
In-Reply-To: <Pine.LNX.4.64.0801022127380.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 375972a6ff3579f150bf916621b6fe752d29f25a
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:52:04 2008 +0100
> 
>     [NETFILTER]: xt_connmark match, revision 1
>     
>     Introduces the xt_connmark match revision 1. It uses fixed types,
>     eventually obsoleting revision 0 some day (uses nonfixed types).
>     (Unfixed types like "unsigned long" do not play well with mixed
>     user-/kernelspace "bitness", e.g. 32/64, as is common on SPARC64,
>     and need extra compat code.)
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Also applied.
