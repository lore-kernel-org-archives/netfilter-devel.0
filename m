From: Patrick McHardy <kaber@trash.net>
Subject: Re: [01/19] use automake
Date: Sun, 20 Jan 2008 14:13:04 +0100
Message-ID: <479348E0.4050701@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161446580.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57618 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYATNOI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:14:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801161446580.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Converts the iptables build infrastructure to autotools.
> 
> 	- Can build both static and dynamic at the same time
> 
> 	- iptables-static will be a multi-binary, semi-static
> 	(link against libc but w/o dynamic plugins)
> 
> 	- Always build IPv6 modules
> 
> 	- consider INSTALL
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Applied, thanks Jan.
