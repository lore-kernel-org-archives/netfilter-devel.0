From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 00:09:55 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>  <1274861468.2672.9.camel@edumazet-laptop>  <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>  <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
 <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr> <1274905649.2542.1.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49497 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab0EZWJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 18:09:57 -0400
In-Reply-To: <1274905649.2542.1.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-05-26 22:27, Eric Dumazet wrote:
>> >
>> >  So we create 48 rules using this setup?
>> 
>> Since there are two loops to be done, it would be 96 rules in total.
>> 
>> >  I can see why it'll work on the first 48 packets (one for each
>> >rule), but what happens on the 49th new connection? It'll go on the
>> >first rule again?
>> 
>> nth uses modulus, otherwise you can't get the "every Nth" semantic. :-)
>> 
>> (It should have been: --mode nth --every N --packet I)
>
>not exactly :)
>
>It should be --mode nth --every N-I --packet I
>
>(first rule consume one packet out of 48, then second rule consume one
>packet out of 47, ...

The second rule still consumes 48 packets, because CONNMARK is
non-terminating. Thus it's --every N.
