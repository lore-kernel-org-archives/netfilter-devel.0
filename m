Return-Path: <SRS0=hDGH=VH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305F3C73C7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC7BD2064A
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="LK4fjkA4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfGJKqU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 06:46:20 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:47405 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfGJKqT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 06:46:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id DA2E8CC00F9;
        Wed, 10 Jul 2019 12:46:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1562755573; x=1564569974; bh=x7TtKdJO/4
        pTWOjR6SFVm6BFw2do74GFu9eqBhymaqM=; b=LK4fjkA4Ub67JtO9HW81uWcTU6
        KqMplFvYE8nU4FYD20avO6Iur+bjnxk6l+HE4+8N7y5xVAjdiYxHzL9WWPTOV9us
        I/0jfLzOq/lQnvkVwHNkMuIEzgV3FyGggjeUMhCSl3+BWLAyGDOTIUp1UPh7ZsTL
        ukFlQ8lQYAH5lpcGc=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 10 Jul 2019 12:46:13 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 1E0F0CC00FA;
        Wed, 10 Jul 2019 12:46:12 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id C67CE21CBA; Wed, 10 Jul 2019 12:46:12 +0200 (CEST)
Date:   Wed, 10 Jul 2019 12:46:12 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Jakub Jankowski <shasta@toxcorp.com>
cc:     netfilter@vger.kernel.org, mhemsley@open-systems.com,
        netfilter-devel@vger.kernel.org
Subject: Re: 3-way handshake sets conntrack timeout to max_retrans
In-Reply-To: <alpine.LNX.2.21.1907100147540.26040@kich.toxcorp.com>
Message-ID: <alpine.DEB.2.20.1907101242560.17522@blackhole.kfki.hu>
References: <alpine.LNX.2.21.1907100147540.26040@kich.toxcorp.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, 10 Jul 2019, Jakub Jankowski wrote:

