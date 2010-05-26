From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Wed, 26 May 2010 16:01:07 -0300
Message-ID: <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:35872 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab0EZTBK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 15:01:10 -0400
Received: by ewy8 with SMTP id 8so221760ewy.28
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 12:01:08 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi Mr. Engelhardt,

2010/5/26 Jan Engelhardt <jengelh@medozas.de>:
> -A PREROUTING -m conntrack --ctstate NEW -j extrachain
> for (I =3D 0; I < N; ++I)
> =A0 =A0 =A0 =A0-A extrachain -m statistic --mode nth --every I \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-j CONNMARK --set-mark I
> for (I =3D 0; I < N; ++I)
> =A0 =A0 =A0 =A0-A PREROUTING -m connmark --mark I -j TPROXY \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0--tproxy-mark I/0xff --on-port I+3127

  You mean do this using:

N=3D48 (or whatever number of http_port we're using)

  So we create 48 rules using this setup?

  I can see why it'll work on the first 48 packets (one for each
rule), but what happens on the 49th new connection? It'll go on the
first rule again?

  Thanks,

=46elipe Damasio
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
