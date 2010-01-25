From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: ebtables extension 'http'
Date: Mon, 25 Jan 2010 15:45:50 -0200
Message-ID: <8a87046f1001250945p2e666b32m7c2051e00454f8e4@mail.gmail.com>
References: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>
	 <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr>
	 <8a87046f1001250632hd4220d1s9f44cad2c3b268a8@mail.gmail.com>
	 <alpine.LSU.2.01.1001251707500.20906@obet.zrqbmnf.qr>
	 <4B5DCBEA.5000501@trash.net>
	 <alpine.LSU.2.01.1001251753560.20906@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:41955 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0AYRpx convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:45:53 -0500
Received: by gxk9 with SMTP id 9so5622217gxk.8
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2010 09:45:52 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1001251753560.20906@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi Mr. Jan

2010/1/25 Jan Engelhardt <jengelh@medozas.de>:
> The issue is that you would need to replay the tcp handshake.
>
> Case 1:
> - do TCP handshake
> - read out Host: header
> - if proxied
> =A0- good
> - if not,
> =A0- have to replay TCP handshake to next host (eww :-)

  Would this be so bad? :-)

  I mean, if I could do this, I could reduce the HTTP traffic from
around 400Mbps to around 100Mbps of domains that the proxy actually do
cares.

  And the rest would be forwarded down the bridge.

  Could I do this with repeating the TCP handshake with the next host?
How could I do this?

  Thanks,

=46elipe Damasio
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
