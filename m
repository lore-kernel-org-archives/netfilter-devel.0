From: Jesper Dangaard Brouer <netdev@brouer.com>
Subject: Re: [PATCH 11/14] netfilter: ipset: Introduce RCU locking in the
 hash types
Date: Mon, 1 Dec 2014 08:59:19 +0100
Message-ID: <20141201085919.4ecef9f7@brouer.com>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
	<1417373825-3734-12-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:49691 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaLAH7X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:59:23 -0500
Received: by mail-la0-f46.google.com with SMTP id q1so3422289lam.33
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Nov 2014 23:59:21 -0800 (PST)
In-Reply-To: <1417373825-3734-12-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 30 Nov 2014 19:57:02 +0100
Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:

> Performance is tested by Jesper Dangaard Brouer:
> 
> Simple drop in FORWARD
> ~~~~~~~~~~~~~~~~~~~~
> 
> Dropping via simple iptables net-mask match::
> 
>  iptables -t raw -N simple || iptables -t raw -F simple
>  iptables -t raw -I simple  -s 198.18.0.0/15 -j DROP
>  iptables -t raw -D PREROUTING -j simple
>  iptables -t raw -I PREROUTING -j simple
> 
> Drop performance in "raw": 11.3Mpps

This is multiple CPUs receiving with correct IRQ alignment with an
Intel ixgbe 10G NIC.  The 11.3Mpps seems to be some hardware limit
related to the NIC or CPU.
Tuning according to:
 http://netoptimizer.blogspot.dk/2014/04/basic-tuning-for-network-overload.html


> Generator: sending 12.2Mpps (tx:12264083 pps)

Generator based on trafgen, random src 198.18.1.x, description see:
 http://netoptimizer.blogspot.dk/2014/04/trafgen-fast-packet-generator.html

> Drop via original ipset in RAW table
> ~~~~~~~~~~~~~~~~~~~~~~~~~
[...]
> Drop performance in "raw" with ipset: 8Mpps
> 
> Perf report numbers ipset drop in "raw"::
> 
>  +   24.65%  ksoftirqd/1  [ip_set]           [k] ip_set_test
>  -   21.42%  ksoftirqd/1  [kernel.kallsyms]  [k] _raw_read_lock_bh
>     - _raw_read_lock_bh
>        + 99.88% ip_set_test
>  -   19.42%  ksoftirqd/1  [kernel.kallsyms]  [k] _raw_read_unlock_bh
>     - _raw_read_unlock_bh
>        + 99.72% ip_set_test
[...]

The read-side-lock were clearly a limiting factor in this extreme network
overload scenario.  This can be a valid use-case when using ipset for
DDoS protection/mitigation.

> Drop via ipset in RAW table with RCU-locking
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> With RCU locking, the RW-lock is gone.
> 
> Drop performance in "raw" with ipset with RCU-locking: 11.3Mpps
> 
> Performance-tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
