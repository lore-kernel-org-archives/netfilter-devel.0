From: Piotr Sawicki <piotr.sawicki@gmail.com>
Subject: [NFQUEUE] lack of UID/GID fields in fragmented packets
Date: Sat, 17 Jun 2017 18:58:12 +0200
Message-ID: <oi3n2u$cs6$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46413 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdFQRFM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jun 2017 13:05:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gnnd-netfilter-devel@m.gmane.org>)
        id 1dMH9k-0001aW-NQ
        for netfilter-devel@vger.kernel.org; Sat, 17 Jun 2017 19:05:04 +0200
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm developing a user-space firewall service for managing outgoing 
network traffic. I want to control the access to the Internet on a per 
user basis.
So far, I've made a simple skeleton application which works quite well. 
The NFQUEUE is attached to the output chain of the mangle table.

Iptables -t mangle -A OUTPUT -j NFQUEUE --queue-num 0

The queue is configured to capture only meta-data of outgoing packets. 
The application reads the UID and GID fields from a captured packet. 
After checking a permission, the application issues a verdict. The 
configuration of NFQUEUE looks as follows:

nfq_set_mode (qh, NFQNL_COPY_META, 0xffff);
nfq_set_queue_flags (qh, NFQA_CFG_F_UID_GID, NFQA_CFG_F_UID_GID)

Everything works fine until I try to send huge packets. When the size of 
these packets is larger than MTU then the fragmentation occurs. I've 
observed that the first fragment has valid UID and GID fields, but the 
rest of the fragments do not include them.

I've found that the remedy for this concern is to set NFQA_CFG_F_GSO flag.

nfq_set_queue_flags (qh, NFQA_CFG_F_GSO, NFQA_CFG_F_GSO)

 From the analysis of the Linux kernel source code, I've figured out 
that when the above flag is not set, the processed packet is not 
fragmented before pushing it into the queue. So, the problem is in 
fragmentation mechanism.

The UID and GID fields (credentials) are taken from the socket structure 
(sk) of a socket buffer (skb) (skb->sk->sk_socket->file->f_cred). The sk 
field of skb may be NULL only if the skb originates from some internal 
kernel subsystem.

A user space application which sends network traffic via a BSD socket 
always produces skb having valid sk and thus having valid credentials.

I've found that when the fragmentation procedure splits the packet into 
fragments, it keeps a valid sk only in the first fragment. Therefore, it 
is impossible to fetch valid UID and GID fields from the rest of the 
fragments.

Is it intended behavior, or is it a bug?

