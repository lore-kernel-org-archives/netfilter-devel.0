From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 15:46:08 +0200
Message-ID: <AANLkTinjsUCRxAUp-v=OGOLtJAtPTVqkD2pLqRXnS7Tr@mail.gmail.com>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
	<AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
	<1283175267.3085.21.camel@chilepepper>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57419 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0H3NqJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:46:09 -0400
Received: by wyb35 with SMTP id 35so6618582wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 06:46:08 -0700 (PDT)
In-Reply-To: <1283175267.3085.21.camel@chilepepper>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

thanks luciano. but i'm a newbie...i don't understand your
explanation...can you help me? please :)

On Mon, Aug 30, 2010 at 3:34 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> On Mon, 2010-08-30 at 15:25 +0200, ext Nicola Padovano wrote:
>> i make an error the iptables line is:
>> =A0iptables -A INPUT -s 127.0.0.1 -p icmp -j TAR
>>
>> On Mon, Aug 30, 2010 at 3:22 PM, Nicola Padovano
>> <nicola.padovano@gmail.com> wrote:
>> > Hi all!
>> > I've write the following =A0(and dummy) module that drops all pack=
et...
>> > but...now? after i write the module i can use it?
>> > for example: i want digit:
>> > iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP
>> > but i don't know how create this new target...
>> > I've modified the netfilter makefile e Kbuild file (in net/netfilt=
er),
>> > and then i've do 'make' 'make modules' 'make modules_install' but
>> > after i digit iptables i have this message
>> >
>> > "iptables v1.4.2: Couldn't load target `TAR':/lib/xtables/libipt_T=
AR.
>> > so: cannot open shared object file: No such file or directory"
>> >
>> > what's my problem?
>
> You need to add support for your new target in the iptables userspace
> tool as well. =A0Check the source code here:
>
> https://git.netfilter.org/cgi-bin/gitweb.cgi?p=3Diptables.git;a=3Dsum=
mary
>
> You need to add a new extension file called extensions/libipt_TAR.c, =
the
> rest should take care of itself ;)
>
> --
> Cheers,
> Luca.
>
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
