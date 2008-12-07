From: Patrick McHardy <kaber@trash.net>
Subject: Re: src: remove unused include files
Date: Sun, 07 Dec 2008 16:54:41 +0100
Message-ID: <493BF1C1.1090608@trash.net>
References: <alpine.LNX.1.10.0812071345540.17915@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43726 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYLGPyr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Dec 2008 10:54:47 -0500
In-Reply-To: <alpine.LNX.1.10.0812071345540.17915@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> src: remove unused include files
> 
> No .c files include any of these - in fact they seem to be remnants
> missed during commit b1f568309a09e61f892dee3c23279cecff0b0ff4 -
> so remove them.

Applied, thanks.

