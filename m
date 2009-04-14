From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Tue, 14 Apr 2009 18:10:54 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904141807430.21682@fbirervta.pbzchgretzou.qr>
References: <200904141744.57570.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	ipt_account@developer.intra2net.com, siarka2107@interia.pl
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56164 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbZDNQK4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:10:56 -0400
In-Reply-To: <200904141744.57570.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-04-14 17:44, Thomas Jarosch wrote:
>Hello,
>
>I'm pleased to announce the release of ipt_ACCOUNT 1.15.
>Changelog:
>- Support for kernel 2.6.29 / 2.6.28
>Get it from here:
>http://www.intra2net.com/en/developer/ipt_ACCOUNT/
>Best regards,
>Thomas Jarosch

Thomas,

guess I just forward this to you, as I do not want to touch ACCOUNT
just yet.


>Date: Mon, 6 Apr 2009 15:32:24
>From: Bogdan Siara (cc'ed) <siarka2107>
>To: Jan Engelhardt
>Subject: Re: Re: New matches and targets on xtables-addons

> On Monday 2009-04-06 14:05, Bogdan Siara wrote:
> 
>>>Hi Jan,
>>>Can You add new matches and targets to xtables-addons e.g.:
>>>- ipt_ACCOUNT
>>>  http://www.intra2net.com/en/developer/ipt_ACCOUNT/index.php
>>>- ipt_account http://code.google.com/p/ipt-account
>>>- ipt_weburl http://gargoyle-router.com/weburl-code
>> 
>>ACCOUNT requires a kernel patch, and patching the kernel is outside
>>the scope of Xt-a; For only including the iptables module, I would
>>want to have their consent.
>> 
>>weburl seems redundant with respect to the existence of xt_string and
>>xt_layer7, but feel free to convince me otherwise.
>
>Can You prepare ipt_ACCOUNT and ipt_account patches/files supported for 
>kernel 2.6.29?
