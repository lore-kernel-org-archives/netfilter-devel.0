From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Wed, 26 May 2010 18:49:16 -0300
Message-ID: <AANLkTikl9W9Ij6ODywJQQ2X-OHau7eCVPXRrP0P2hWBt@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	<1274905649.2542.1.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:17101 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab0EZVtS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 17:49:18 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1038740fga.1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 14:49:17 -0700 (PDT)
In-Reply-To: <1274905649.2542.1.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi Mr Dumazet and Mr Engelhardt,

2010/5/26 Eric Dumazet <eric.dumazet@gmail.com>:

>> nth uses modulus, otherwise you can't get the "every Nth" semantic. :-)
>>
>> (It should have been: --mode nth --every N --packet I)
>
> not exactly :)
>
> It should be --mode nth --every N-I --packet I
>
> (first rule consume one packet out of 48, then second rule consume one
> packet out of 47, ...

  Great, thanks. Just so I can understand it right, the 49th new
connection will be handled by the first rule, right?

  One last thing, mr. Engelhardt:

  Why did you suggest the "--tproxy-mark I/0xff" part on the first email?

  Why can't I let the old "--tproxy-mark 0x1/0x1"?

   Please correct me if I'm wrong, but I don't think the tproxy-mark
is needed for your script to work (since the packet was marked with $I
on the rule above with CONNMARK. Or is it? :-)

  Cheers,

Felipe Damasio
