From: Oleg <lego12239@yandex.ru>
Subject: libnetfilter_queue & multithreading
Date: Sat, 22 Jul 2017 16:08:49 +0300
Message-ID: <20170722130849.GA25501@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward15j.cmail.yandex.net ([5.255.227.179]:49194 "EHLO
        forward15j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750787AbdGVNOr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Jul 2017 09:14:47 -0400
Received: from smtp2p.mail.yandex.net (smtp2p.mail.yandex.net [77.88.29.85])
        by forward15j.cmail.yandex.net (Yandex) with ESMTP id 0B633214C4
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Jul 2017 16:07:07 +0300 (MSK)
Received: from smtp2p.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp2p.mail.yandex.net (Yandex) with ESMTP id C2AA01A80061
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Jul 2017 16:07:06 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi, all.

My program process multiple NFQUEUEs by creating a separate thread
for every NFQUEUE. An each thread do recv() and nfq_set_verdict2():

main()
{
...
    for(i = 0; i < q_cnt; i++) {
        ret = pthread_create(&(thread_data[i].id), NULL, thread_start,
          &thread_data[i].nfq_num);
        if (ret != 0) {
            fprintf(stderr, "thread creation error: %s", strerror(ret));
            exit(EXIT_FAILURE);
        }
    }
...
}

static void*
thread_start(void *data)
{
        struct nfq_handle *h;
        int fd, n;
        static char *pkt_buf;
        unsigned int nfq_num = *(unsigned int*)data;

        pkt_buf = (char*)malloc(80000);
        if (!pkt_buf) {
                fprintf(stderr, "packet buffer allocating error: no memory");
                exit(EXIT_FAILURE);
        }
        h = init_nfq(nfq_num);      
        fd = nfq_fd(h);
        while ((n = recv(fd, pkt_buf, 80000, 0)) > 0) {
                nfq_handle_packet(h, pkt_buf, n);
        }
...
}

static struct nfq_handle*
init_nfq(unsigned int nfq_num)
{
        struct nfq_handle *h;
        struct nfq_q_handle *qh;
        
        h = nfq_open();
        if (!h) {
                fprintf(stderr, "nfq error: queue %d nfq_open() error", nfq_num);
                exit(EXIT_FAILURE);
        }
        if (nfq_unbind_pf(h, AF_INET) < 0) {
                fprintf(stderr, "nfq error: queue %d nfq_bind_pf() error", nfq_num);
                exit(EXIT_FAILURE);
        }
        if (nfq_bind_pf(h, AF_INET) < 0) {
                fprintf(stderr, "nfq error: queue %d nfq_bind_pf() error", nfq_num);
                exit(EXIT_FAILURE);
        }
        qh = nfq_create_queue(h, nfq_num, &cb, NULL);
        if (!qh) {
                fprintf(stderr, "nfq error: queue %d nfq_create_queue() error", nfq_num);
                exit(EXIT_FAILURE);
        }
        if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {
                fprintf(stderr, "nfq error: queue %d nfq_set_mode() error", nfq_num);
                exit(EXIT_FAILURE);
        }
        
        return h;
}


Since every thread do nfq_open(), has a separate descriptor and etc, i think
i don't need a lock around recv() and nfq_set_verdict2(). Am i right?

Thanks!

-- 
Олег Неманов (Oleg Nemanov)
