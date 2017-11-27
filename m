From: Taehee Yoo <ap420073@gmail.com>
Subject: inquiry for behavior of xt_RATEEST.
Date: Tue, 28 Nov 2017 00:56:38 +0900
Message-ID: <CAMArcTUnhdgKXB5gXmpUaMZZQqC1eDGEMp24eCjbugVWEa6iYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, edumazet@google.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:34998 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbdK0P4j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 10:56:39 -0500
Received: by mail-qt0-f177.google.com with SMTP id n32so39669001qtb.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2017 07:56:39 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I found strange result while I test netfilter with RATEEST target and
rateest match.

please look at below test environment and result.

#Network
PC1(192.168.4.2) < ---> FW1(192.168.4.1)
PC2(192.168.5.2) < ---> FW2(192.168.5.1)

FW1 kernel version : before 1c0d32fde5bdf1184bc274f864c09799278a1114
FW2 kernel version : 1c0d32fde5bdf1184bc274f864c09799278a1114

#iptables rules (FW1 and FW2 have same rules)
iptables -t mangle -I PREROUTING -p udp --dport 1111 -j RATEEST
--rateest-name ap1 --rateest-interval 250ms --rateest-ewma 0.5s
iptables -t mangle -I PREROUTING -p udp --dport 1111 -j RATEEST
--rateest-name ap2 --rateest-interval 250ms --rateest-ewma 0.5s

iptables -t mangle -A PREROUTING -p udp --dport 1111 -m rateest
--rateest1 ap1 --rateest-eq --rateest2 ap2 --rateest-bps -j ACCEPT
iptables -t mangle -A PREROUTING -p udp --dport 1111 -m rateest
--rateest1 ap1 --rateest-gt --rateest2 ap2 --rateest-bps -j ACCEPT
iptables -t mangle -A PREROUTING -p udp --dport 1111 -m rateest
--rateest1 ap1 --rateest-lt --rateest2 ap2 --rateest-bps -j ACCEPT

iptables -t mangle -A PREROUTING -p udp --dport 1111 -m rateest
--rateest1 ap1 --rateest-eq --rateest2 ap2 --rateest-pps -j ACCEPT
iptables -t mangle -A PREROUTING -p udp --dport 1111 -m rateest
--rateest1 ap1 --rateest-gt --rateest2 ap2 --rateest-pps -j ACCEPT
iptables -t mangle -A PREROUTING -p udp --dport 1111 -m rateest
--rateest1 ap1 --rateest-lt --rateest2 ap2 --rateest-pps -j ACCEPT

#PC1
hping3 192.168.4.1 --udp -s 1 -p 1111 -k --flood
#PC2
hping3 192.168.5.1 --udp -s 1 -p 1111 -k --flood


#Result
#FW1
root@ubuntu:~# iptables -t mangle -vL
Chain PREROUTING (policy ACCEPT 392K packets, 573M bytes)
 pkts bytes target     prot opt in     out     source
destination
 644K   18M RATEEST    udp  --  any    any     anywhere
anywhere             udp dpt:1111 name ap2 interval 250.0ms ewmalog
500.0ms
 644K   18M RATEEST    udp  --  any    any     anywhere
anywhere             udp dpt:1111 name ap1 interval 250.0ms ewmalog
500.0ms
 644K   18M ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 bps eq ap2 bps
    0     0 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 bps gt ap2 bps
    0     0 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 bps lt ap2 bps
    0     0 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 pps eq ap2 pps
    0     0 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 pps gt ap2 pps
    0     0 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 pps lt ap2 pps

#FW2
root@fw2:/home/ap2# iptables -t mangle -vL
Chain PREROUTING (policy ACCEPT 5118 packets, 5571K bytes)
 pkts bytes target     prot opt in     out     source
destination
 266K 7447K RATEEST    udp  --  any    any     anywhere
anywhere             udp dpt:1111 name ap2 interval 250.0ms ewmalog
500.0ms
 266K 7447K RATEEST    udp  --  any    any     anywhere
anywhere             udp dpt:1111 name ap1 interval 250.0ms ewmalog
500.0ms
90439 2532K ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 bps eq ap2 bps
86528 2423K ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 bps gt ap2 bps
88978 2491K ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 bps lt ap2 bps
    0     0 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 pps eq ap2 pps
    2    56 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 pps gt ap2 pps
    0     0 ACCEPT     udp  --  any    any     anywhere
anywhere             udp dpt:1111 rateest match ap1 pps lt ap2 pps


behavior of RATEEST has been changed after
1c0d32fde5bdf1184bc274f864c09799278a1114.
FW1 kernel is bec60e50af83741cde1786ab475d4bf472aed6f9
and FW2 kernel is 1c0d32fde5bdf1184bc274f864c09799278a1114

I think behavior of FW1 is normal.
but FW2 is a little bit strange.
Could you tell me what is actually right behavior?

Thanks!
Taehee
