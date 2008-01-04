From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 14/27] xt_helper match, revision 1
Date: Fri, 04 Jan 2008 16:03:58 +0100
Message-ID: <477E4ADE.5030308@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022129130.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48951 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYADPHA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:07:00 -0500
In-Reply-To: <Pine.LNX.4.64.0801022129130.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit c3c5674fee490f6735136b2c9a7e39a30f25635e
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:01:06 2008 +0100
> 
>     [NETFILTER]: xt_helper match, revision 1
>     
>     Introduces the xt_helper match revision 1. It uses fixed types, and
>     its structure size has been adjusted.
>     
>     The xt_helper revision 0 structure had an odd size of 34 bytes. I
>     changed this into 32 bytes, which probably plays much better with
>     cachelines. The invert flag is also shrunk so now there is an
>     additional byte available for the name as a side effect.


Is there any real advantage in doing this? There aren't any
compatibility issues, so it seems a bit pointless to add a
new revision for this minor layout change.
