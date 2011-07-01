From: Anders Nilsson Plymoth <lanilsson@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Fri, 1 Jul 2011 17:08:08 +0200
Message-ID: <BANLkTinAD2gDYQntH4QRXRciB3ssG-_t0g@mail.gmail.com>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
 <1309340843.2532.112.camel@edumazet-laptop> <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
 <1309342096.2532.116.camel@edumazet-laptop> <4E0C15A3.9050609@yandex.ru>
 <1309416426.2532.119.camel@edumazet-laptop> <4E0C278B.7010403@yandex.ru>
 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4E0C651A.1000300@trash.net> <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4E0C8902.8070303@earthlink.net> <4E0C8D7F.3000902@trash.net>
 <1309453730.5846.31.camel@tiger.regit.org> <1309455919.2515.3.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52819 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1GAPI3 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:08:29 -0400
Received: by ewy4 with SMTP id 4so1158443ewy.19
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Jul 2011 08:08:28 -0700 (PDT)
In-Reply-To: <1309455919.2515.3.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I upgraded the kernel and distro but some only a little improvent. I
saw no failures to set the verdict, but many many packets drops in the
netfilter queue proc entry.

I saw the two submitted patches today, and will try those.

I think having an option on what to do with stuck packets makes a lot
of sense. I can think of several ways to handle this, and each have
different consequences depending on the type of packets in the queue.
Having them stuck in the buffer is really bad though.
If you do a massive ACCEPT, packets will probably arrive out of order,
which may cause problems for some protocols and apps. If you do a
massive DROP, TCP will deflate its window and TCP will cut down its
rate significantly. Here it might be better to some RED type dropping,
maybe successive single DROPs untill queue is empty of stuck packets.

Thanks,
Anders

On Thu, Jun 30, 2011 at 7:45 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>
> Le jeudi 30 juin 2011 =E0 19:07 +0200, Eric Leblond a =E9crit :
>
> > As the verdict failure is bound to occur in a high load time,
> > retransmission of the verdict (which is necessary) will not help th=
e
> > system to recover. Userspace has to deal with it but it has another
> > consequences which is that userspace software may suffer of case wh=
ere
> > successive failures occurs.
> >
> > In this scope, Florian's patch "netfilter: nfqueue: batch verdict
> > support" could be really useful. It could be used by userspace to
> > trigger an decide on all stucked packets. Issuing a massive ACCEPT =
could
> > lead to dynosaurus packet coming from ancient time but it could be =
ok if
> > batch occurs enough often.
> >
> > Is there a plan to accept it in mainstream ?
>
> Given that apparently some apps are not aware some of their verdicts =
are
> lost, I consider the BATCH idea would be a bad idea, unless DROP is
> used.
>
> If you have any doubt, only sane thing is to drop packets, not accept
> them.
>
> Maybe a single queue flag is needed : DROP_OLD_PACKETS, if user
> application is handling packets in order.
>
> Every time a verdict is given by application, automatically DROP all
> previous un-verdicted packets.
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
