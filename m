From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD1 PATCH] Fix PCAP len (Jaap Keuter)
Date: Wed, 18 Jun 2008 17:33:25 +0200
Message-ID: <20080618153325.GE20912@khasse.inl.fr>
References: <1213801091-25885-1-git-send-email-eric@inl.fr> <485926BF.7010105@netfilter.org> <485927DF.3060601@trash.net> <48592884.8020701@netfilter.org> <485928D9.1000401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, chifflier@inl.fr
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:59389 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYFRPd3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:33:29 -0400
Content-Disposition: inline
In-Reply-To: <485928D9.1000401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Wednesday, 2008 June 18 at 17:25:13 +0200, Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>>>> will close
>>>>> bugzilla 535. pcap len was set to value of the pointer to raw data.
>>>> Applied. Thanks Eric.
>>> BTW, did we actually release a new ulogd with the SuSE-fixes
>>> from .. about a year ago?
>>
>> Indeed, I'll prepare two releases, one of ulogdv1 and development
>> version of ulogdv2.
>
> Great, its really time for a ulogd2 beta.

Pierre and I have just found a bug on mac address handling. I will fix
this and send you the patch (should be tonight). My test system was
INPUT, OUTPUT only and switching to a FORWARD one reveal some problems.

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
