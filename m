From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [01/19] use automake
Date: Sun, 20 Jan 2008 17:51:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201749530.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801161446580.4953@fbirervta.pbzchgretzou.qr>
 <479348E0.4050701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60974 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbYATQvo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:51:44 -0500
In-Reply-To: <479348E0.4050701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 14:13, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Converts the iptables build infrastructure to autotools.
>> 
>>  - Can build both static and dynamic at the same time
>> 
>>  - iptables-static will be a multi-binary, semi-static
>>  (link against libc but w/o dynamic plugins)
>> 
>>  - Always build IPv6 modules
>> 
>>  - consider INSTALL
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> Applied, thanks Jan.

Looks like libiptc/Makefile missed the deletion.
