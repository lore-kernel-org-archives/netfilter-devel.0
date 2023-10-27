Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791FFC25B6B
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Oct 2023 02:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjJ0CKs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 22:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJ0CKr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 22:10:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A5AD7
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 19:10:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ca3a54d2c4so14094475ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 19:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698372644; x=1698977444; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EbUsnywrZyRZETNCGtcaZV+hPx97r5Qhgb2mgN3Ht40=;
        b=PR/ZkTyowBOChmHjn77q4bn+4fa/Yycks6eQk4YdV5PFOFijk2ejvZwbGVZZn8+kUD
         RNbjT8b3UAm5A4gKlNQtYtZe0S+qALERg5zomuJzYyKavkYarJMABDKYkRdjTz5YbxWu
         Xv19AueaIKNZ+vi+C7khOih2ZoKwfWO8n7KbNjE8qrhhQqYGqx42AqW6NymrHiuRELOS
         NIymQkDMK/q0LXfdMZAKB3gHASB5uLjS5Vi9sTgx4Dyw/HWbAr3fzzGp0VNij82bbGDI
         S7H81s41LCiF3Y8KxBAVC8dZ6ncYjxn+AhqWQqH6Tl5EbYH638WZ7h9k4v21nkZPpHU1
         99Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698372644; x=1698977444;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EbUsnywrZyRZETNCGtcaZV+hPx97r5Qhgb2mgN3Ht40=;
        b=m1UceK3bFgmT20CTksgMTPZeCp0+iiERRPjrkZENliNLwqewx80YSybkBQKKaGgrx/
         3aHP+RUYML26ru471yIHiClZqqzuU90wsELwJgbbBD/HLXLCyxU9MpRpOcB6xfxX80fq
         yUFVokwyLm1SvZplWWcsK0UsY4oFHjEjSmIGxgcbAq3SXCKHbdHuJGGehQEYqyLBpoGi
         gtc3Ed/uAgNOf3NXhW1uEfm8CUpv0qpXcNXXBpbRSxuEqSpr1USLEnJWq7F5Nfplh1Rv
         YvQ/b9Ya4Wzqbft2/tMfADX6gUxaqs5yc+/3uxSGYh9E32sLBD7tTMygkKuEP3WOOLjw
         5s8A==
X-Gm-Message-State: AOJu0Yz3I2yREH8lSVj62DJrC8CZkRBzJJwvGKXpbEjPfTBFOEAkr+7A
        rS8P66Nw5pQXuvsV8b36iKDinCO/Sz8=
X-Google-Smtp-Source: AGHT+IFmJ1THr87Hw51Q805pjSKLyb+J65zVq/m7rEDIsN0y1EwTwGVot5FzdMZRn6j8YGKlJSJ0Ew==
X-Received: by 2002:a17:903:41c9:b0:1ca:71:ea43 with SMTP id u9-20020a17090341c900b001ca0071ea43mr1567820ple.9.1698372643812;
        Thu, 26 Oct 2023 19:10:43 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902c21100b001c736370245sm354472pll.54.2023.10.26.19.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 19:10:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Fri, 27 Oct 2023 13:10:40 +1100
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Netfilter queue is unable to mangle fragmented UDP6: bug?
Message-ID: <ZTscICNz5aUmLYSr@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZTSj8oazCy7PQfxY@slk15.local.net>
 <20231025123232.GA27882@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025123232.GA27882@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

Thank you for your detailed reply. Responses below:

On Wed, Oct 25, 2023 at 02:32:32PM +0200, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > My libnetfilter_queue application is unable to mangle UDP6 messages that have
> > been fragmented. The kernel only delivers the first fragment of such a message
> > to the application.
> >
> > Is this a permanent restriction or a bug?
>
> There is not enough information here to answer this question,
> see below.
>
> > messages. "Something else" in the kernel re-combines UDP4 fragments before they
> > are queued to my application, so they mangle OK.
>
> I'm not sure what you mean or what you expect to happen.

I expected the netfilter program to see the full UDP datagram as sent. With
UDP/IPv4 it does see the full datagram, but not with UDP/IPv6.
>
> > In summary:
> >  - GSO re-combines TCP fragments before tcpdump can see them.
>
> Do you mean "segments"?  Its the other way around, with GSO/TSO, stack
> builds large superpackes, one tcp header with lots of data.

Sorry for the confusion here. I only meant to say that there is no problem with
TCP.

IOW kernel delivers to filter program exactly what was in the buffer when the
remote application did a write(2) (for buffer size up to just under 64KB).

