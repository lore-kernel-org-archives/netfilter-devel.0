Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AE4CDB474
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Oct 2023 04:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjJVEY2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Oct 2023 00:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjJVEY0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Oct 2023 00:24:26 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78B991
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Oct 2023 21:24:23 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c87a85332bso18146075ad.2
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Oct 2023 21:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697948663; x=1698553463; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C665N8drU8AkJNBlEj4HVwsc3VKDt5C3QqgkerhxJGI=;
        b=BHBPw8rRbK/cC3qGRgvj1sOyGsFZQf/LDZKv7X1bZikofqOCyEeKoLBIrMP5843ZF6
         7vGm9kjro6JAL8eFOpe7yNKHC1oYEN7deTWTDTjeiFOQ9jO2sShMf5/boXm1yP4aMw1M
         TAGcZ6+JemB+35QL8Dpb8VPLUAwFlyaD6afqL6vd1pkdvp4wVYK/FIc+zxco43TAubg6
         thg6BdK/XT5+nfwTVyE946MVs8owtpSFZPJoaqaJJCCltVJgeug9XRJN6QtqIdYllXf5
         YrsAL3sJOHFTEzChUDWulaPDVhH/8M8TpPFC7bkAr+AgdvYThoG4uyLFvxbnuNSqVH6x
         1xrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697948663; x=1698553463;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:to:date:from:sender:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C665N8drU8AkJNBlEj4HVwsc3VKDt5C3QqgkerhxJGI=;
        b=bC2NDfuWlHProZTHkUwfPZlQxi1MmJCoP1ZCUMJ8++pGFR2RH2QShu6Gq/V+w+Rb1C
         a5XZRbs7YLtI4Q4BVKL/gsBbkhVnTZ+Npm+7FwlPVlY8d+dXIDnRRh7fHd7b4nwpsLrI
         j8POTC7C2fpoRg9GiRi/k9bnUzt76VEwK5jBgv/vojOhH7J8qmjWzG6fjwfcRcmYpqaU
         Xs5Y8ysG03p/jf+h463G/2UzwzB22JEgU7AIErA9PHCfT3kbE7xreTVDCwp537jK1eRm
         mWzErftvZYUi2TQ3LgVlvfuJc0xDkMgaBHlK8JjA6H8+gfL1iJpohkpuDo5b1pTGKN2W
         h9Ag==
X-Gm-Message-State: AOJu0YwpC7HrWMDRm0nGXCkC2PIhyW1vcA/3k6UvpKJftb0CPu1/ace6
        DxnYqKAYg9aYpXcsAqqqbDXMLOuGnj4=
X-Google-Smtp-Source: AGHT+IHlJbtOfj8lElPK22jLEhvLq975XmuJ1TE0Z5SOGPY64SlsiFGqtaxeNjCPTW6I39e1vede3w==
X-Received: by 2002:a17:902:ea0e:b0:1ca:20a0:7b08 with SMTP id s14-20020a170902ea0e00b001ca20a07b08mr6218047plg.50.1697948662936;
        Sat, 21 Oct 2023 21:24:22 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id li11-20020a170903294b00b001c444106bcasm3849958plb.46.2023.10.21.21.24.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Oct 2023 21:24:21 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Sun, 22 Oct 2023 15:24:18 +1100
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Netfilter queue is unable to mangle fragmented UDP6: bug?
Message-ID: <ZTSj8oazCy7PQfxY@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vqlQsczV1H5XvFhT"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--vqlQsczV1H5XvFhT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

My libnetfilter_queue application is unable to mangle UDP6 messages that have
been fragmented. The kernel only delivers the first fragment of such a message
to the application.

Is this a permanent restriction or a bug?

If it is a bug, should I be submitting this report elsewhere?

From the testing below, I have to conclude that GSO is *never* applied to UDP
messages. "Something else" in the kernel re-combines UDP4 fragments before they
are queued to my application, so they mangle OK.

In summary:
 - GSO re-combines TCP fragments before tcpdump can see them.
 - Some other kernel code re-combines UDP4 fragments before netfilter queues
   them
 - Some other different kernel code re-combines UDP6 fragments for the user
   application but after netfilter queues them
 - It's been this way for a number of years

