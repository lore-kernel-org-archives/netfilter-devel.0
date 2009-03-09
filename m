From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: NFQUEUE stucked packets
Date: Mon, 9 Mar 2009 17:46:58 +0300
Message-ID: <18390532.20090309174658@yandex.ru>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards5.yandex.ru ([77.88.61.37]:46823 "EHLO
	forwards5.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZCIOwK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:52:10 -0400
Received: from smtp19.yandex.ru (smtp19.yandex.ru [77.88.61.35])
	by forwards5.yandex.ru (Yandex) with ESMTP id CA9D1AE46B
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Mar 2009 17:46:24 +0300 (MSK)
Received: from gw-212.mjknet.ru ([212.45.5.114]:36877 "EHLO www1.firststeps.ru"
        smtp-auth: "kuzinandrey" TLS-CIPHER: <none> TLS-PEER-CN1: <none>)
        by mail.yandex.ru with ESMTP id S3096827AbZCIOqT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Mar 2009 17:46:19 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello list!

I have similar situation as described in
http://lists.netfilter.org/pipermail/netfilter-devel/2006-January/023153.html

I have network gateway for 700 users with average 30-40 mbit channel
utilization. For traffic acounting using NFQUEUE for realtime
statistics and user MAC address security.

root@darkstar:/#  uname -a
Linux darkstar 2.6.28.7-smp #1 SMP Mon Mar 9 14:07:23 MSK 2009
i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux

Yesterday all day queue overflow in about 10 min.
I write special script to discover this situation.

#!/bin/sh
QUEUE_NUM=10
while [ 1 ]; do
    TOTAL=
    DATE=`date +"%Y-%m-%d %H:%M:%S"`
    CAT=`cat /proc/net/netfilter/nfnetlink_queue | grep $QUEUE_NUM`
    QUEUE_TOTAL=`echo $CAT | cut -f 3 -d ' '`
    echo $CAT $DATE =$QUEUE_TOTAL
    sleep 10
done

And have this log:
=======================
10 26197 89 2 65535 0 40 157532 1 2009-03-08 19:18:00 =89
10 26197 80 2 65535 0 99 306347 1 2009-03-08 19:18:11 =80
10 26197 97 2 65535 0 198 453838 1 2009-03-08 19:18:21 =97
10 26197 120 2 65535 0 254 600438 1 2009-03-08 19:18:31 =120
10 26197 162 2 65535 0 254 740278 1 2009-03-08 19:18:41 =162
10 26197 165 2 65535 0 385 886832 1 2009-03-08 19:18:51 =165
10 26197 173 2 65535 0 477 1030473 1 2009-03-08 19:19:01 =173
10 26197 195 2 65535 0 477 1173828 1 2009-03-08 19:19:11 =195
10 26197 199 2 65535 0 613 1320007 1 2009-03-08 19:19:21 =199
......
10 26197 1314 2 65535 0 150480 8682536 1 2009-03-08 19:30:54 =1314
10 26197 1297 2 65535 0 155210 8762215 1 2009-03-08 19:31:04 =1297
10 26197 1395 2 65535 0 159517 8840470 1 2009-03-08 19:31:14 =1395
10 26197 1431 2 65535 0 164050 8917428 1 2009-03-08 19:31:24 =1431
10 26197 1426 2 65535 0 168789 8997451 1 2009-03-08 19:31:34 =1426
10 26197 1440 2 65535 0 173915 9077845 1 2009-03-08 19:31:44 =1440
10 26197 1469 2 65535 0 179015 9152595 1 2009-03-08 19:31:54 =1469
10 26197 1499 2 65535 0 183489 9226571 1 2009-03-08 19:32:04 =1499
10 26197 1564 2 65535 0 188427 9296313 1 2009-03-08 19:32:14 =1564

After about 10-15 min we have very big delays for each packet.
Restart of accounting program flush the queue and starting again:

10 12083 32 2 65535 0 290 129955 1 2009-03-08 19:32:37 =32
10 12083 123 2 65535 0 404 263677 1 2009-03-08 19:32:47 =123
10 12083 192 2 65535 0 577 395122 1 2009-03-08 19:32:57 =192
10 12083 140 2 65535 0 739 524411 1 2009-03-08 19:33:08 =140
10 12083 193 2 65535 0 1209 654960 1 2009-03-08 19:33:18 =193
10 12083 247 2 65535 0 1465 805822 1 2009-03-08 19:33:28 =247
10 12083 283 2 65535 0 1610 945017 1 2009-03-08 19:33:38 =283
10 12083 402 2 65535 0 1775 1073752 1 2009-03-08 19:33:48 =402
.....
10 12083 1358 2 65535 0 49719 4501398 1 2009-03-08 19:39:19 =1358
10 12083 1383 2 65535 0 54400 4578319 1 2009-03-08 19:39:29 =1383
10 12083 1484 2 65535 0 57611 4651952 1 2009-03-08 19:39:39 =1484
10 12083 1433 2 65535 0 61306 4727467 1 2009-03-08 19:39:49 =1433
10 12083 1478 2 65535 0 64507 4800503 1 2009-03-08 19:39:59 =1478
10 12083 1468 2 65535 0 68569 4873713 1 2009-03-08 19:40:09 =1468
10 12083 1516 2 65535 0 72345 4947701 1 2009-03-08 19:40:19 =1516

At night situation was not such terrible..

10 25572 3 2 65535 0 0 81409 1 2009-03-09 04:56:14 =3
10 25572 18 2 65535 0 0 166434 1 2009-03-09 04:56:24 =18
10 25572 36 2 65535 0 73 250703 1 2009-03-09 04:56:34 =36
10 25572 45 2 65535 0 78 346981 1 2009-03-09 04:56:44 =45
10 25572 17 2 65535 0 89 429374 1 2009-03-09 04:56:54 =17
10 25572 12 2 65535 0 89 513713 1 2009-03-09 04:57:04 =12
10 25572 15 2 65535 0 89 597835 1 2009-03-09 04:57:14 =15
.....
10 25572 1252 2 65535 0 3767514 188608304 1 2009-03-09 11:57:04 =1252
10 25572 1246 2 65535 0 3773969 188693799 1 2009-03-09 11:57:14 =1246
10 25572 1237 2 65535 0 3779614 188777734 1 2009-03-09 11:57:24 =1237
10 25572 1261 2 65535 0 3785212 188860586 1 2009-03-09 11:57:34 =1261
10 25572 1242 2 65535 0 3790644 188941483 1 2009-03-09 11:57:44 =1242
10 25572 1266 2 65535 0 3796270 189021111 1 2009-03-09 11:57:54 =1266
10 25572 1283 2 65535 0 3801408 189105046 1 2009-03-09 11:58:04 =1283
10 25572 1278 2 65535 0 3806845 189183468 1 2009-03-09 11:58:14 =1278
10 25572 1242 2 65535 0 3812415 189265729 1 2009-03-09 11:58:24 =1242
10 25572 1242 2 65535 0 3818292 189343670 1 2009-03-09 11:58:34 =1242

As you see after 189 millions of packet we have 1242 stucked packets
in queue.

Today i try to modify kernel to get more information about this:

diff -rcB nfnetlink_queue.c-orig nfnetlink_queue.c
======= cut here ==========
*** nfnetlink_queue.c-orig      Sat Feb 21 01:41:27 2009
--- nfnetlink_queue.c   Mon Mar  9 17:04:27 2009
***************
*** 169,178 ****
--- 169,181 ----
         queue->queue_total++;
  }

