From: Peter Warasin <peter@endian.com>
Subject: TPROXY does not redirect to squid port
Date: Wed, 29 Jan 2014 11:10:55 +0100
Message-ID: <52E8D3AF.4020600@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52108 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaA2KKz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:10:55 -0500
Received: by mail-wg0-f49.google.com with SMTP id a1so3091756wgh.16
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2014 02:10:54 -0800 (PST)
Received: from [10.7.5.191] (78-134-2-191.v4.ngi.it. [78.134.2.191])
        by mx.google.com with ESMTPSA id a9sm41344309wiy.10.2014.01.29.02.10.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 29 Jan 2014 02:10:53 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys

Recently asked on squid mailinglist. But I fear this is more deep issue,
so I ask here. Hope someone can help.



I configured a transparent proxy environment using TPROXY following the
howto on the squid wiki http://wiki.squid-cache.org/Features/Tproxy4
I setup a tproxy port in squid on port 18080 and created the following
iptables rule:

-A PREROUTING -p tcp --dport 80 -j TPROXY --on-port 18080 --tproxy-mark
0x1/0x1

But squid does never see packets coming in.

So I tried with the following tool:
https://github.com/kristrev/tproxy-example
The same, packets are not seen.

By chance I tried to redirect to port 80 instead of 18080, in order that
redirection does not happen at all, and then packets were seen by the
tproxy-example tool.

Seems that redirection is not working correctly or not at all.


I proved with iptables logging rules that routing is correct, because
packets are coming in the INPUT chain instead of FORWARD and are marked
as they should be.

Also I see the following debug output when compiled the tproxy iptables
modules with -DDEBUG:

xt_TPROXY: tproxy socket lookup: proto 6 c0a80b37:37894 ->
c2e8688e:18080, lookup type: 2, sock   (null)
xt_TPROXY: tproxy socket lookup: proto 6 c0a80b37:37894 ->
c0a80b0f:18080, lookup type: 1, sock f4453700
xt_TPROXY: redirecting: proto 6 194.232.104.142:80 ->
192.168.11.15:18080, mark: 1

which I would say means socket lookup actually *is* taking place and it
even finds the correct squid socket. looks all correct. But why then
there is no accept() on server side?


I tried with both, squid 3.2.1 and 3.3.8 and with kernels 2.6.32 and
3.2.54 and combinations. Always the same result.
(I know 2.6.32 is buggy, that's why I tried with 3.2.54 as well, which
should be sufficient according squid wiki)

I flushed every iptables rule, no drop rule anywhere, no nat.
Routing is this:

ip route add local 0.0.0.0/0 dev lo table 100
ip ru add fwmark 1/1 lookup 100
(tried with both lo and eth0)

also disabled all rp filters.

in fact, it is working with port 80 -> port 80, it is not with port 80
-> port 18080, so setup should be ok i guess.
It also does not work when I use another target port, like 9876 instead
of 18080.

Do I maybe need a more recent glibc?? (I guess not)


Does anyone have some hints where I could look at in order to solve this?

Thank you in advance

Peter

-- 
:: e n d i a n
:: security with passion

:: peter warasin
:: http://www.endian.com   :: peter@endian.com
