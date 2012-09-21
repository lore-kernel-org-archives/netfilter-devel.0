From: Aidas Kasparas <a.kasparas@gmc.lt>
Subject: Re: How to add wildcard netmask to ipset?
Date: Fri, 21 Sep 2012 11:27:17 +0300
Message-ID: <505C24E5.1090307@gmc.lt>
References: <CAK6Qs9=Q4tpOjB6JfcSS3fbnyQdAv_Oqcz4zzqqZx5e10PvrAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: =?UTF-8?B?xLBicmFoaW0gRXJjYW4=?= <ibrahim.ercan@engineer.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CAK6Qs9=Q4tpOjB6JfcSS3fbnyQdAv_Oqcz4zzqqZx5e10PvrAg@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2012.09.21 10:35, =C4=B0brahim Ercan wrote:
> Hello,
>
> We are using ipset and we want to add wildcard netmasks to ipset. We
> are using hash:net to store our ips. Ipset does not accept adding
> netmasks so when adding a network like 192.168.1.0/255.255.255.0 we
> convert it to 192.168.1.0/24 CIDR notation and add. But a network lik=
e
> 192.168.2.0/255.0.255.0 cannot be converted to CIDR nor can be added
> to ipset. What can we do?
>
You can allways add 256 entries into your ipset: 192.i.2.0/24 for all i
in 0..255 .
On the other hand, what do you use masks like these for?

--=20
Aidas Kasparas
IT administrator
GM Consult Group, UAB

+370 686 08473
http://www.gmc.lt

