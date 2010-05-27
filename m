From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 12:30:19 +0200
Message-ID: <AANLkTil_CCT7f8-Ih6v55tSf96gRtnRqs_lSuF07AyR4@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	<1274905649.2542.1.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59365 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0E0KaU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 06:30:20 -0400
Received: by pwi7 with SMTP id 7so656652pwi.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 03:30:19 -0700 (PDT)
In-Reply-To: <1274905649.2542.1.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> not exactly :)
>
> It should be --mode nth --every N-I --packet I
>
> (first rule consume one packet out of 48, then second rule consume one
> packet out of 47, ...

I thought -j CONNMARK wasn't terminal?
