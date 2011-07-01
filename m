From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC] nfnetlink_queue not scalable
Date: Fri, 01 Jul 2011 09:00:10 +0200
Message-ID: <1309503610.2515.18.camel@edumazet-laptop>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>
	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>
	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C651A.1000300@trash.net>
	 <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C8902.8070303@earthlink.net> <4E0C8D7F.3000902@trash.net>
	 <1309453730.5846.31.camel@tiger.regit.org>
	 <1309455919.2515.3.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: sclark46@earthlink.net, Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>, Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fwestphal@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33536 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab1GAHAQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:00:16 -0400
Received: by wwe5 with SMTP id 5so2941849wwe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Jul 2011 00:00:15 -0700 (PDT)
In-Reply-To: <1309455919.2515.3.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So I took a look at using several queues to spread load on several cpus,
and quickly found out some hot spots in our NFQUEUE processing, even
using cpu match, and correct cpu affinities.

iptables -N DISPATCH 2>/dev/null
iptables -F DISPATCH

for i in  `seq 0 15`
do
 iptables -A DISPATCH -m cpu --cpu $i -j NFQUEUE --queue-num $i
 nfqnl_test -q $i &
done
iptables -A FORWARD -j DISPATCH

<stress load, 500.000 pps >

# cat /proc/net/netfilter/nfnetlink_queue 
    0   4855     0 2 65535     0 37638   886112  1
    1   4858     0 2 65535     0 24530   886096  1
    2   4862     0 2 65535     0 40666   886103  1
    3   4866     0 2 65535     0  6480   830716  1
    4   4870     0 2 65535     0 35957   886099  1
    5   4872     0 2 65535     0 20001   886100  1
    6   4875     0 2 65535     0 41656   886099  1
    7   4877     0 2 65535     0 27196   886099  1
    8   4879     0 2 65535     0 39173   886112  1
    9   4881     0 2 65535     0 19840   886103  1
   10   4883     0 2 65535     0 29339   850670  1
   11   4885     0 2 65535     0 17933   886102  1
   12   4887     0 2 65535     0 37680   886099  1
   13   4889     0 2 65535     0  7327   830721  1
   14   4891     0 2 65535     0 35577   886100  1
   15   4893     0 2 65535     0 23854   886100  1


Number one offender is the nfnl_lock mutex hold each time we give a
verdict.

Number two is the nl_table_lock rwlock

# Events: 28K cycles
#
# Overhead       Command                Shared Object                               Symbol
# ........  ............  ...........................  ...................................
#
    10.60%    nfqnl_test  [kernel.kallsyms]            [k] mutex_spin_on_owner
              |
              --- mutex_spin_on_owner
                 |          
                 |--99.68%-- __mutex_lock_slowpath
                 |          mutex_lock
                 |          nfnl_lock
                 |          nfnetlink_rcv
                 |          netlink_unicast
                 |          netlink_sendmsg
                 |          sock_sendmsg
                 |          __sys_sendmsg
                 |          sys_sendmsg
                 |          compat_sys_sendmsg
                 |          compat_sys_socketcall
                 |          sysenter_dispatch
                 |          0xffffe430
                 |          nfnl_sendiov
                 |          __set_verdict
                 |          cb
                 |          __nfnl_handle_msg
                 |          nfnl_handle_packet
                 |          nfq_handle_packet
                 |          main
                 |          __libc_start_main
                 |          _start
                  --0.32%-- [...]

     4.12%    nfqnl_test  [kernel.kallsyms]            [k] __mutex_lock_slowpath
              |
              --- __mutex_lock_slowpath
                 |          
                 |--99.68%-- mutex_lock
                 |          nfnl_lock



Time to add RCU ;)



