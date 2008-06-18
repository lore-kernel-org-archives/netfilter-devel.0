From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD1 PATCH] Fix PCAP len (Jaap Keuter)
Date: Wed, 18 Jun 2008 17:23:48 +0200
Message-ID: <48592884.8020701@netfilter.org>
References: <1213801091-25885-1-git-send-email-eric@inl.fr> <485926BF.7010105@netfilter.org> <485927DF.3060601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50668 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752309AbYFRPXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:23:53 -0400
In-Reply-To: <485927DF.3060601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> This is a application of patch provided by Jaap Keuter. Application
>>> will close
>>> bugzilla 535. pcap len was set to value of the pointer to raw data.
>>
>> Applied. Thanks Eric.
> 
> BTW, did we actually release a new ulogd with the SuSE-fixes
> from .. about a year ago?

Indeed, I'll prepare two releases, one of ulogdv1 and development
version of ulogdv2.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
