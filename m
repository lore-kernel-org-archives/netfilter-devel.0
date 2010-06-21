From: krunal patel <krunal.raj@gmail.com>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Mon, 21 Jun 2010 20:48:27 +0530
Message-ID: <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com>
	<alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61461 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab0FUPSa convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:18:30 -0400
Received: by gye5 with SMTP id 5so2234561gye.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2010 08:18:29 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 21, 2010 at 7:02 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> Hi,
>
> On Mon, 21 Jun 2010, krunal patel wrote:
>
>> =A0 =A0 I found a difference in performance of ipset 4.2 with with
>> linux-2.6.18.8 =A0and linux-2.6.27.45.
>> =A0 =A0 With 1.5 Gbps of traffic and with 3 ipset rules added in for=
ward
>> path, I got response time of 6 msecs in both kernels.
>> =A0 =A0 If i increase number of ipset rules, response time increases=
 badly
>> in case of 2.6.27.45 kernel, where it is same (6 msecs) in 2.6.18.8
>> kernel.
>
> I'm sorry but I simply don't get what you want to measure:
>

I am measuring packet latency when ipset is used in packet path with
2.6.27.45 kernel at arond 3 to 3.5 Gbps of traffic. I am doing this as
a part of kernel switch from 2.6.18.8 to 2.6.27.45.

>> =A0 =A0 I am testing my machine with Spirent (load generator). Only =
HTTP
>> protocol load is passed through machine.
>> =A0 =A0 following are the steps.
>>
>> =A0 =A0 =A0 =A0iptables -F PREROUTING -t raw
>> =A0 =A0 =A0 =A0iptables -F PREROUTING -t mangle
>> =A0 =A0 =A0 =A0iptables -F PREROUTING -t nat
>> =A0 =A0 =A0 =A0iptables -F FORWARD -t mangle
>> =A0 =A0 =A0 =A0iptables -F FORWARD -t filter
>> =A0 =A0 =A0 =A0iptables -F POSTROUTING -t mangle
>> =A0 =A0 =A0 =A0iptables -F POSTROUTING -t nat
>>
>> =A0 =A0 =A0 =A0ipset -N testip iphash --hashsize 1
>> =A0 =A0 =A0 =A0ipset -A testip 1.2.3.4 (=3D> This can be any IP. Her=
e it is not
>> used for any purpose other then performance testing)
>
> So I assume the source IP address of the packets won't match the
> testip set.
>

Yes, rules are just to add more ipset chains.


>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set --set testip src
>
> You do not measure ipset definitely. Because there is no target in th=
e
> rules, all of them are evaluated one after another, regardless of the
> previous ones: netfilter just increases the packet/byte counters of t=
he
> matching rules, but continues by processing the next rule(s).
>

No, we are measuring only ipset. What we are suspecting is, as number
of ipset matches increases in packet path latency is increasing.

>> =A0 =A0 Up to here everything is fine in linux-2.6.18.8 and
>> linux-2.6.27.45. - HTTP response time is 6ms.
>>
>> =A0 =A0 After that I added 2 3 more chains.
>>
>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
>>
>> =A0 =A0 Now HTTP response time for linux-2.6.18.8 is constant to 6ms=
ecs
>> whereas it increases to 1000ms in linux-2.6.27.45 and even increases
>> more if I keep on adding same rule.
>
> You mean, by adding three more non-matching rules the response time
> increased from 6msecs to 1000msecs??
>

Hmm, that is correct. Infact,
1000 msecs is just by adding 1 more rule. 3 rules took it to around
3000 to 4000 msecs.
Note that with 2.6.18.8, latency is not getting increased by adding
more ipset rules. (to be precise it is around 6 msesc)

> Best regards,
> Jozsef
> -
> E-mail =A0: kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
> =A0 =A0 =A0 =A0 =A0H-1525 Budapest 114, POB. 49, Hungary
>

Regards,
Krunal.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