================ Testing with GSO

 nfq6 cmd: nfq6 -t6 -t7 -t8 -t17 -t18 24
 tcpdump cmd: tcpdump -i eth1 'ether host 18:60:24:bb:02:d6 && (tcp || udp) &&
                      ! port x11'

> netcat cmds: nc -6 -q0 -u fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -u -v
>               nfq6 output                                   # tcpdump o/p (early fields omitted)
> packet received (id=169 hw=0x86dd hook=1, payload len 1496) # frag (0|1448) 33020 > 1042: UDP, length 2048
> Packet too short to get UDP payload                         #
>                                                             # frag (1448|608)
> -----------------------------------------------------------------------------
> netcat cmds: nc -4 -q0 -u dimstar 1042 <zxc2k : nc -4 -k -l -n -p 1042 -q0 -u -v
>               nfq6 output                                   # tcpdump o/p (early fields omitted)
>                                                             # UDP, length 2048
> packet received (id=172 hw=0x0800 hook=1, payload len 2076) # udp
> -----------------------------------------------------------------------------
> netcat cmds: nc -6 -q0 fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -v
>               nfq6 output                                                           # tcpdump o/p (early fields omitted, direction re-inserted)
> packet received (id=153 hw=0x86dd hook=1, payload len 80)                           # > Flags [S], seq 352061829, win 64800, options [mss 1440,sackOK,TS val 4262995036 ecr 0,nop,wscale 7], length 0
> packet received (id=154 hw=0x86dd hook=3, payload len 80, checksum not ready)       # < Flags [S.], seq 3686343792, ack 352061830, win 64260, options [mss 1440,sackOK,TS val 1966029309 ecr 4262995036,nop,wscale 7], length 0
> packet received (id=155 hw=0x86dd hook=1, payload len 72)                           # > Flags [.], ack 1, win 507, options [nop,nop,TS val 4262995036 ecr 1966029309], length 0
> GSO packet received (id=156 hw=0x86dd hook=1, payload len 2120, checksum not ready) # > Flags [P.], seq 1:2049, ack 1, win 507, options [nop,nop,TS val 4262995036 ecr 1966029309], length 2048
> packet received (id=157 hw=0x86dd hook=3, payload len 72, checksum not ready)       # > Flags [F.], seq 2049, ack 1, win 507, options [nop,nop,TS val 4262995036 ecr 1966029309], length 0
> packet received (id=158 hw=0x86dd hook=1, payload len 72)                           # < Flags [.], ack 2049, win 487, options [nop,nop,TS val 1966029309 ecr 4262995036], length 0
> packet received (id=159 hw=0x86dd hook=3, payload len 72, checksum not ready)       # < Flags [F.], seq 1, ack 2050, win 501, options [nop,nop,TS val 1966029309 ecr 4262995036], length 0
> packet received (id=160 hw=0x86dd hook=1, payload len 72)                           # > Flags [.], ack 2, win 507, options [nop,nop,TS val 4262995036 ecr 1966029309], length 0
> -----------------------------------------------------------------------------
> netcat cmds: nc -4 -q0 dimstar 1042 <zxc2k : nc -4 -k -l -n -p 1042 -q0 -v
>               nfq6 output                                                           # tcpdump o/p (early fields omitted, direction re-inserted)
> packet received (id=176 hw=0x0800 hook=1, payload len 60)                           # > Flags [S], seq 821055799, win 64240, options [mss 1460,sackOK,TS val 3739788506 ecr 0,nop,wscale 7], length 0
> packet received (id=177 hw=0x0800 hook=3, payload len 60, checksum not ready)       # < Flags [S.], seq 1085807033, ack 821055800, win 65160, options [mss 1460,sackOK,TS val 4164299250 ecr 3739788506,nop,wscale 7], length 0
> packet received (id=178 hw=0x0800 hook=1, payload len 52)                           # > Flags [.], ack 1, win 502, options [nop,nop,TS val 3739788506 ecr 4164299250], length 0
> GSO packet received (id=179 hw=0x0800 hook=1, payload len 2100, checksum not ready) # > Flags [P.], seq 1:2049, ack 1, win 502, options [nop,nop,TS val 3739788506 ecr 4164299250], length 2048
> packet received (id=180 hw=0x0800 hook=1, payload len 52)                           # > Flags [F.], seq 2049, ack 1, win 502, options [nop,nop,TS val 3739788506 ecr 4164299250], length 0
> packet received (id=181 hw=0x0800 hook=3, payload len 52, checksum not ready)       # < Flags [.], ack 2049, win 494, options [nop,nop,TS val 4164299251 ecr 3739788506], length 0
> packet received (id=182 hw=0x0800 hook=3, payload len 52, checksum not ready)       # < Flags [F.], seq 1, ack 2050, win 501, options [nop,nop,TS val 4164299251 ecr 3739788506], length 0
> packet received (id=183 hw=0x0800 hook=1, payload len 52)                           # > Flags [.], ack 2, win 502, options [nop,nop,TS val 3739788507 ecr 4164299251], length 0

