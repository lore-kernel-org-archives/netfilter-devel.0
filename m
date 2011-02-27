From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN
 retransmissions after SYN+ACK
Date: Sun, 27 Feb 2011 04:08:42 +0200
Message-ID: <AANLkTi=yip8CG+1oC0s_Wb8u_ymw2F1UnLdBy7jNHLS3@mail.gmail.com>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence>
 <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu> <4D695E73.2090006@netfilter.org>
 <alpine.DEB.2.00.1102262238360.23113@blackhole.kfki.hu> <4D698FCB.6060205@netfilter.org>
 <4D699421.4070309@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65394 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1B0CJX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 21:09:23 -0500
Received: by wwb22 with SMTP id 22so1804690wwb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Feb 2011 18:09:22 -0800 (PST)
In-Reply-To: <4D699421.4070309@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It's a bit off-topic, but can it be recommended to hack into nf_ct_tcp
somehow changing it's structure to assign each connection unique id
and pass it with each retransmission event detected to nfqueue -
without setting too complicated skbuffs / iptables rules? Or this is
considered as dirty hacking and should be implemented other way?

Reasons to do this: currently, trying to set up a small NFQUEUE-based
program that will modify data in TCP streams, that causes
retransmissions due to changed size thus requires SEQ/ACK tuning (and
as far as I suspect, something deeper than a filter table affects the
idea, but it's the separate question) and the network-caused
retransmissions are a bit of pain to track.

On 27 February 2011 02:00, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
>
> On 27/02/11 00:42, Pablo Neira Ayuso wrote:
> > On 26/02/11 22:45, Jozsef Kadlecsik wrote:
> >> On Sat, 26 Feb 2011, Pablo Neira Ayuso wrote:
> >>> I have test it here, it works fine. Let me know if you're OK with=
 it.
> >>
> >> The patch looks OK but I think Changli Gao is also right and it'd =
be
> >> simpler to set the [reply][synack][SR] state to sIG. What do you t=
hink?
> >
> > I read his email before leaving and after I made the new patch.
> >
> > Indeed, his idea is simpler, here's a new patch. I tested it here, =
it
> > works fine.
> >
> > Patrick, please apply!
>
> Hm, I forgot to include the description. New patch attached.



--
=F3 =D5=D7=C1=D6=C5=CE=C9=C5=CD,
=E9=C7=CF=D2=D8
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
