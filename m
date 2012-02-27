From: Darren Willis <djw@google.com>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Mon, 27 Feb 2012 13:18:58 +0900
Message-ID: <CAFntDkz4QtCrgHNFNp6Bn1dGco3HCWthYaFLN_-bUVb2q0wPjQ@mail.gmail.com>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
	<alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
	<CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
	<alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
	<CAFntDkx_aZ4Pvfg21yHUDYWcaG=pwk28xwjpv1Sh9q0B4N+TRw@mail.gmail.com>
	<20120224175420.GA11587@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54094 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2B0ES7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:18:59 -0500
Received: by vbbff1 with SMTP id ff1so582038vbb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2012 20:18:58 -0800 (PST)
In-Reply-To: <20120224175420.GA11587@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> 1) In the last Netfilter workshop, we decided that we're targeting
> towards explicit helper configuration via iptables, ie. something
> like:
>
> ip6tables -I OUTPUT -t raw -s $SRC -d $DST \
> =A0 =A0 =A0 =A0-p udp --dport 547 -j CT --helper dhcpv6
>
> According to your report, this is exactly what distributors don't
> want to do.

Interesting. Well, my impression is that distributions don't wan't to
add rules, but if they can't avoid it, they'll just have to cope.
Is this changeover coming in the immediate future?

> 2) The helper infrastructure is allowing us to filter broadcast
> traffic but I think that it's =A0been designed for a different purpos=
e.
> I know, we don't have any better by now. But in the meanwhile, we're
> adding specific helpers to support each broadcast protocol.

Agreed, while I think for now this helper is fine, I think it'd be
nice to have a more generic multicast/broadcast helper, although it'd
still need to have specific protocols baked into it to work (maybe
netbios, dhcpv6, mDNS, LLMNR, SSDP, neighbour discovery, other
things).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
