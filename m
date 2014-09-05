From: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Subject: Re: iptables: missing connlabel.conf causes unnecessary error messages
Date: Fri, 5 Sep 2014 11:47:36 +0200
Message-ID: <CAAXf6LVWzjt_becB7dwFNtcevGZn-nsGxACtZHqrv+4MUSsSaA@mail.gmail.com>
References: <CAAXf6LW4zfxOMeUO4=UPFUX=0VGjLbM_wKhdb3L7DK4SPBmbhg@mail.gmail.com>
 <20140905091305.GB934@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:50401 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbaIEJr6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:47:58 -0400
Received: by mail-lb0-f173.google.com with SMTP id c11so13080551lbj.4
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Sep 2014 02:47:57 -0700 (PDT)
In-Reply-To: <20140905091305.GB934@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Sep 5, 2014 at 11:13 AM, Florian Westphal <fw@strlen.de> wrote:
> Thomas De Schampheleire <patrickdepinguin@gmail.com> wrote:
>> Commit http://git.netfilter.org/iptables/commit/?id=51340f7b6a1103b12d86ef488f7140406d80401e
>> removed the default /etc/xtables/connlabel.conf file distributed with netfilter.
>>
>> From this commit onwards, every call to iptables will show the message:
>>     cannot open connlabel.conf, not registering 'connlabel' match: No
>> such file or directory
>
> Right, this happens for static builds.

If with 'static' you mean 'statically linked', then this is not correct.
My iptables application is dynamically linked:

~ # LD_TRACE_LOADED_OBJECTS=1 iptables
        libip4tc.so.0 => /usr/lib32/libip4tc.so.0 (0x006f1000)
        libip6tc.so.0 => /usr/lib32/libip6tc.so.0 (0x00707000)
        libxtables.so.10 => /usr/lib32/libxtables.so.10 (0x0071d000)
        libnetfilter_conntrack.so.3 =>
/usr/lib32/libnetfilter_conntrack.so.3 (0x00737000)
        libmnl.so.0 => /usr/lib32/libmnl.so.0 (0x0075c000)
        libnfnetlink.so.0 => /usr/lib32/libnfnetlink.so.0 (0x00770000)
        libdl.so.2 => /lib32/libdl.so.2 (0x00785000)
        libm.so.6 => /lib32/libm.so.6 (0x00798000)
        libc.so.6 => /lib32/libc.so.6 (0x00883000)
        /lib32/ld.so.1 (0x006c2000)

A prerequisite to seeing this message does seem to be the presence of
libnetfilter_conntrack (during the compilation of iptables).

>
>> Creating an empty connlabel.conf file does not really help, the
>> message now becomes:
>>     cannot open connlabel.conf, not registering 'connlabel' match: Success
>
> Thats a bug.
>
>> Moreover, I do not understand the reasoning of the mentioned commit:
>> what is the problem in respecting sysconfdir? There are so many
>> applications and libraries that use autoconf and can have
>> configuration files in a place respecting sysconfdir.
>
> Because then every libnetfiler_conntrack mapping call in
> non-iptables software has to 'guess' where iptables' sysconfdir is.

Ok, understood.

>
>> Finally, even if you do not want to provide a default file with the
>> iptables installation, an empty file (created by the user) should hide
>> the error message.
>>
>> What is your view on this?
>
> Agreed.
> If there are no other comments, I will push following patch later today:

Deferring the opening of the file until you really need it seems a
good solution indeed.
However, the 'static' mentions in your proposed patch may need
adaptation based on the discussion above.

Thanks,
Thomas
