From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: xt_TARPIT
Date: Thu, 19 Jul 2007 10:09:07 +0900 (JST)
Message-ID: <200707190109.l6J198tp021997@toshiba.co.jp>
References: <Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
	<200707190038.l6J0c3pR002571@toshiba.co.jp>
	<469EB401.8000700@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org,
	safari-netfilter@safari.iki.fi, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469EB401.8000700@trash.net>
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

From: Patrick McHardy <kaber@trash.net>

> > I'm not sure that we should make TARPIT usable in raw table, but anyway
> > why the fake untrack entry is necessary ? I think that the created packet
> > is better to pass through LOCAL_OUT hook so that nf_conntrack can attach an
> > appropriate entry. That is what REJECT does.
> >   
> 
> 
> I think both cases are valid. The restriction of REJECT to filter
> (and that means INPUT FORWARD OUTPUT) has only one technical justification,
> the packet is guaranteed to have a dst_entry, which is used for some
> simple checks that could also be done otherwise. In raw the original
> packet can't have been NATed, so a valid conntrack reference is not
> necessary to NAT the reply. Other than that I can think of no real
> reason why REJECT or TARPIT packets must have a conntrack refererence.
>
> I don't really like adding a notrack reference in the TARPIT target
> though, I would prefer to use the one from the original packet (as in
> REJECT) and for NOTRACK you would simply mark the original packet.

You're right. Yes, nf_ct_attach is also necessary. I need caffeine.

-- Yasuyuki Kozakai
