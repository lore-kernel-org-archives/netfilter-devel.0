Return-Path: <SRS0=IQIq=VI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB38DC74A51
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 09:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBCF021019
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 09:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfGKJgn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:36:43 -0400
Received: from kich.slackware.pl ([193.218.152.244]:53254 "EHLO
        kich.slackware.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfGKJgn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 05:36:43 -0400
Received: from kich.toxcorp.com (kich.toxcorp.com [193.218.152.244])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: shasta@toxcorp.com)
        by kich.slackware.pl (Postfix) with ESMTPSA id EC9D0C0;
        Thu, 11 Jul 2019 11:36:39 +0200 (CEST)
Date:   Thu, 11 Jul 2019 11:36:39 +0200 (CEST)
From:   Jakub Jankowski <shasta@toxcorp.com>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
cc:     netfilter@vger.kernel.org, mhemsley@open-systems.com,
        netfilter-devel@vger.kernel.org
Subject: Re: 3-way handshake sets conntrack timeout to max_retrans
In-Reply-To: <alpine.DEB.2.20.1907111056480.22623@blackhole.kfki.hu>
Message-ID: <alpine.LNX.2.21.1907111126240.26040@kich.toxcorp.com>
References: <alpine.LNX.2.21.1907100147540.26040@kich.toxcorp.com> <alpine.DEB.2.20.1907101242560.17522@blackhole.kfki.hu> <alpine.LNX.2.21.1907101251090.26040@kich.toxcorp.com> <alpine.DEB.2.20.1907111056480.22623@blackhole.kfki.hu>
User-Agent: Alpine 2.21 (LNX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-07-11, Jozsef Kadlecsik wrote:

> Hi,
>
> On Wed, 10 Jul 2019, Jakub Jankowski wrote:
>
>> On 2019-07-10, Jozsef Kadlecsik wrote:
>>
>>> On Wed, 10 Jul 2019, Jakub Jankowski wrote:
>>>
>>>> We're debugging a weird issue. tl;dr: I have a .pcap file of connection
>>>> setup that makes conntrack apply TCP_CONNTRACK_RETRANS timeout (300s by
>>>> default) instead of TCP_CONNTRACK_ESTABLISHED (5d by default). The .pcap
>>>> is a recording of some app traffic running on Windows (SAP, I believe).
>>>>
>>>> The offending handshake is:
>>>>
>>>> root@testhost0:~# tcpdump -v -nn --absolute-tcp-sequence-numbers -r
>>>> replayed-traffic.pcap
>>>> reading from file replayed-traffic.pcap, link-type EN10MB (Ethernet)
>>>> 01:13:25.070622 IP (tos 0x0, ttl 128, id 35410, offset 0, flags [DF],
>>>> proto
>>>> TCP (6), length 52)
>>>>     10.88.15.142.51451 > 10.88.1.2.3230: Flags [S], cksum 0x1473
>>>> (correct),
>>>> seq 962079611, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK],
>>>> length 0
>>>> 01:13:26.070462 IP (tos 0x0, ttl 53, id 29815, offset 0, flags [DF], proto
>>>> TCP
>>>> (6), length 48)
>>>>     10.88.1.2.3230 > 10.88.15.142.51451: Flags [S.], cksum 0x70cf
>>>> (correct),
>>>> seq 1148284782, ack 962079612, win 65535, options [mss 1380,nop,wscale 3],
>>>> length 0
>>>> 01:13:27.070449 IP (tos 0x0, ttl 128, id 35411, offset 0, flags [DF],
>>>> proto
>>>> TCP (6), length 40)
>>>>     10.88.15.142.51451 > 10.88.1.2.3230: Flags [.], cksum 0x9a46
>>>> (correct),
>>>> ack 1148284783, win 512, length 0
>>>>
>>>> This conversation results in the following conntrack events:
>>>>
>>>> root@testhost0:~# conntrack -E --orig-src 10.88.15.142
>>>>     [NEW] tcp      6 120 SYN_SENT src=10.88.15.142 dst=10.88.1.2
>>>> sport=51451
>>>> dport=3230 [UNREPLIED] src=10.88.1.2 dst=10.88.15.142 sport=3230
>>>> dport=51451
>>>>  [UPDATE] tcp      6 60 SYN_RECV src=10.88.15.142 dst=10.88.1.2
>>>> sport=51451
>>>> dport=3230 src=10.88.1.2 dst=10.88.15.142 sport=3230 dport=51451
>>>>  [UPDATE] tcp      6 312 ESTABLISHED src=10.88.15.142 dst=10.88.1.2
>>>> sport=51451 dport=3230 src=10.88.1.2 dst=10.88.15.142 sport=3230
>>>> dport=51451
>>>> [ASSURED]
>>>>
>>>>
>>>> After enabling all pr_debug()s in nf_conntrack_proto_tcp.c, the above
>>>> handshake results in this:
>>>
>>> Thanks for the thorough report, but the kernel debug log above does not
>>> correspond to the packet replay: the TCP parameters do not match. Please
>>> send the proper debug log, so we can look into it.
>>
>> Argh. My bad, wrong copy&paste, sorry. Here goes the correct debug snippet:
>
> The kernel does not print enough information. Could you apply the attached
> patch to your kernel at the test machine, rerun the test and send the
> logs?

