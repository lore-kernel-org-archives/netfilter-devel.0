From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD1 PATCH] Fix PCAP len (Jaap Keuter)
Date: Wed, 18 Jun 2008 17:25:13 +0200
Message-ID: <485928D9.1000401@trash.net>
References: <1213801091-25885-1-git-send-email-eric@inl.fr> <485926BF.7010105@netfilter.org> <485927DF.3060601@trash.net> <48592884.8020701@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35531 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYFRPZP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:25:15 -0400
In-Reply-To: <48592884.8020701@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> Eric Leblond wrote:
>>>> This is a application of patch provided by Jaap Keuter. Application
>>>> will close
>>>> bugzilla 535. pcap len was set to value of the pointer to raw data.
>>> Applied. Thanks Eric.
>> BTW, did we actually release a new ulogd with the SuSE-fixes
>> from .. about a year ago?
> 
> Indeed, I'll prepare two releases, one of ulogdv1 and development
> version of ulogdv2.

Great, its really time for a ulogd2 beta.