> We're debugging a weird issue. tl;dr: I have a .pcap file of connection 
> setup that makes conntrack apply TCP_CONNTRACK_RETRANS timeout (300s by 
> default) instead of TCP_CONNTRACK_ESTABLISHED (5d by default). The .pcap 
> is a recording of some app traffic running on Windows (SAP, I believe).
> 
> To reproduce it, I set up a testbed consisting of three Debian (Buster) 
> VMs, running their default kernel (4.19.0-5-amd64, based on 4.19.37), 
> but I get the same results on vanilla 4.19.57.
> 
> 
>              10.88.15.142        10.88.15.1
>    ------------- enp0s3        enp0s3 -------------
>    |           | -------------------- |           |
>    | testhost1 |                      | testhost0 |
>    |           | -------------------- |    (DUT)  |
>    ------------- enp0s4        enp0s4 -------------
>              10.88.1.2           10.88.1.1
> 
> 
> Replaying "bad" pcap using tcpreplay from testhost1:
> 
> root@testhost1:~# tcpreplay --cachefile=replay.cache --intf1=enp0s4
> --intf2=enp0s3 -L 3 replay-timeadjusted.pcap
> 
> and capturing what is seen on Device Under Test (testhost0)
> 
> root@testhost0:~# tcpdump -s 0 -w replay-timeadjusted.pcap -i enp0s3 -nn
> 
> 
> To pinpoint which timeout is getting set, we slightly moved these two sysctls
> apart, because by default they're both 300s:
> 
> # sysctl -w net.netfilter.nf_conntrack_tcp_timeout_max_retrans=313
> # sysctl -w net.netfilter.nf_conntrack_tcp_timeout_unacknowledged=338
> 
> 
> Firewall setup is the simplest thing we could come up with for conntrack to
> handle this connection (and only this, to avoide pr_debug() noise):
> 
> root@testhost0:~# iptables-save
> # Generated by xtables-save v1.8.2 on Wed Jul 10 00:23:12 2019
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> :fwd - [0:0]
> -A FORWARD -p tcp -m tcp --dport 3230 -j fwd
> -A FORWARD -p tcp -m tcp --sport 3230 -j fwd
> -A fwd -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
> -A fwd -p tcp -m conntrack --ctstate NEW -m tcp --dport 3230 -j ACCEPT
> COMMIT
> # Completed on Wed Jul 10 00:23:12 2019
> root@testhost0:~#
> 
> 
> The offending handshake is:
> 
> root@testhost0:~# tcpdump -v -nn --absolute-tcp-sequence-numbers -r
> replayed-traffic.pcap
> reading from file replayed-traffic.pcap, link-type EN10MB (Ethernet)
> 01:13:25.070622 IP (tos 0x0, ttl 128, id 35410, offset 0, flags [DF], proto
> TCP (6), length 52)
>     10.88.15.142.51451 > 10.88.1.2.3230: Flags [S], cksum 0x1473 (correct),
> seq 962079611, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK],
> length 0
> 01:13:26.070462 IP (tos 0x0, ttl 53, id 29815, offset 0, flags [DF], proto TCP
> (6), length 48)
>     10.88.1.2.3230 > 10.88.15.142.51451: Flags [S.], cksum 0x70cf (correct),
> seq 1148284782, ack 962079612, win 65535, options [mss 1380,nop,wscale 3],
> length 0
> 01:13:27.070449 IP (tos 0x0, ttl 128, id 35411, offset 0, flags [DF], proto
> TCP (6), length 40)
>     10.88.15.142.51451 > 10.88.1.2.3230: Flags [.], cksum 0x9a46 (correct),
> ack 1148284783, win 512, length 0
> 
> This conversation results in the following conntrack events:
> 
> root@testhost0:~# conntrack -E --orig-src 10.88.15.142
>     [NEW] tcp      6 120 SYN_SENT src=10.88.15.142 dst=10.88.1.2 sport=51451
> dport=3230 [UNREPLIED] src=10.88.1.2 dst=10.88.15.142 sport=3230 dport=51451
>  [UPDATE] tcp      6 60 SYN_RECV src=10.88.15.142 dst=10.88.1.2 sport=51451
> dport=3230 src=10.88.1.2 dst=10.88.15.142 sport=3230 dport=51451
>  [UPDATE] tcp      6 312 ESTABLISHED src=10.88.15.142 dst=10.88.1.2
> sport=51451 dport=3230 src=10.88.1.2 dst=10.88.15.142 sport=3230 dport=51451
> [ASSURED]
> 
> 
> After enabling all pr_debug()s in nf_conntrack_proto_tcp.c, the above
> handshake results in this:
> 
> root@testhost0:~# grep 'Jul 10 00:55:01' /var/log/kern.log
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264058] tcp_new: sender
> end=1483803195 maxend=1483803195 maxwin=29200 scale=7 receiver end=0 maxend=0
> maxwin=0 scale=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264115] tcp_in_window: START
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264132] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264157] seq=1483803194 ack=0+(0)
> sack=0+(0) win=29200 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264174] tcp_in_window: sender
> end=1483803195 maxend=1483803195 maxwin=29200 scale=7 receiver end=0 maxend=0
> maxwin=0 scale=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264184] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264197] seq=1483803194 ack=0+(0)
> sack=0+(0) win=29200 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264210] tcp_in_window: sender
> end=1483803195 maxend=1483803195 maxwin=29200 scale=7 receiver end=0 maxend=0
> maxwin=0 scale=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264235] tcp_in_window: I=1 II=1 III=1
> IV=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264257] tcp_in_window: res=1 sender
> end=1483803195 maxend=1483803195 maxwin=29200 receiver end=0 maxend=29200
> maxwin=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264267] tcp_conntracks:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264280] syn=1 ack=0 fin=0 rst=0 old=0
> new=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265226] tcp_in_window: START
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265254] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265275] seq=3233541593
> ack=1483803195+(0) sack=1483803195+(0) win=28960 end=3233541594
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265295] tcp_in_window: sender end=0
> maxend=29200 maxwin=0 scale=0 receiver end=1483803195 maxend=1483803195
> maxwin=29200 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265306] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265323] seq=3233541593
> ack=1483803195+(0) sack=1483803195+(0) win=28960 end=3233541594
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265338] tcp_in_window: sender
> end=3233541594 maxend=3233541594 maxwin=28960 scale=7 receiver end=1483803195
> maxend=1483803195 maxwin=29200 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265350] tcp_in_window: I=1 II=1 III=1
> IV=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265366] tcp_in_window: res=1 sender
> end=3233541594 maxend=3233541594 maxwin=28960 receiver end=1483803195
> maxend=1483832155 maxwin=29200
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265395] tcp_conntracks:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265408] syn=1 ack=1 fin=0 rst=0 old=1
> new=2
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266310] tcp_in_window: START
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266348] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266365] seq=1483803195
> ack=3233541594+(0) sack=3233541594+(0) win=229 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266380] tcp_in_window: sender
> end=1483803195 maxend=1483832155 maxwin=29200 scale=7 receiver end=3233541594
> maxend=3233541594 maxwin=28960 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266391] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266405] seq=1483803195
> ack=3233541594+(0) sack=3233541594+(0) win=229 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266419] tcp_in_window: sender
> end=1483803195 maxend=1483832155 maxwin=29200 scale=7 receiver end=3233541594
> maxend=3233541594 maxwin=28960 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266432] tcp_in_window: I=1 II=1 III=1
> IV=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266458] tcp_in_window: res=1 sender
> end=1483803195 maxend=1483832155 maxwin=29312 receiver end=3233541594
> maxend=3233570906 maxwin=28960
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266471] tcp_conntracks:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266485] syn=0 ack=1 fin=0 rst=0 old=2
> new=3
> root@testhost0:~#

