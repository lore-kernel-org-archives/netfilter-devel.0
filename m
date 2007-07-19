From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TARPIT
Date: Thu, 19 Jul 2007 02:44:49 +0200
Message-ID: <469EB401.8000700@trash.net>
References: <Pine.LNX.4.64.0707181309510.27468@fbirervta.pbzchgretzou.qr>	<469E0FD5.9060309@trash.net>	<Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
	<200707190038.l6J0c3pR002571@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org,
	safari-netfilter@safari.iki.fi, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707190038.l6J0c3pR002571@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date: Wed, 18 Jul 2007 17:02:45 +0200 (CEST)
>
>   
>> If the target is called from the raw table, please attach the fake untrack 
>> entry to the created packet so that we could use TARPIT and conntrack 
>> nicely.
>>     
>
> I'm not sure that we should make TARPIT usable in raw table, but anyway
> why the fake untrack entry is necessary ? I think that the created packet
> is better to pass through LOCAL_OUT hook so that nf_conntrack can attach an
> appropriate entry. That is what REJECT does.
>   


I think both cases are valid. The restriction of REJECT to filter
(and that means INPUT FORWARD OUTPUT) has only one technical justification,
the packet is guaranteed to have a dst_entry, which is used for some
simple checks that could also be done otherwise. In raw the original
packet can't have been NATed, so a valid conntrack reference is not
necessary to NAT the reply. Other than that I can think of no real
reason why REJECT or TARPIT packets must have a conntrack refererence.

I don't really like adding a notrack reference in the TARPIT target
though, I would prefer to use the one from the original packet (as in
REJECT) and for NOTRACK you would simply mark the original packet.