Thanks for looking into this. 4.19.57 with your patch:

- "bad" case:

Jul 11 11:22:39 testhost0 kernel: [   45.360287] tcp_new: sender 
end=962079612 maxend=962079612 maxwin=64240 scale=8 receiver end=0 
maxend=0 maxwin=0 scale=0
Jul 11 11:22:39 testhost0 kernel: [   45.360322] tcp_in_window: START
Jul 11 11:22:39 testhost0 kernel: [   45.360330] tcp_in_window:
Jul 11 11:22:39 testhost0 kernel: [   45.360342] seq=962079611 ack=0+(0) 
sack=0+(0) win=64240 end=962079612
Jul 11 11:22:39 testhost0 kernel: [   45.360354] tcp_in_window: sender 
end=962079612 maxend=962079612 maxwin=64240 scale=8 receiver end=0 
maxend=0 maxwin=0 scale=0 last dir=0 seq=0 ack=0 end=0 win=0 retrans=0
Jul 11 11:22:39 testhost0 kernel: [   45.360361] tcp_in_window:
Jul 11 11:22:39 testhost0 kernel: [   45.360371] seq=962079611 ack=0+(0) 
sack=0+(0) win=64240 end=962079612
Jul 11 11:22:39 testhost0 kernel: [   45.360381] tcp_in_window: sender 
end=962079612 maxend=962079612 maxwin=64240 scale=8 receiver end=0 
maxend=0 maxwin=0 scale=0
Jul 11 11:22:39 testhost0 kernel: [   45.360390] tcp_in_window: I=1 II=1 
III=1 IV=1
Jul 11 11:22:39 testhost0 kernel: [   45.360402] tcp_in_window: res=1 
sender end=962079612 maxend=962079612 maxwin=64240 scale=8 receiver end=0 
maxend=64240 maxwin=0 scale=0 last dir=0 seq=0 ack=0 end=0 win=0 retrans=0
Jul 11 11:22:39 testhost0 kernel: [   45.360410] tcp_conntracks:
Jul 11 11:22:39 testhost0 kernel: [   45.360419] syn=1 ack=0 fin=0 rst=0 
old=0 new=1
Jul 11 11:22:40 testhost0 kernel: [   46.359998] tcp_in_window: START
Jul 11 11:22:40 testhost0 kernel: [   46.360009] tcp_in_window:
Jul 11 11:22:40 testhost0 kernel: [   46.360012] seq=1148284782 
ack=962079612+(0) sack=962079612+(0) win=65535 end=1148284783
Jul 11 11:22:40 testhost0 kernel: [   46.360015] tcp_in_window: sender 
end=0 maxend=64240 maxwin=0 scale=0 receiver end=962079612 
maxend=962079612 maxwin=64240 scale=8 last dir=0 seq=0 ack=0 end=0 win=0 
retrans=0
Jul 11 11:22:40 testhost0 kernel: [   46.360017] tcp_in_window:
Jul 11 11:22:40 testhost0 kernel: [   46.360019] seq=1148284782 
ack=962079612+(0) sack=962079612+(0) win=65535 end=1148284783
Jul 11 11:22:40 testhost0 kernel: [   46.360021] tcp_in_window: sender 
end=1148284783 maxend=1148284783 maxwin=65535 scale=3 receiver 
end=962079612 maxend=962079612 maxwin=64240 scale=8
Jul 11 11:22:40 testhost0 kernel: [   46.360022] tcp_in_window: I=1 II=1 
III=1 IV=1
Jul 11 11:22:40 testhost0 kernel: [   46.360025] tcp_in_window: res=1 
sender end=1148284783 maxend=1148284783 maxwin=65535 scale=3 receiver 
end=962079612 maxend=962145147 maxwin=64240 scale=8 last dir=0 seq=0 ack=0 
end=0 win=0 retrans=0
Jul 11 11:22:40 testhost0 kernel: [   46.360026] tcp_conntracks:
Jul 11 11:22:40 testhost0 kernel: [   46.360028] syn=1 ack=1 fin=0 rst=0 
old=1 new=2
Jul 11 11:22:41 testhost0 kernel: [   47.359983] tcp_in_window: START
Jul 11 11:22:41 testhost0 kernel: [   47.359991] tcp_in_window:
Jul 11 11:22:41 testhost0 kernel: [   47.359994] seq=962079612 
ack=1148284783+(0) sack=1148284783+(0) win=512 end=962079612
Jul 11 11:22:41 testhost0 kernel: [   47.359997] tcp_in_window: sender 
end=962079612 maxend=962145147 maxwin=64240 scale=8 receiver 
end=1148284783 maxend=1148284783 maxwin=65535 scale=3 last dir=1 seq=0 
ack=0 end=0 win=0 retrans=0
Jul 11 11:22:41 testhost0 kernel: [   47.359998] tcp_in_window:
Jul 11 11:22:41 testhost0 kernel: [   47.360003] seq=962079612 
ack=1148284783+(0) sack=1148284783+(0) win=512 end=962079612
Jul 11 11:22:41 testhost0 kernel: [   47.360005] tcp_in_window: sender 
end=962079612 maxend=962145147 maxwin=64240 scale=8 receiver 
end=1148284783 maxend=1148284783 maxwin=65535 scale=3
Jul 11 11:22:41 testhost0 kernel: [   47.360006] tcp_in_window: I=1 II=1 
III=1 IV=1
Jul 11 11:22:41 testhost0 kernel: [   47.360009] tcp_in_window: res=1 
sender end=962079612 maxend=962145147 maxwin=131072 scale=8 receiver 
end=1148284783 maxend=1148415855 maxwin=65535 scale=3 last dir=0 
seq=962079612 ack=1148284783 end=962079612 win=0 retrans=0
Jul 11 11:22:41 testhost0 kernel: [   47.360010] tcp_conntracks:
Jul 11 11:22:41 testhost0 kernel: [   47.360012] syn=0 ack=1 fin=0 rst=0 
old=2 new=3


