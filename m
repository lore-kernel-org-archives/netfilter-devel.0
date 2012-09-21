From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: How to add wildcard netmask to ipset?
Date: Fri, 21 Sep 2012 10:10:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209211009490.12509@blackhole.kfki.hu>
References: <CAK6Qs9=Q4tpOjB6JfcSS3fbnyQdAv_Oqcz4zzqqZx5e10PvrAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.ercan@engineer.com>,
	Oguz Yilmaz <oguzyilmazlist@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CAK6Qs9=Q4tpOjB6JfcSS3fbnyQdAv_Oqcz4zzqqZx5e10PvrAg@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Sep 2012, ?brahim Ercan wrote:

> We are using ipset and we want to add wildcard netmasks to ipset. We
> are using hash:net to store our ips. Ipset does not accept adding
> netmasks so when adding a network like 192.168.1.0/255.255.255.0 we
> convert it to 192.168.1.0/24 CIDR notation and add. But a network like
> 192.168.2.0/255.0.255.0 cannot be converted to CIDR nor can be added
> to ipset. What can we do?

Sorry, ipset does not support wildcard netmasks. You have to fall back to 
iptables.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
