From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/9] netfilter: xtables: slightly more detailed checkentry
 return values
Date: Thu, 18 Mar 2010 12:14:32 +0100
Message-ID: <4BA20B18.9060606@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-3-git-send-email-jengelh@medozas.de> <4BA0DB87.9040709@trash.net> <alpine.LSU.2.01.1003171443330.6297@obet.zrqbmnf.qr> <4BA0E450.3010902@trash.net> <alpine.LSU.2.01.1003171522020.6297@obet.zrqbmnf.qr> <4BA0E8F7.6050905@trash.net> <4BA0E9F9.80502@trash.net> <alpine.LSU.2.01.1003171648590.8633@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45997 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0CRLOe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:14:34 -0400
In-Reply-To: <alpine.LSU.2.01.1003171648590.8633@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-17 15:40, Patrick McHardy wrote:
>>> OK that seems mostly fine. Basically its just the NULL/ENOENT
>>> interpretation that might be confusing.
>> One more thing though - I really don't like the strange mix of booleans
>> and errno codes. If you want to change this,
> 
> I'm pretty indifferent, but what if I don't want to change it? :-)

s/If/When/ :)

> Is it so bad to keep EINVAL and unspecified-error separated at the extension
> level?

It diverges from the well established return conventions in the kernel
for no reason. That's inviting bugs.