- "normal" case (regular telnet between two linux hosts)

# grep 'Jul 11 11:25:' /var/log/kern.log
Jul 11 11:25:24 testhost0 kernel: [  211.343481] tcp_new: sender 
end=985051953 maxend=985051953 maxwin=29200 scale=7 receiver end=0 
maxend=0 maxwin=0 scale=0
Jul 11 11:25:24 testhost0 kernel: [  211.343522] tcp_in_window: START
Jul 11 11:25:24 testhost0 kernel: [  211.343524] tcp_in_window:
Jul 11 11:25:24 testhost0 kernel: [  211.343526] seq=985051952 ack=0+(0) 
sack=0+(0) win=29200 end=985051953
Jul 11 11:25:24 testhost0 kernel: [  211.343528] tcp_in_window: sender 
end=985051953 maxend=985051953 maxwin=29200 scale=7 receiver end=0 
maxend=0 maxwin=0 scale=0 last dir=0 seq=0 ack=0 end=0 win=0 retrans=0
Jul 11 11:25:24 testhost0 kernel: [  211.343530] tcp_in_window:
Jul 11 11:25:24 testhost0 kernel: [  211.343532] seq=985051952 ack=0+(0) 
sack=0+(0) win=29200 end=985051953
Jul 11 11:25:24 testhost0 kernel: [  211.343534] tcp_in_window: sender 
end=985051953 maxend=985051953 maxwin=29200 scale=7 receiver end=0 
maxend=0 maxwin=0 scale=0
Jul 11 11:25:24 testhost0 kernel: [  211.343538] tcp_in_window: I=1 II=1 
III=1 IV=1
Jul 11 11:25:24 testhost0 kernel: [  211.343541] tcp_in_window: res=1 
sender end=985051953 maxend=985051953 maxwin=29200 scale=7 receiver end=0 
maxend=29200 maxwin=0 scale=0 last dir=0 seq=0 ack=0 end=0 win=0 retrans=0
Jul 11 11:25:24 testhost0 kernel: [  211.343542] tcp_conntracks:
Jul 11 11:25:24 testhost0 kernel: [  211.343544] syn=1 ack=0 fin=0 rst=0 
old=0 new=1
Jul 11 11:25:24 testhost0 kernel: [  211.344034] tcp_in_window: START
Jul 11 11:25:24 testhost0 kernel: [  211.344040] tcp_in_window:
Jul 11 11:25:24 testhost0 kernel: [  211.344042] seq=1537183414 
ack=985051953+(0) sack=985051953+(0) win=28960 end=1537183415
Jul 11 11:25:24 testhost0 kernel: [  211.344044] tcp_in_window: sender 
end=0 maxend=29200 maxwin=0 scale=0 receiver end=985051953 
maxend=985051953 maxwin=29200 scale=7 last dir=0 seq=0 ack=0 end=0 win=0 
retrans=0
Jul 11 11:25:24 testhost0 kernel: [  211.344046] tcp_in_window:
Jul 11 11:25:24 testhost0 kernel: [  211.344048] seq=1537183414 
ack=985051953+(0) sack=985051953+(0) win=28960 end=1537183415
Jul 11 11:25:24 testhost0 kernel: [  211.344050] tcp_in_window: sender 
end=1537183415 maxend=1537183415 maxwin=28960 scale=7 receiver 
end=985051953 maxend=985051953 maxwin=29200 scale=7
Jul 11 11:25:24 testhost0 kernel: [  211.344051] tcp_in_window: I=1 II=1 
III=1 IV=1
Jul 11 11:25:24 testhost0 kernel: [  211.344054] tcp_in_window: res=1 
sender end=1537183415 maxend=1537183415 maxwin=28960 scale=7 receiver 
end=985051953 maxend=985080913 maxwin=29200 scale=7 last dir=0 seq=0 ack=0 
end=0 win=0 retrans=0
Jul 11 11:25:24 testhost0 kernel: [  211.344055] tcp_conntracks:
Jul 11 11:25:24 testhost0 kernel: [  211.344057] syn=1 ack=1 fin=0 rst=0 
old=1 new=2
Jul 11 11:25:24 testhost0 kernel: [  211.344888] tcp_in_window: START
Jul 11 11:25:24 testhost0 kernel: [  211.344888] tcp_in_window:
Jul 11 11:25:24 testhost0 kernel: [  211.344889] seq=985051953 
ack=1537183415+(0) sack=1537183415+(0) win=229 end=985051953
Jul 11 11:25:24 testhost0 kernel: [  211.344891] tcp_in_window: sender 
end=985051953 maxend=985080913 maxwin=29200 scale=7 receiver 
end=1537183415 maxend=1537183415 maxwin=28960 scale=7 last dir=1 seq=0 
ack=0 end=0 win=0 retrans=0
Jul 11 11:25:24 testhost0 kernel: [  211.344891] tcp_in_window:
Jul 11 11:25:24 testhost0 kernel: [  211.344892] seq=985051953 
ack=1537183415+(0) sack=1537183415+(0) win=229 end=985051953
Jul 11 11:25:24 testhost0 kernel: [  211.344892] tcp_in_window: sender 
end=985051953 maxend=985080913 maxwin=29200 scale=7 receiver 
end=1537183415 maxend=1537183415 maxwin=28960 scale=7
Jul 11 11:25:24 testhost0 kernel: [  211.344893] tcp_in_window: I=1 II=1 
III=1 IV=1
Jul 11 11:25:24 testhost0 kernel: [  211.344894] tcp_in_window: res=1 
sender end=985051953 maxend=985080913 maxwin=29312 scale=7 receiver 
end=1537183415 maxend=1537212727 maxwin=28960 scale=7 last dir=0 
seq=985051953 ack=1537183415 end=985051953 win=29312 retrans=0
Jul 11 11:25:24 testhost0 kernel: [  211.344894] tcp_conntracks:
Jul 11 11:25:24 testhost0 kernel: [  211.344895] syn=0 ack=1 fin=0 rst=0 
old=2 new=3


Looks like the only relevant difference between these two is that in "bad" 
case state->last_win stays 0.


Regards,
  Jakub.

-- 
Jakub Jankowski|shasta@toxcorp.com|https://toxcorp.com/