Thanks for the thorough report, but the kernel debug log above does not 
correspond to the packet replay: the TCP parameters do not match. Please 
send the proper debug log, so we can look into it.

Best regards,
Jozsef
 
> Why would ESTABLISHED state's timeout be set to TCP_CONNTRACK_RETRANS?
> We know that it's getting into this elseif clause:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/netfilter/nf_conntrack_proto_tcp.c?h=linux-4.19.y#n1060
> 
> 	else if (ct->proto.tcp.last_win == 0 &&
> 		 timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
> 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
> 
> Which was added in commit fbcd253d2448b8f168241e38f629a36c4c8c1e94
> ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
> And indeed - reverting this commit makes the behaviour go away, timeout is set
> to default 5 days.
> 
> 
> This must be something specific to these three packets, or (less likely) to
> the way tcpreplay works, as I repeated a similar test, adding third host (also
> Debian Buster) and doing plain netcat+telnet via DUT:
> 
> 
>        10.88.15.142      10.88.15.1
>    -------------            -------------------
>    | testhost1 | ---------- | testhost0 (DUT) |
>    -------------            -------------------
>                                 |  10.5.5.1
>                                 |
>                                 |
>                                 |
>                                 |  10.5.5.82
>                             -------------
>                             | testhost2 |
>                             -------------
> 
> Setting up simple netcat server listening on testhost2, and running "telnet
> testhost2 3230" from testhost1:
> 
> root@testhost2:~# ./prep.sh
> + ip route add 10.88.15.0/24 via 10.5.5.1
> root@testhost2:~# nc -l -p 3230
> 
> 
> root@testhost1:~# ./prep.sh
> + ip route add 10.5.5.0/24 via 10.88.15.1
> root@testhost1:~# telnet 10.5.5.82 3230
> Trying 10.5.5.82...
> Connected to 10.5.5.82.
> Escape character is '^]'.
> 
> 
> This produced the following handshake:
> 
> root@testhost0:~# tcpdump -v -nn --absolute-tcp-sequence-numbers -r
> regular-telnet.pcap
> reading from file regular-telnet.pcap, link-type EN10MB (Ethernet)
> 00:55:01.317397 IP (tos 0x10, ttl 64, id 9367, offset 0, flags [DF], proto TCP
> (6), length 60)
>     10.88.15.142.59416 > 10.5.5.82.3230: Flags [S], cksum 0x296b (incorrect ->
> 0xd691), seq 1483803194, win 29200, options [mss 1460,sackOK,TS val 1611079352
> ecr 0,nop,wscale 7], length 0
> 00:55:01.318858 IP (tos 0x0, ttl 63, id 0, offset 0, flags [DF], proto TCP
> (6), length 60)
>     10.5.5.82.3230 > 10.88.15.142.59416: Flags [S.], cksum 0x296b (incorrect
> -> 0xd584), seq 3233541593, ack 1483803195, win 28960, options [mss
> 1460,sackOK,TS val 3393620239 ecr 1611079352,nop,wscale 7], length 0
> 00:55:01.319663 IP (tos 0x10, ttl 64, id 9368, offset 0, flags [DF], proto TCP
> (6), length 52)
>     10.88.15.142.59416 > 10.5.5.82.3230: Flags [.], cksum 0x2963 (incorrect ->
> 0x748a), ack 3233541594, win 229, options [nop,nop,TS val 1611079354 ecr
> 3393620239], length 0
> root@testhost0:~#
> 
> And conntrack timeout is also as expected:
> 
> root@testhost0:~# conntrack -E --orig-src 10.88.15.142
>     [NEW] tcp      6 120 SYN_SENT src=10.88.15.142 dst=10.5.5.82 sport=59416
> dport=3230 [UNREPLIED] src=10.5.5.82 dst=10.88.15.142 sport=3230 dport=59416
>  [UPDATE] tcp      6 60 SYN_RECV src=10.88.15.142 dst=10.5.5.82 sport=59416
> dport=3230 src=10.5.5.82 dst=10.88.15.142 sport=3230 dport=59416
>  [UPDATE] tcp      6 432000 ESTABLISHED src=10.88.15.142 dst=10.5.5.82
> sport=59416 dport=3230 src=10.5.5.82 dst=10.88.15.142 sport=3230 dport=59416
> [ASSURED]
> 
> 
> pr_debug()s from this "telnet" handshake are:
> 
> root@testhost0:~# grep 'Jul 10 00:55:01' /var/log/kern.log
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264058] tcp_new: sender
> end=1483803195 maxend=1483803195 maxwin=29200 scale=7 receiver end=0 maxend=0
> maxwin=0 scale=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264115] tcp_in_window: START
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264132] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264157] seq=1483803194 ack=0+(0)
> sack=0+(0) win=29200 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264174] tcp_in_window: sender
> end=1483803195 maxend=1483803195 maxwin=29200 scale=7 receiver end=0 maxend=0
> maxwin=0 scale=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264184] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264197] seq=1483803194 ack=0+(0)
> sack=0+(0) win=29200 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264210] tcp_in_window: sender
> end=1483803195 maxend=1483803195 maxwin=29200 scale=7 receiver end=0 maxend=0
> maxwin=0 scale=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264235] tcp_in_window: I=1 II=1 III=1
> IV=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264257] tcp_in_window: res=1 sender
> end=1483803195 maxend=1483803195 maxwin=29200 receiver end=0 maxend=29200
> maxwin=0
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264267] tcp_conntracks:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.264280] syn=1 ack=0 fin=0 rst=0 old=0
> new=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265226] tcp_in_window: START
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265254] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265275] seq=3233541593
> ack=1483803195+(0) sack=1483803195+(0) win=28960 end=3233541594
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265295] tcp_in_window: sender end=0
> maxend=29200 maxwin=0 scale=0 receiver end=1483803195 maxend=1483803195
> maxwin=29200 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265306] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265323] seq=3233541593
> ack=1483803195+(0) sack=1483803195+(0) win=28960 end=3233541594
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265338] tcp_in_window: sender
> end=3233541594 maxend=3233541594 maxwin=28960 scale=7 receiver end=1483803195
> maxend=1483803195 maxwin=29200 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265350] tcp_in_window: I=1 II=1 III=1
> IV=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265366] tcp_in_window: res=1 sender
> end=3233541594 maxend=3233541594 maxwin=28960 receiver end=1483803195
> maxend=1483832155 maxwin=29200
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265395] tcp_conntracks:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.265408] syn=1 ack=1 fin=0 rst=0 old=1
> new=2
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266310] tcp_in_window: START
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266348] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266365] seq=1483803195
> ack=3233541594+(0) sack=3233541594+(0) win=229 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266380] tcp_in_window: sender
> end=1483803195 maxend=1483832155 maxwin=29200 scale=7 receiver end=3233541594
> maxend=3233541594 maxwin=28960 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266391] tcp_in_window:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266405] seq=1483803195
> ack=3233541594+(0) sack=3233541594+(0) win=229 end=1483803195
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266419] tcp_in_window: sender
> end=1483803195 maxend=1483832155 maxwin=29200 scale=7 receiver end=3233541594
> maxend=3233541594 maxwin=28960 scale=7
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266432] tcp_in_window: I=1 II=1 III=1
> IV=1
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266458] tcp_in_window: res=1 sender
> end=1483803195 maxend=1483832155 maxwin=29312 receiver end=3233541594
> maxend=3233570906 maxwin=28960
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266471] tcp_conntracks:
> Jul 10 00:55:01 testhost0 kernel: [ 1146.266485] syn=0 ack=1 fin=0 rst=0 old=2
> new=3
> root@testhost0:~#
> 
> 
> Any pointers are welcome :)
> 
> 
> Regards,
>  Jakub
> 
> 
> -- 
> Jakub Jankowski|shasta@toxcorp.com|https://toxcorp.com/
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
