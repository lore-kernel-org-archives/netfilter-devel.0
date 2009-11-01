From: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Subject: Re: wishlist - IMQ in xtable-addons
Date: Sun, 1 Nov 2009 11:38:21 +0100 (MET)
Message-ID: <alpine.LNX.2.00.0911011114270.7628@cedric.unob.cz>
References: <20090902071842.GA561@openoffice.lt> <alpine.LSU.2.00.0911010204290.19549@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Ramunas Vabolis <ramuva@openoffice.lt>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cedric.unob.cz ([160.216.40.10]:36027 "EHLO cedric.unob.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZKAK5H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 05:57:07 -0500
In-Reply-To: <alpine.LSU.2.00.0911010204290.19549@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Although I havent received an OK for porting IMQ to Xt-a by its current
maintainer (Andre Correa), next on my TODO list after ACCOUNT, pknock
and stealth is to do an initial work on porting IMQ, becouse even for me,
IMQ is still much more useful than IFB and I simply dont like to see 
useful third party bits unmaintained (not to mention all the problems 
that individual kernel/userspace patching brings in for system 
integrators).
However, due to time constraints on my side, I can't predict finishing
timeframe, as of now. All I can promise now is that I'll start this
month, but will only come up with public patches if there's actually 
anything worth being immediately useful and tested. It may well take 2 or 
even 4 months, I dont know.

Hope this helps,

Jan


On Sun, 1 Nov 2009, Jan Engelhardt wrote:

>
>> Hello there,
>>
>> 	Is there any chances that IMQ might appear as another supported
>> module in xtable-addons?
>
>
> I have not seen any replies in the internet archives to this thread yet,
> so let me just Cc Jan Rafaj, who may be interested.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
