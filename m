From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TEE for IPv6
Date: Fri, 21 Nov 2008 01:16:45 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811210115290.30112@fbirervta.pbzchgretzou.qr>
References: <48D93817.40909@critical.com> <alpine.LNX.1.10.0810072057470.5686@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sebastian.classen@freenet.ag,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Mike Wileczka <mike.wileczka@critical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49386 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbYKUAQr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 19:16:47 -0500
In-Reply-To: <alpine.LNX.1.10.0810072057470.5686@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-08 03:09, Jan Engelhardt wrote:
>On Tuesday 2008-09-23 14:40, Mike Wileczka wrote:
>
>> Hello, It appears that the TEE target is not supported under IPv6. 
>> Is that true?  Is there any quick way to get it working?
>
>It is true that there is currently no code for handling IPv6.

I now added a compile-tested-only "TEE6" branch to the git repository;
feel free to try at your own risk.
