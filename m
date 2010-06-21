From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Mon, 21 Jun 2010 15:32:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: krunal patel <krunal.raj@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58686 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab0FUNcD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:32:03 -0400
In-Reply-To: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 21 Jun 2010, krunal patel wrote:

>     I found a difference in performance of ipset 4.2 with with
> linux-2.6.18.8  and linux-2.6.27.45.
>     With 1.5 Gbps of traffic and with 3 ipset rules added in forward
> path, I got response time of 6 msecs in both kernels.
>     If i increase number of ipset rules, response time increases badly
> in case of 2.6.27.45 kernel, where it is same (6 msecs) in 2.6.18.8
> kernel.

I'm sorry but I simply don't get what you want to measure:
 
>     I am testing my machine with Spirent (load generator). Only HTTP
> protocol load is passed through machine.
>     following are the steps.
> 
>        iptables -F PREROUTING -t raw
>        iptables -F PREROUTING -t mangle
>        iptables -F PREROUTING -t nat
>        iptables -F FORWARD -t mangle
>        iptables -F FORWARD -t filter
>        iptables -F POSTROUTING -t mangle
>        iptables -F POSTROUTING -t nat
> 
>        ipset -N testip iphash --hashsize 1
>        ipset -A testip 1.2.3.4 (=> This can be any IP. Here it is not
> used for any purpose other then performance testing)

So I assume the source IP address of the packets won't match the 
testip set.
 
>        iptables -A FORWARD -m set ! --set testip src
>        iptables -A FORWARD -m set ! --set testip src
>        iptables -A FORWARD -m set --set testip src

You do not measure ipset definitely. Because there is no target in the 
rules, all of them are evaluated one after another, regardless of the 
previous ones: netfilter just increases the packet/byte counters of the 
matching rules, but continues by processing the next rule(s).
 
>     Up to here everything is fine in linux-2.6.18.8 and
> linux-2.6.27.45. - HTTP response time is 6ms.
> 
>     After that I added 2 3 more chains.
> 
>        iptables -A FORWARD -m set ! --set testip src
>        iptables -A FORWARD -m set ! --set testip src
>        iptables -A FORWARD -m set ! --set testip src
> 
>     Now HTTP response time for linux-2.6.18.8 is constant to 6msecs
> whereas it increases to 1000ms in linux-2.6.27.45 and even increases
> more if I keep on adding same rule.

You mean, by adding three more non-matching rules the response time 
increased from 6msecs to 1000msecs??

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
