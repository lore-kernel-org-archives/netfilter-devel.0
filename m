From: Akemi Yagi <amyagi@gmail.com>
Subject: Re: Linux 4.2 build error in net/netfilter/ipset/ip_set_hash_netnet.c
Date: Mon, 13 Jul 2015 09:46:19 -0700
Message-ID: <CABA31DorMPXf2tbzfF5XksMD7hbL77r5WVEDRWYbAmWDQfCE7w@mail.gmail.com>
References: <CAHTgTXUmreHAqPfgGEd+GJNb_OEzaCuytqBTjZsE2GDqiy3TCw@mail.gmail.com>
 <20150705153520.GA23589@roeck-us.net> <mo0o3b$g5d$1@ger.gmane.org> <20150713164122.GA26283@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Alan Bartlett <ajb@elrepo.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:36371 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbGMQqk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jul 2015 12:46:40 -0400
Received: by ykay190 with SMTP id y190so43945450yka.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2015 09:46:39 -0700 (PDT)
In-Reply-To: <20150713164122.GA26283@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 13, 2015 at 9:41 AM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> On Mon, Jul 13, 2015 at 04:13:31PM +0000, Akemi Yagi wrote:
>> On Sun, 05 Jul 2015 08:35:20 -0700, Guenter Roeck wrote:
>>
>> > On Sat, Jul 04, 2015 at 12:44:36AM -0700, Vinson Lee wrote:
>> >> Hi.
>> >>
>> >> With the latest Linux 4.2-rc1, I am hitting this build error with=
 GCC
>> >> 4.4.7 on CentOS 6.
>> >>
>> >>   CC      net/netfilter/ipset/ip_set_hash_netnet.o
>> >> net/netfilter/ipset/ip_set_hash_netnet.c: In function
>> >> =E2=80=98hash_netnet4_uadt=E2=80=99:
>> >> net/netfilter/ipset/ip_set_hash_netnet.c:163: error: unknown fiel=
d
>> >> =E2=80=98cidr=E2=80=99 specified in initializer
>> >> net/netfilter/ipset/ip_set_hash_netnet.c:163: warning: missing br=
aces
>> >> around initializer net/netfilter/ipset/ip_set_hash_netnet.c:163:
>> >> warning: (near initialization for =E2=80=98e.<anonymous>.ip=E2=80=
=99)
>> >> net/netfilter/ipset/ip_set_hash_netnet.c: In function
>> >> =E2=80=98hash_netnet6_uadt=E2=80=99:
>> >> net/netfilter/ipset/ip_set_hash_netnet.c:388: error: unknown fiel=
d
>> >> =E2=80=98cidr=E2=80=99 specified in initializer
>> >> net/netfilter/ipset/ip_set_hash_netnet.c:388: warning: missing br=
aces
>> >> around initializer net/netfilter/ipset/ip_set_hash_netnet.c:388:
>> >> warning: (near initialization for =E2=80=98e.ip[0]=E2=80=99)
>> >>
>> > Previously fixed with commit 1a869205c75cb ("netfilter: ipset: The
>> > unnamed union initialization may lead to compilation error"),
>> > reintroduced with commit aff227581ed1a ("netfilter: ipset: Check C=
IDR
>> > value only when attribute is given").
>> >
>> > Guenter
>>
>> I wonder what can be done to get this issue fixed. This problem was =
seen
>> in 4.2-rc1 and now in 4.2-rc2 on RHEL-6.6.
>>
>> $ gcc --version
>> gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-11)
>
> Could you please test this patch? Thank you.

Thanks for the patch. We will test this and report back to you.

Akemi
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
