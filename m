From: Bhanu CV <vbhanu.mailinglists@gmail.com>
Subject: Re: How does iptables classify change skb priority
Date: Tue, 1 Feb 2011 10:10:56 -0800
Message-ID: <AANLkTinYJ9udZEOAyAse7Sg6r6Tho1pXLRG3ZLHjEn2o@mail.gmail.com>
References: <AANLkTimK=LsDOGJGFSFNxH_zC-zDWv=Z3FpLZAPt1g0E@mail.gmail.com>
	<4D48368B.6050906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:40227 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1BASK6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:10:58 -0500
Received: by fxm14 with SMTP id 14so1518228fxm.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Feb 2011 10:10:56 -0800 (PST)
In-Reply-To: <4D48368B.6050906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I had a qdisc with handle 0:3 would the behavior be different?

Thanks a lot for the response!
Bhanu

On Tue, Feb 1, 2011 at 8:36 AM, Patrick McHardy <kaber@trash.net> wrote:
> Am 01.02.2011 17:31, schrieb Bhanu CV:
>> Hi,
>>
>> I am trying to change the skb priority of the packets going out to a
>> particular destination. Then I use vlan set_egress_map to change the
>> vlan priority of the packet. This works as I want it to, the confusing
>> part is I do not know why it works!
>>
>> I use the following two commands:
>>
>> change the skb->priority (?) for the packets that I am interested in to 3:
>> iptables -t mangle -A POSTROUTING -d 192.168.10.75 -j CLASSIFY --set-class 0:3
>>
>> change the vlan priority of the packet leaving over the vlan
>> vconfig set_egress_map eth4.2 3 3
>>
>> This does send a packet on the wire with MAC layer priority of 3,
>> which is what I want. What I am trying to understand is the action
>> that iptables is taking. I do not have any class under the root qdisc
>> on eth4. The root qdisc has handle 0:
>>
>> It would be great if someone could explain how iptables is classifying
>> the packet in a way which changes the skb->priority of the packet.
>
> It simply changes the skb->priority value, which used by the VLAN
> driver to map to VLAN proprities. This is done by the VLAN driver
> internally and unrelated to qdiscs.
>
