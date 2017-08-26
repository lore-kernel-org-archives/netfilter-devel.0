From: Oleg <lego12239@yandex.ru>
Subject: libnetfilter_queue & multithreading & 1 queue freezing
Date: Sat, 26 Aug 2017 18:07:38 +0300
Message-ID: <20170826150738.GA15203@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward101o.mail.yandex.net ([37.140.190.181]:42990 "EHLO
        forward101o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750931AbdHZPMt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2017 11:12:49 -0400
Received: from mxback9o.mail.yandex.net (mxback9o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::23])
        by forward101o.mail.yandex.net (Yandex) with ESMTP id B284D1343388
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Aug 2017 18:05:31 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi, all.

My program process multiple NFQUEUEs by creating a separate thread
for every NFQUEUE. An each thread do recv() and nfq_set_verdict2():

But i catch a strange behaviour when more than 1 thread(queue) are
used. In those cases one queue "freeze" while others works right.
For example, for 5 queues(here a queue with id 1 "freeze"):

# cat /proc/net/netfilter/nfnetlink_queue 
    0  -4216     4 2 65531     0     0   533513  1
    1  19395  1024 2 65531  7319     0     1024  1
    2  -4217     0 2 65531     0     0    62736  1
    3  -4218     0 2 65531     0     0   150717  1
    4  -4215    19 2 65531     0     0  1990176  1

# grep 'start thread' /var/log/messages
Aug 26 17:52:52 kvm trfl[19395]: start thread 2[19398] for nfqueue 2
Aug 26 17:52:52 kvm trfl[19395]: start thread 0[19396] for nfqueue 0
Aug 26 17:52:52 kvm trfl[19395]: start thread 1[19397] for nfqueue 1
Aug 26 17:52:52 kvm trfl[19395]: start thread 4[19400] for nfqueue 4
Aug 26 17:52:52 kvm trfl[19395]: start thread 3[19399] for nfqueue 3

# strace -p 19397
strace: Process 19397 attached
recvfrom(6, ^Cstrace: Process 19397 detached
 <detached ...>

This behaviour is not constantly reproducible.
If i use SO_RCVTIMEO:

  tv.tv_sec = 2;
  tv.tv_usec = 0;
  ret = setsockopt(nfq_fd(h), SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));

  ....

  fd = nfq_fd(h);
  do {
    while ((n = recv(fd, pkt_buf, 80000, 0)) > 0) {
      nfq_handle_packet(h, pkt_buf, n);
    }
    fprintf(stderr, "%u: RECV ERR: %s", thread_idx, strerror(errno));
  } while (errno == EWOULDBLOCK);

then i get every 2 seconds the next message:

0: RECV ERR: Resource temporarily unavailable

for case when thread with id = 0 freeze on recvfrom().

How can i resolve this problem?

Thanks!

-- 
Олег Неманов (Oleg Nemanov)
