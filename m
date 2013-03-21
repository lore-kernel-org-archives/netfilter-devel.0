From: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Subject: Re: Drop a packet while keeping the conntrack alive
Date: Thu, 21 Mar 2013 16:17:47 +0100
Message-ID: <CACd4Q00XP-OS8=9QM-Oyks9sp2qSGzQBYLHvmCh6r3J-JgjjWA@mail.gmail.com>
References: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
 <20130321015306.GB3779@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35531 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab3CUPSJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:18:09 -0400
Received: by mail-wi0-f176.google.com with SMTP id hm14so6691637wib.15
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2013 08:18:07 -0700 (PDT)
In-Reply-To: <20130321015306.GB3779@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 21, 2013 at 2:53 AM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> Packets that are invalid do not destroy the conntrack entry. The TCP
> tracker explicitly destroys the entry by calling nf_ct_kill function
> in some situations (RST seen / tracking is out-of-sync).
>

Well, it means that nf_conntrack_put doesn't kill the conntrack as I
thought. I still can't understand how the nfct from skb works. What is
that "use" value that makes nf_conntrack_put() call
nf_conntrack_destroy() when it equals zero?
Well, I suppose it's not that important for me. At least I have my
answer, thank you :)

--
nimai

On Thu, Mar 21, 2013 at 2:53 AM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> Hi Nicolas,
>
> On Thu, Mar 21, 2013 at 01:57:33AM +0100, Nicolas Ma=C3=AEtre wrote:
>> Hi,
>>
>> I've developed a connection tracking module which I'd like to use fo=
r
>> detecting packets that may be dropped with an iptables rule.
>> That is, the connection tracker can detect that a packet is not  val=
id
>> in the context of the tracked connection. So, I'd like the
>> administrator to be able to add a rule that would allow to drop/reje=
ct
>> that packet.
>> A possible use case is to block packets from an attacker (assumed as
>> such as the packet is not conform considering the current state of t=
he
>> connection).
>>
>> As far as I understand it, the connection tracker usually handle thi=
s
>> by returning a negative/null value (-NF_ACCEPT, NF_DROP, ...) which
>> marks the packet invalid, so that it is possible to use the
>> xt_conntrack extension to match it.
>>
>> I've looked at the TCP connection tracker. If I understand well, the
>> current behavior is that if we've got an INVALID packet, it kills th=
e
>> conntrack, then create it again if we see an ACK later on. Am I righ=
t?
>
> Packets that are invalid do not destroy the conntrack entry. The TCP
> tracker explicitly destroys the entry by calling nf_ct_kill function
> in some situations (RST seen / tracking is out-of-sync).
>



--=20
Nicolas
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
