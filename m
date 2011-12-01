From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: nat drop the icmp redirect packet
Date: Thu, 01 Dec 2011 08:59:56 +0800
Message-ID: <4ED6D18C.7000802@cn.fujitsu.com>
References: <4ED2E00B.3000006@cn.fujitsu.com> <4ED67BB1.8020808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1LAA7O convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:59:14 -0500
In-Reply-To: <4ED67BB1.8020808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=D3=DA 2011=C4=EA12=D4=C201=C8=D5 02:53, Patrick McHardy =D0=B4=B5=C0:
> On 11/28/2011 02:12 AM, Gao feng wrote:
>> Hi
>>
>> In func nf_nat_icmp_reply_translation,the icmp packet will be droped=
 when the nat is not finished.
>> pc A(whose gateway is C) send a icmp request to pc B.
>> When gw C receive this packet,it may return a icmp redirect packet t=
o A.
>> BUT now,the icmp request packet has not go to POSTROUTING,So the nat=
 is not finished.
>> Finally,the icmp redirect packet will be droped no matter the conn h=
as nat or not.
>>
>> of course,the icmp redirect packet will be correct handled when nat =
is finished.
>>
>> Can somebody will give me some suggestion,
>> or should I just add a sysctl to let the user decide drop or receive=
 this icmp redirect packet when nat is not finished?
>=20
> It doesn't matter whether the ICMP packet has gone through
> POST_ROUTING, the conntrack associated with the packet is
> that of the original packet causing the ICMP REDIRECT (or
> any other kind of ICMP error).
>=20
> Basically, we don't want hosts talking directly to each other
> *if* NAT has been set up since that would obviously break
> things. In the case you describe (only destination NAT setup
> completed, but null mapping) instead of dropping the packet,
> we could set up a null source mapping and let the packet
> through under the assumption that the hosts will then start
> communicating directly.
>=20
> This will break if the host receiving the ICMP REDIRECT ignores
> it though. What is the specific problem you're trying to solve?
>=20

Thanks Patrick!

As I said,in my case,the *first* ICMP REDIRECT packet will be dropped e=
ven
the system has no nat rules,because this REDIRECT packet is triggered
by the original packet in FORWARD chain(ip_forward),and when this REDIR=
ECT
packet goto POSTROUTING chian(nf_nat_fn->nf_nat_icmp_reply_translation)=
,the
original packet is still in FORWARD chain.So the original packet's conn=
track
ONLY has IPS_DST_NAT_DONE.

I understand your mean,we should not let REDIRECT to take effect when t=
his conntrack
has nat rule.

I just want to know is there some idea to avoid the first ICMP_REDIRECT=
 packet being dropped?

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
