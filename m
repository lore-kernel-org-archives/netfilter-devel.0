From: Amin Azez <azez@ufomechanic.net>
Subject: Re: skb->mac.raw, when is does it point to ethhdr
Date: Fri, 29 Apr 2005 11:01:05 +0100
Message-ID: <427205E1.1000405@ufomechanic.net>
References: <d4r2n4$o39$1@sea.gmane.org>
	<20050429.022401.71711919.yoshfuji@wide.ad.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?=
	<yoshfuji@wide.ad.jp>
In-Reply-To: <20050429.022401.71711919.yoshfuji@wide.ad.jp>
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

YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E wrote:

>In article <d4r2n4$o39$1@sea.gmane.org> (at Thu, 28 Apr 2005 17:29:35 +0=
100), Amin Azez <azez@ufomechanic.net> says:
> =20
>
>>I've been treating skb->mac.raw as a pointer to ethhdr and stealing mac=
=20
>>addresses when conntrack's are created.
>>
>>So the question comes up, how do we tell when skb->mac.raw is pointing=20
>>to an ethernet frame header and when it is pointing to something else?
>>   =20
>>
>Basically, the hardware header (ether frame) is resolved / appended
>in the ip_finish_output2() (for IPv4) or ip6_output_finish() (for IPv6),
>after POST_ROUTING.
>Thus, in the POST_ROUTING (or before the POST_ROUTING),
>hardware header (ether frame) is not available (in most cases).
> =20
>
Thanks, for this, but the question is more complex.
conntrack only gets to inspect packets in PREROUTING and OUTPUT phases.
In this problem case the packet was originating from the local machine=20
and so as you pointed out the mac info won't be setup until POSTROUTING.

Generally I am only interesting in collecting mac addresses in PREROUTING.
I suppose I need to know which phase of netfilter triggered the=20
conntrack that triggered me. Until then I have stolen the ancient=20
bridging check which makes sure that skb->mac.raw points to somewhere=20
within skb, so I can tell it is at least a valid pointer.

Is there anyway to tell if skb>mac.raw it points to an ethernet mac=20
address, or an X25 linklayer address, or appletalk, etc?
Having a valid pointer is one thing, but knowing what it points to is=20
another.

Thanks

Amin
