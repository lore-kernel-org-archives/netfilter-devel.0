From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: rateest usage problem - slightly lost
Date: Fri, 5 Jun 2009 15:27:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051526430.7950@fbirervta.pbzchgretzou.qr>
References: <c4b050a10905310718h110e127cg6ee114cff0bc2f8c@mail.gmail.com> <c4b050a10905310924h20456bebj900c14226ad8dec5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48794 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZFEN15 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:27:57 -0400
In-Reply-To: <c4b050a10905310924h20456bebj900c14226ad8dec5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-05-31 18:24, Anton VG wrote:

>Seems finally I've got it working, and had to look at the sources of
>the xt_rateest.c to understand what it wants :)
>
>Possibly it's good to update man page with more examples of rateest
>usage, so it would be clear, that we have to use the first and the
>second (bps1 and bps2) parameters, and rateest give it's result as
>difference of them,[...]

If you have any concrete recommendations=C2=A0=E2=80=94 perhaps even yo=
ur use case=C2=A0=E2=80=94=20
on how to improve the wording, we would like to hear. Ideally in the=20
form of a patch, but an unformatted text/plain blob will also do.

> so the following
>
>iptables -t mangle -A PREROUTING -s $SOURCE -m rateest --rateest1
>$RATEESTIMATOR --rateest-bps1 0 --rateest-bps2 200kbit --rateest-lt -j
>MARK --set-mark $TARGETMARK
>
>will set mark only when estimated rate is below 200kbit
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