+ static unsigned int max_dequeue_position = 0;
+
  static struct nf_queue_entry *
  find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
  {
        struct nf_queue_entry *entry = NULL, *i;
+       int dequeue_position = 0;

        spin_lock_bh(&queue->lock);

***************
*** 180,188 ****
                if (i->id == id) {
                        entry = i;
                        break;
!               }
        }

        if (entry) {
                list_del(&entry->list);
                queue->queue_total--;
--- 183,195 ----
                if (i->id == id) {
                        entry = i;
                        break;
!               } else dequeue_position++;
        }

+       if (max_dequeue_position < dequeue_position) {
+           max_dequeue_position = dequeue_position;
+       };
+
        if (entry) {
                list_del(&entry->list);
                queue->queue_total--;
***************
*** 860,871 ****
  {
        const struct nfqnl_instance *inst = v;

!       return seq_printf(s, "%5d %6d %5d %1d %5d %5d %5d %8d %2d\n",
                          inst->queue_num,
!                         inst->peer_pid, inst->queue_total,
                          inst->copy_mode, inst->copy_range,
                          inst->queue_dropped, inst->queue_user_dropped,
!                         inst->id_sequence, 1);
  }

  static const struct seq_operations nfqnl_seq_ops = {
--- 867,878 ----
  {
        const struct nfqnl_instance *inst = v;

!       return seq_printf(s, "%5d %6d %5d %5d %1d %5d %5d %5d %8d %2d %5d\n",
                          inst->queue_num,
!                         inst->peer_pid, inst->queue_total, inst->queue_maxlen,
                          inst->copy_mode, inst->copy_range,
                          inst->queue_dropped, inst->queue_user_dropped,
!                         inst->id_sequence, 1, max_dequeue_position);
  }

  static const struct seq_operations nfqnl_seq_ops = {


======= end of cut ==========

And after that i have information in /proc about queue_maxlen and
stucked packets in queue.
Log with this patch:
10 3052 55 20000 2 65535 0 3194 1563090 1 0 2009-03-09 14:22:32 =55
10 3052 0 20000 2 65535 0 3750 1680510 1 0 2009-03-09 14:22:42 =0
10 3052 0 20000 2 65535 0 4666 1806095 1 0 2009-03-09 14:22:52 =0
10 3052 36 20000 2 65535 0 5124 1934143 1 0 2009-03-09 14:23:02 =36
10 3052 0 20000 2 65535 0 5124 2067343 1 0 2009-03-09 14:23:12 =0
10 3052 0 20000 2 65535 0 5662 2185490 1 0 2009-03-09 14:23:22 =0
10 3052 3 20000 2 65535 0 5953 2314004 1 0 2009-03-09 14:23:32 =3
......
10 3052 85 20000 2 65535 0 41306 57183821 1 0 2009-03-09 15:38:46 =85
10 3052 3 20000 2 65535 0 41378 57287667 1 0 2009-03-09 15:38:56 =3
10 3052 23 20000 2 65535 0 41378 57383407 1 1 2009-03-09 15:39:06 =23
10 3052 1 20000 2 65535 0 41387 57488941 1 1 2009-03-09 15:39:16 =1
......
10 3052 36 20000 2 65535 0 45185 66286805 1 1 2009-03-09 15:52:39 =36
10 3052 1 20000 2 65535 0 45643 66403946 1 1 2009-03-09 15:52:49 =1
10 3052 20 20000 2 65535 0 46222 66522173 1 2 2009-03-09 15:52:59 =20
10 3052 41 20000 2 65535 0 46556 66642593 1 2 2009-03-09 15:53:09 =41
......
10 3052 73 20000 2 65535 0 169361 111410441 1 2 2009-03-09 16:48:20 =73
10 3052 61 20000 2 65535 0 169800 111517779 1 2 2009-03-09 16:48:30 =61
10 3052 60 20000 2 65535 0 170111 111626724 1 3 2009-03-09 16:48:40 =60
10 3052 62 20000 2 65535 0 170430 111738973 1 3 2009-03-09 16:48:50 =62
......
10 3052 117 20000 2 65535 0 224668 120418980 1 3 2009-03-09 16:59:42 =117
10 3052 3 20000 2 65535 0 224941 120567191 1 3 2009-03-09 16:59:52 =3
10 3052 101 20000 2 65535 0 225575 120724075 1 4 2009-03-09 17:00:02 =101
10 3052 70 20000 2 65535 0 225693 120886263 1 4 2009-03-09 17:00:12 =70
......
10 3052 6 20000 2 65535 0 365069 145741324 1 6 2009-03-09 17:28:48 =6
10 3052 6 20000 2 65535 0 365287 145925306 1 6 2009-03-09 17:28:58 =6
10 3052 99 20000 2 65535 0 365504 146113439 1 6 2009-03-09 17:29:08 =99
10 3052 95 20000 2 65535 0 365667 146296955 1 6 2009-03-09 17:29:18 =95
10 3052 6 20000 2 65535 0 365823 146489625 1 6 2009-03-09 17:29:28 =6
10 3052 97 20000 2 65535 0 365916 146676339 1 6 2009-03-09 17:29:39 =97
......

Today 3 hours of work with very high load (about 40 mbit and in peaks up
to 60 mbit) we have 6 packets stuck in queue...

How to resolve this problem ?
This is hardware bug, SMP bug, users corrupted packets bug, NFQUEUE
bug or anything else ? How i can view this stucked packets in queue to
try understand what is going wrong ?
(userspace don't have any errors, because this code work normally
from 2004 ip_queue ages, and we have this after rewrite application
for NFQUEUE)

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Kuzin Andrey  -  kuzinandrey@yandex.ru
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