================ Testing without GSO (needs v2 nfq6)

 nfq6 cmd: nfq6 -t6 -t7 -t8 -t17 -t18 -t20 24
 tcpdump cmd: (as above)

> netcat cmds: nc -6 -q0 -u fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -u -v
>               nfq6 output                                   # tcpdump o/p (early fields and source port omitted)
> packet received (id=1 hw=0x86dd hook=1, payload len 1496)   # frag (0|1448) > 1042: UDP, length 2048
> Packet too short to get UDP payload                         #
>                                                             # frag (1448|608)
> -----------------------------------------------------------------------------
> netcat cmds: nc -4 -q0 -u dimstar 1042 <zxc2k : nc -4 -k -l -n -p 1042 -q0 -u -v
>               nfq6 output                                   # tcpdump o/p (early fields omitted)
>                                                             # UDP, length 2048
> packet received (id=3 hw=0x0800 hook=1, payload len 2076)   # udp
> -----------------------------------------------------------------------------
> netcat cmds: nc -6 -q0 fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -v
>               nfq6 output                                   # tcpdump o/p (early fields omitted, direction re-inserted)
> packet received (id=47 hw=0x86dd hook=1, payload len 80)    # > Flags [S], seq 3918008965, win 64800, options [mss 1440,sackOK,TS val 925571377 ecr 0,nop,wscale 7], length 0
> packet received (id=48 hw=0x86dd hook=3, payload len 80)    # < Flags [S.], seq 2930457023, ack 3918008966, win 64260, options [mss 1440,sackOK,TS val 2923572945 ecr 925571377,nop,wscale 7], length 0
> packet received (id=49 hw=0x86dd hook=1, payload len 72)    # > Flags [.], ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 0
> packet received (id=50 hw=0x86dd hook=1, payload len 1500)  # > Flags [.], seq 1:1429, ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 1428
> packet received (id=51 hw=0x86dd hook=3, payload len 72)    # < Flags [.], ack 1429, win 501, options [nop,nop,TS val 2923572945 ecr 925571377], length 0
> packet received (id=52 hw=0x86dd hook=1, payload len 692)   # > Flags [P.], seq 1429:2049, ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 620
> packet received (id=53 hw=0x86dd hook=1, payload len 72)    # > Flags [F.], seq 2049, ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 0
> packet received (id=54 hw=0x86dd hook=3, payload len 72)    # < Flags [.], ack 2049, win 497, options [nop,nop,TS val 2923572945 ecr 925571377], length 0
> packet received (id=55 hw=0x86dd hook=3, payload len 72)    # < Flags [F.], seq 1, ack 2050, win 501, options [nop,nop,TS val 2923572945 ecr 925571377], length 0
> packet received (id=56 hw=0x86dd hook=1, payload len 72)    # > Flags [.], ack 2, win 507, options [nop,nop,TS val 925571378 ecr 2923572945], length 0
> -----------------------------------------------------------------------------
> netcat cmds: nc -4 -q0 dimstar 1042 <zxc2k : nc -4 -k -l -n -p 1042 -q0 -v
>               nfq6 output                                   # tcpdump o/p (early fields omitted, direction re-inserted)
> packet received (id=64 hw=0x0800 hook=1, payload len 60)    # > Flags [S], seq 2388825860, win 64240, options [mss 1460,sackOK,TS val 398191667 ecr 0,nop,wscale 7], length 0
> packet received (id=65 hw=0x0800 hook=3, payload len 60)    # < Flags [S.], seq 3593988110, ack 2388825861, win 65160, options [mss 1460,sackOK,TS val 822702413 ecr 398191667,nop,wscale 7], length 0
> packet received (id=66 hw=0x0800 hook=1, payload len 52)    # > Flags [.], ack 1, win 502, options [nop,nop,TS val 398191668 ecr 822702413], length 0
> packet received (id=67 hw=0x0800 hook=1, payload len 1500)  # > Flags [.], seq 1:1449, ack 1, win 502, options [nop,nop,TS val 398191668 ecr 822702413], length 1448
> packet received (id=68 hw=0x0800 hook=3, payload len 52)    # < Flags [.], ack 1449, win 501, options [nop,nop,TS val 822702414 ecr 398191668], length 0
> packet received (id=69 hw=0x0800 hook=1, payload len 652)   # > Flags [P.], seq 1449:2049, ack 1, win 502, options [nop,nop,TS val 398191668 ecr 822702413], length 600
> packet received (id=70 hw=0x0800 hook=1, payload len 52)    # < Flags [.], ack 2049, win 501, options [nop,nop,TS val 822702414 ecr 398191668], length 0
> packet received (id=71 hw=0x0800 hook=3, payload len 52)    # > Flags [F.], seq 2049, ack 1, win 502, options [nop,nop,TS val 398191668 ecr 822702413], length 0
> packet received (id=72 hw=0x0800 hook=3, payload len 52)    # < Flags [F.], seq 1, ack 2050, win 501, options [nop,nop,TS val 822702414 ecr 398191668], length 0
> packet received (id=73 hw=0x0800 hook=1, payload len 52)    # > Flags [.], ack 2, win 502, options [nop,nop,TS val 398191668 ecr 822702414], length 0

