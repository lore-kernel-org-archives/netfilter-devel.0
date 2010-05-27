From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 17:53:02 -0300
Message-ID: <AANLkTinfHPE1YjwfHE-R-4CukNjXosQBKtD0T8A7nm4b@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	<1274905649.2542.1.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
	<AANLkTilwGbJn20DXLtyDCHFQm8eS4g3_AUyLrI-huNi8@mail.gmail.com>
	<1274992813.2446.22.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60760 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab0E0UxE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 16:53:04 -0400
Received: by fxm10 with SMTP id 10so225037fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 13:53:02 -0700 (PDT)
In-Reply-To: <1274992813.2446.22.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Mr. Dumazet

2010/5/27 Eric Dumazet <eric.dumazet@gmail.com>:
> Its right only if you have a single NIC, and a single queue one.

  I have the machine in bridge mode with two NICs: one pointing the
users, and the other pointing the routers.

  So I guess this is the "single NIC" case, right?

> Or else two SYN packets could flight in // in extrachain (using two
> cpus), and the logic would be wrong.

  Oh I see.

  So your suggestion is to mark everything with 0x0 to make sure that
if something goes wrong the first port will get the packet, right?

  If everything goes right, it'll get marked using the other rules, rig=
ht?

  Cheers,

=46elipe Damasio

> I suggest using a first 'catch all' rule in extrachain, to make sure =
one
> CONNMARK is done.
>
> Or else, some connections would not go through any TPROXY rule.
>
> Chain extrachain (1 references)
> target =A0 =A0 prot opt source =A0 =A0 =A0 =A0 =A0 =A0 =A0 destinatio=
n
>
> CONNMARK =A0 all =A0-- =A00.0.0.0/0 =A0 =A0 =A0 =A0 =A0 =A00.0.0.0/0 =
=A0 =A0 =A0 =A0 =A0 CONNMARK
> xset 0x0/0xffffffff
>
> CONNMARK =A0 all =A0-- =A00.0.0.0/0 =A0 =A0 =A0 =A0 =A0 =A00.0.0.0/0 =
=A0 =A0 =A0 =A0 =A0 statistic
> mode nth every 3 packet 1 CONNMARK xset 0x1/0xffffffff
>
> CONNMARK =A0 all =A0-- =A00.0.0.0/0 =A0 =A0 =A0 =A0 =A0 =A00.0.0.0/0 =
=A0 =A0 =A0 =A0 =A0 statistic
> mode nth every 3 packet 2 CONNMARK xset 0x2/0xffffffff
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
