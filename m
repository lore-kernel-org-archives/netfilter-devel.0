From: Patrick McHardy <kaber@trash.net>
Subject: Re: [02/19] strtonum
Date: Sun, 20 Jan 2008 14:18:06 +0100
Message-ID: <47934A0E.9020308@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161448090.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57733 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYATNTF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:19:05 -0500
In-Reply-To: <Pine.LNX.4.64.0801161448090.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Introduce strtonum(), which works like string_to_number(), but passes
> back the 'end' pointer. It is useful where you want to do boundary
> checking yet work with strings that are not entirely slurped by
> strtoul(), e.g.:
> 
> 	s = "1/2"; /* one half */
> 	if (!strtonum(s, &end, &value, 0, 5))
> 		error("Zero-length string, or value out of bounds");
> 	if (*end != '/')
> 		error("Malformed string");
> 	info->param1 = value;
> 	if (!strtonum(end + 1, &end, &value, 2, 4))
> 		error("..");
> 	if (*end != '\0')
> 		error("Malformed string");
> 	info->param2 = value;
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Applied, thanks.