================ Software revisions

 - Linux 6.4.7
 - netcat-openbsd-7.3_1-x86_64-1_SBo (based on Debian netcat-openbsd, that
   should work also. Other netcats may not accept all options).
   Slackbuilds link:
   https://slackbuilds.org/repository/15.0/network/netcat-openbsd/
   Direct link: https://github.com/duncan-roe/netcat-openbsd
 - libnetfilter_queue: commit 1512964 (latest)
 - nfq6: v2 (from patchwork)

================ nft table (log prefix entries irrelevant for these tests)

table inet INET {
        chain FILTER_INPUT {
                type filter hook input priority filter - 1; policy accept;
                iif "lo" udp dport 1042 counter packets 0 bytes 0 log prefix "local UDP" group 0 queue flags bypass to 24
                iif "eth1" udp dport 1042 counter packets 142 bytes 1965130 log prefix "incoming UDP to" group 0 queue flags bypass to 24
                iif "eth1" udp sport 1042 counter packets 0 bytes 0 log prefix "incoming UDP fm" group 0 queue flags bypass to 24
                iif "eth1" tcp dport 1042 counter packets 330 bytes 767057 log prefix "incoming TCP to" group 0 queue flags bypass to 24
                iif "eth1" tcp sport 1042 counter packets 0 bytes 0 log prefix "incoming TCP fm" group 0 queue flags bypass to 24
                iif "lo" tcp dport 1042 counter packets 0 bytes 0 log prefix "local TCP" group 0 queue flags bypass to 24
        }

        chain FILTER_OUTPUT {
                type filter hook output priority filter - 1; policy accept;
                oif "eth1" udp dport 1042 counter packets 0 bytes 0 log prefix "outgoing UDP to" group 0 queue flags bypass to 24
                oif "eth1" tcp dport 1042 counter packets 0 bytes 0 log prefix "outgoing TCP to" group 0 queue flags bypass to 24
                oif "eth1" udp sport 1042 counter packets 7 bytes 275 log prefix "outgoing UDP fm" group 0 queue flags bypass to 24
                oif "eth1" tcp sport 1042 counter packets 263 bytes 17684 log prefix "outgoing TCP fm" group 0 queue flags bypass to 24
        }
}

================ Attachment

zxc2k.xz

--vqlQsczV1H5XvFhT
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="zxc2k.xz"
Content-Transfer-Encoding: base64

/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj4Af/ADJdAC0WBGrY6R6CXNGizy4LChXN3bC0dg4b
kwHgzitN9HhJFvi72H+pijjp1pg/v5v/g4AAAAAA7ET+P5Q4Kk0AAU6AEAAAAMxY+BexxGf7
AgAAAAAEWVo=

--vqlQsczV1H5XvFhT--