I don't know what GSO is, only that it's strongly recommended to use it.
>
> Such superpackets are split at the last possible moment;
> ideally by NIC/hardware.
>
> >  - Some other kernel code re-combines UDP4 fragments before netfilter queues
> >    them
> >  - Some other different kernel code re-combines UDP6 fragments for the user
> >    application but after netfilter queues them
> >  - It's been this way for a number of years
>
> GSO is just the software fallback of TSO, i.e. local stack passes
> large skb down to the driver which will do pseudo segmentation,
> this needs hardware that can handle scatterlist, which is true for
> almost all nics.
>
> There is some segmentation support for UDP to handle encapsulation
> (tunneling) use cases, where stack can pass large skb and then can
> have hardware or software fallback do the segmentation for us, i.e.
> split according to inner protocol and add the outer udp encapsulation
> to all packets.
>
> > ================ Testing with GSO
> >
> >  nfq6 cmd: nfq6 -t6 -t7 -t8 -t17 -t18 24
> >  tcpdump cmd: tcpdump -i eth1 'ether host 18:60:24:bb:02:d6 && (tcp || udp) &&
> >                       ! port x11'
> >
> > > netcat cmds: nc -6 -q0 -u fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -u -v
> > >               nfq6 output                                   # tcpdump o/p (early fields omitted)
> > > packet received (id=169 hw=0x86dd hook=1, payload len 1496) # frag (0|1448) 33020 > 1042: UDP, length 2048
> > > Packet too short to get UDP payload                         #
> > >                                                             # frag (1448|608)
>
> You are sending a large udp packet via ipv6, it doesn't fit the device mtu,
> fragmentation is needed.  This has nothing to do with GSO.

OK I was under the mis-apprehension GSO was a level 3 thing (working at IP
level).
>
> > > packet received (id=176 hw=0x0800 hook=1, payload len 60)                           # > Flags [S], seq 821055799, win 64240, options [mss 1460,sackOK,TS val 3739788506 ecr 0,nop,wscale 7], length 0
> > > packet received (id=177 hw=0x0800 hook=3, payload len 60, checksum not ready)       # < Flags [S.], seq 1085807033, ack 821055800, win 65160, options [mss 1460,sackOK,TS val 4164299250 ecr 3739788506,nop,wscale 7], length 0
> > > packet received (id=178 hw=0x0800 hook=1, payload len 52)                           # > Flags [.], ack 1, win 502, options [nop,nop,TS val 3739788506 ecr 4164299250], length 0
> > > GSO packet received (id=179 hw=0x0800 hook=1, payload len 2100, checksum not ready) # > Flags [P.], seq 1:2049, ack 1, win 502, options [nop,nop,TS val 3739788506 ecr 4164299250], length 2048
>
> Stack built a larger packet, device or software fallback will segment
> them as needed.
>
> > ================ Testing without GSO (needs v2 nfq6)
> >
> >  nfq6 cmd: nfq6 -t6 -t7 -t8 -t17 -t18 -t20 24
> >  tcpdump cmd: (as above)
> >
> > > netcat cmds: nc -6 -q0 -u fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -u -v
> > >               nfq6 output                                   # tcpdump o/p (early fields and source port omitted)
> > > packet received (id=1 hw=0x86dd hook=1, payload len 1496)   # frag (0|1448) > 1042: UDP, length 2048
> > > Packet too short to get UDP payload                         #
> > >                                                             # frag (1448|608)
> > > -----------------------------------------------------------------------------
> > > netcat cmds: nc -4 -q0 -u dimstar 1042 <zxc2k : nc -4 -k -l -n -p 1042 -q0 -u -v
> > >               nfq6 output                                   # tcpdump o/p (early fields omitted)
> > >                                                             # UDP, length 2048
> > > packet received (id=3 hw=0x0800 hook=1, payload len 2076)   # udp
> > > -----------------------------------------------------------------------------
>
> It would help if you could explain what is wrong here.

This example shows a UDP4 2KB datagram being successfully mangled and a UDP6 2KB
datagram failing to be mangled.
>
> You also removed tcpdump info, I suspect it was "flags [+]"
> with two fragments for udp:ipv4 too?

There are 2 fragments for both IPv4 and IPv6.

tcpdump does not report any flags:

> 08:16:09.713395 IP6 fe80::1a60:24ff:febb:2d6 > fe80::1ac0:4dff:fe04:75ba: frag (0|1448) 47843 > 1042: UDP, length 2048
> 08:16:09.713395 IP6 fe80::1a60:24ff:febb:2d6 > fe80::1ac0:4dff:fe04:75ba: frag (1448|608)
> 08:17:22.924883 IP smallstar.local.net.55288 > dimstar.local.net.1042: UDP, length 2048
> 08:17:22.924883 IP smallstar.local.net > dimstar.local.net: udp

> Frag handling depends on a lot of factors, such as ip defrag being
> enabled or not, where queueing happens (hook and prio), if userspace
> does mtu probing (like 'ping6 -M do') or not.
>
> And the NIC driver too.
>
> For incoming data it also depends on sysctl settings and if
> GRO/LRO is enabled.
>
> > > packet received (id=49 hw=0x86dd hook=1, payload len 72)    # > Flags [.], ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 0
> > > packet received (id=50 hw=0x86dd hook=1, payload len 1500)  # > Flags [.], seq 1:1429, ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 1428
> > > packet received (id=51 hw=0x86dd hook=3, payload len 72)    # < Flags [.], ack 1429, win 501, options [nop,nop,TS val 2923572945 ecr 925571377], length 0
> > > packet received (id=52 hw=0x86dd hook=1, payload len 692)   # > Flags [P.], seq 1429:2049, ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 620
>
> Kernel does software segmentation here, this is slow.

Sure, that was just a test.

---

Florian, please say if you would like more explanation. Thank you again for
looking at this.

Cheers ... Duncan.
