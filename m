From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 16:21:15 +0200
Message-ID: <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
	<AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
	<4C7BB8DF.7040208@kaleco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: justin@kaleco.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57568 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0H3OVQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:21:16 -0400
Received: by fxm13 with SMTP id 13so3236287fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 07:21:15 -0700 (PDT)
In-Reply-To: <4C7BB8DF.7040208@kaleco.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ok justin thank you!
for now I only need standalone package (to test my code, in future i
will see how xtables-addons works).
but (there is always a "but")  the problem, justin, isn't the copy of
libxt_foo.so in /lib/xtables, but it is the creation of this library.
as i said before, when i compile the module i don't have no
lixt_foo.so file. So, how i can create it?

sorry for my ignorance, i've started with kernel programming only a few=
 day ago.

thanks!

On Mon, Aug 30, 2010 at 3:57 PM, Justin Kamerman <justin@kaleco.net> wr=
ote:
> Nicola,
> iptables is complaining because it can't locate the userspace compani=
on
> to your netfilter module. The userspace companion tells iptables whic=
h
> kernel module to load and parses command line options before they are
> passed to the kernel module. The module_install target takes care of =
the
> kernel module but you also need a userspace helper installed to
> /lib/xtables. If building standalone (as opposed to using the
> Xtables-addons framework) you could use a maekfile rule like:
>
> libs_install:
> =A0 =A0 =A0 =A0cp -f libxt_ipaddr.so /lib/xtables
>
> Regards,
> Justin Kamerman
>
> On 10-08-30 10:25 AM, Nicola Padovano wrote:
>> -s 127.0.0.1 -p icmp -j DROP
>> > but i don't know how create this new target...
>> > I've modified the netfilter makefile e Kbuild file (in net/netfilt=
er)
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
