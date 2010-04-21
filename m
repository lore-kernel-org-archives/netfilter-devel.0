From: Bruno Moreira Guedes <thbmatrix@gmail.com>
Subject: Re: Recalculate checksums in netfilter queue
Date: Tue, 20 Apr 2010 23:02:09 -0300
Message-ID: <x2t3fdd6ce01004201902x33440642rd1189d2852aa57a@mail.gmail.com>
References: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f227.google.com ([209.85.217.227]:59657 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0DUCCL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:02:11 -0400
Received: by gxk27 with SMTP id 27so6433022gxk.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2010 19:02:10 -0700 (PDT)
In-Reply-To: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2010/4/20 Justin Yaple <yaplej@gmail.com>:
> Hello,
>
> I am having some trouble figuring out how to re-calculate the tcp/ip
> checksums after pulling a packet into user space with
> libnetfilter_queue. =A0In a netfilter hook I was able to use this:
> tcph->check =3D 0;
> tcph->check =3D tcp_v4_check(tcph, tcplen,
> =A0 =A0 =A0 =A0iph->saddr,
> =A0 =A0 =A0 =A0iph->daddr,
> =A0 =A0 =A0 =A0csum_partial((char *)tcph, tcplen, 0));
> =A0 =A0 =A0 =A0iph->check =3D 0;
> =A0 =A0 =A0 =A0ip_send_check(iph); //ip checksum
>
> In user space these functions tcp_v4_check(), csum_partial() and
> ip_send_check() do not exists. =A0Are there equivalent functions in u=
ser
> space so I can recalculate the ip/tcp checksums before passing the ne=
w
> packet back to the kernel with nfq_set_verdict()?
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Hello Justin!

If you solve this problem, I'll be too grateful, because I'm looking
for a solution since the last year in order to do NAT in userspace.
Good luck.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
