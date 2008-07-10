From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RAWNAT kernel crash
Date: Thu, 10 Jul 2008 12:11:00 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807101209050.27323@fbirervta.pbzchgretzou.qr>
References: <4875D2DC.9040107@gmx.de> <alpine.LNX.1.10.0807101119180.27323@fbirervta.pbzchgretzou.qr> <4875DCD0.9070107@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Manu <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44074 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYGJKLB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:11:01 -0400
In-Reply-To: <4875DCD0.9070107@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


(and don't strip the mailing list from cc)

On Thursday 2008-07-10 11:56, Manu wrote:
>
>>> I can set the rules but everytime I want to send traffic through the rules
>>> I got a system crash!?
>>
>> I will investigate... I assume you do have dcd0c66 at least?
>>   
> I don't know what you mean with dcd0c66. I downloaded the snapshot of
> 2008-04-28

Ah ok, if you click on that you will see "commit
dcd0c661355bc5ff95d3a587c49fa59d8c4a8fef"

>> Posting the crash would be helpful.
>
> What exactly do you mean with posting the crash?

Kernel log, oops dump. If you just say "crash", then that could be
anything, with cosmic rays to begin.
