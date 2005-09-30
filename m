From: Richard Liu <richardliu@ms1.techarea.org>
Subject: Re: How to change source port in MASQUERADE mode?
Date: Sat, 01 Oct 2005 01:13:35 +0800
Message-ID: <433D723F.1060403@ms1.techarea.org>
References: <433CC0E0.5060308@ms1.techarea.org>
	<Pine.LNX.4.61.0509301356110.19019@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0509301356110.19019@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom =E6=8F=90=E5=88=B0:

Thanks for your mail,

But --to-port parameter cannot get tuple port result like "50000+1000"

I found a way for this situation.

in file ip_MASQUERADE.c
we can change
mr->range[0].min,
mr->range[0].max
and set
mr->range[0].flags =3D IP_NAT_RANGE_PROTO_SPECIFIED;
for some special purposes.

but I don't know does it have other effects to the netfilter?

> On Fri, 30 Sep 2005, Richard Liu wrote:
>
>> I want change tuple source port in MASQUERADE module.
>
>
> --to-ports option to MASQUERADE (or SNAT if not dynamic IP assignment).
>
>> But I want to the src port be changed in some conditions like this.
>> src:GA:50000+1000 src:SA:1000
>> dst:DA:23 dst:DA:23
>
>
