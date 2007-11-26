From: Patrick McHardy <kaber@trash.net>
Subject: Re: [oops] in text matching
Date: Mon, 26 Nov 2007 08:43:26 +0100
Message-ID: <474A791E.4010807@trash.net>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>	 <1194547827.3298.5.camel@ierdnac>  <4735AAC6.7040605@trash.net> <1194936719.10588.0.camel@ierdnac> <47394ABA.3070109@trash.net> <47499708.5070502@trash.net> <4749CD51.1000906@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: andrei.popa@i-neo.ro, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48070 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbXKZHoM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:44:12 -0500
In-Reply-To: <4749CD51.1000906@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
>> Pablo? I would prefer to get this fixed before 2.6.24, unless
>> there's a better fix I'm going to include my patch to reject
>> pattern lengths of 0. Thanks.
> 
> Sorry for the late reply. Why should we accept zero length patterns?
> Would you consider this patch? It keeps consistent the return value of
> all textsearch approaches when a zero length pattern is passed.

The other ones actually seem to handle it fine, and I think
it should actually behave similar to memcmp or strcmp, so I'd
prefer a patch to handle it properly by always matching.

