From: Patrick McHardy <kaber@trash.net>
Subject: Re: nat drop the icmp redirect packet
Date: Thu, 01 Dec 2011 11:20:26 +0100
Message-ID: <4ED754EA.9060906@trash.net>
References: <4ED2E00B.3000006@cn.fujitsu.com> <4ED67BB1.8020808@trash.net> <4ED6D18C.7000802@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39585 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1LAKU2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:20:28 -0500
In-Reply-To: <4ED6D18C.7000802@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/01/2011 01:59 AM, Gao feng wrote:
> =D3=DA 2011=C4=EA12=D4=C201=C8=D5 02:53, Patrick McHardy =D0=B4=B5=C0=
:
>> On 11/28/2011 02:12 AM, Gao feng wrote:
>>> Hi
>>>
>>> In func nf_nat_icmp_reply_translation,the icmp packet will be drope=
d when the nat is not finished.
>>> pc A(whose gateway is C) send a icmp request to pc B.
>>> When gw C receive this packet,it may return a icmp redirect packet =
to A.
>>> BUT now,the icmp request packet has not go to POSTROUTING,So the na=
t is not finished.
>>> Finally,the icmp redirect packet will be droped no matter the conn =
has nat or not.
>>>
>>> of course,the icmp redirect packet will be correct handled when nat=
 is finished.
>>>
>>> Can somebody will give me some suggestion,
>>> or should I just add a sysctl to let the user decide drop or receiv=
e this icmp redirect packet when nat is not finished?
>> It doesn't matter whether the ICMP packet has gone through
>> POST_ROUTING, the conntrack associated with the packet is
>> that of the original packet causing the ICMP REDIRECT (or
>> any other kind of ICMP error).
>>
>> Basically, we don't want hosts talking directly to each other
>> *if* NAT has been set up since that would obviously break
>> things. In the case you describe (only destination NAT setup
>> completed, but null mapping) instead of dropping the packet,
>> we could set up a null source mapping and let the packet
>> through under the assumption that the hosts will then start
>> communicating directly.
>>
>> This will break if the host receiving the ICMP REDIRECT ignores
>> it though. What is the specific problem you're trying to solve?
>>
> Thanks Patrick!
>
> As I said,in my case,the *first* ICMP REDIRECT packet will be dropped=
 even
> the system has no nat rules,because this REDIRECT packet is triggered
> by the original packet in FORWARD chain(ip_forward),and when this RED=
IRECT
> packet goto POSTROUTING chian(nf_nat_fn->nf_nat_icmp_reply_translatio=
n),the
> original packet is still in FORWARD chain.So the original packet's co=
nntrack
> ONLY has IPS_DST_NAT_DONE.
>
> I understand your mean,we should not let REDIRECT to take effect when=
 this conntrack
> has nat rule.
>
> I just want to know is there some idea to avoid the first ICMP_REDIRE=
CT packet being dropped

Yes, as I said, we could set up a NULL source mapping on the
conntrack of the original packet and let the REDIRECT through.
The user might have configured a source NAT rule though which
would become ineffective by this.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
