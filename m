From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] arptables: build an libarptc.a archive
Date: Sun, 24 Feb 2013 11:09:29 +0100
Message-ID: <5129E6D9.9000403@pandora.be>
References: <1361490336-4676-1-git-send-email-jonh.wendell@gmail.com> <alpine.LNX.2.01.1302220950030.1652@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jonh Wendell <jonh.wendell@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Jonh Wendell <jonh.wendell@oiwifi.com.br>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:55222 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3BXKJd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Feb 2013 05:09:33 -0500
In-Reply-To: <alpine.LNX.2.01.1302220950030.1652@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 22/02/2013 9:50, Jan Engelhardt schreef:
> On Friday 2013-02-22 00:45, Jonh Wendell wrote:
>
>> From: Jonh Wendell <jonh.wendell@oiwifi.com.br>
>>
>> this allows programs to statically link against libarptc.
> A shared library, should anyone ever wish to develop against arptc
> (which I doubt), is much preferable.
I've applied the patch. It's pretty common in embedded systems not to 
use shared libraries. If anyone wants a shared library, they'll have to 
provide a patch...
Hopefully the new nftables or xtables2 will support arptables and 
provide for a better alternative :-)

cheers,
Bart

