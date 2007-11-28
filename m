From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [oops] in text matching
Date: Wed, 28 Nov 2007 18:07:07 +0100
Message-ID: <474DA03B.8050400@netfilter.org>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>	 <1194547827.3298.5.camel@ierdnac>  <4735AAC6.7040605@trash.net> <1194936719.10588.0.camel@ierdnac> <47394ABA.3070109@trash.net> <47499708.5070502@trash.net> <4749CD51.1000906@netfilter.org> <474A791E.4010807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: andrei.popa@i-neo.ro, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40239 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757148AbXK1RHT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:07:19 -0500
In-Reply-To: <474A791E.4010807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>>> Pablo? I would prefer to get this fixed before 2.6.24, unless
>>> there's a better fix I'm going to include my patch to reject
>>> pattern lengths of 0. Thanks.
>>
>> Sorry for the late reply. Why should we accept zero length patterns?
>> Would you consider this patch? It keeps consistent the return value of
>> all textsearch approaches when a zero length pattern is passed.
> 
> The other ones actually seem to handle it fine, and I think
> it should actually behave similar to memcmp or strcmp, so I'd
> prefer a patch to handle it properly by always matching.

Indeed, KMP supports zero length patterns but I don't know how :).
kmp_find() accesses kmp->pattern[0] -which actually points 4 bytes out
of the ts_config structure- to compare it with text[i], then if those 4
bytes doesn't match text[i], then returns a matching at position 1.

I think that a zero length pattern is a unspecified entry that we should
reject. Also, returning some error to tell the user that is passing a
zero length pattern -something that is probably what he didn't really
want as it happens to Andrei.

I can cook a patch for iptables to reject zero length pattern with a
nice error message, thus avoiding the EINVAL that will probably go nuts
users.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
