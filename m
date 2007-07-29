From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TARPIT
Date: Sun, 29 Jul 2007 16:44:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707291608550.9488@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707181309510.27468@fbirervta.pbzchgretzou.qr>
	<469E0FD5.9060309@trash.net>
	<Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
	<200707190038.l6J0c3pR002571@toshiba.co.jp>
	<469EB401.8000700@trash.net>
	<Pine.LNX.4.64.0707190846470.20544@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Sami Farin <safari-netfilter@safari.iki.fi>
To: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707190846470.20544@blackhole.kfki.hu>
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



On Jul 18 2007 15:04, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> +EXPORT_SYMBOL(secure_tcp_sequence_number);
>
>Seems unnecessary, we don't really care whether the sequence number is
>secure or not.

Will tcp->seq = 0 do?

>> +	/* Truncate to length (no data) */
>> +	ntcph->doff = sizeof(struct tcphdr)/4;
>> +	skb_trim(nskb, ip_hdrlen(nskb) + sizeof(struct tcphdr));
>> +	niph->tot_len = htons(nskb->len);
>> +
>> +	/* Swap source and dest */
>> +	niph->daddr = xchg(&niph->saddr, niph->daddr);

BTW, how come ipt_REJECT does not use xchg()?

>> +	/* Do we have an input route cache entry? */
>> +	if (rt == NULL)
>> +		return NF_DROP;
>
>DROP? Is that reasonable? How about restricting to != PREROUTING?

Yes, that is indeed better.

>> +static bool xt_tarpit_check(const char *tablename, const void *entry,
>> +                            const struct xt_target *target, void *targinfo,
>> +                            unsigned int hook_mask)
>> +{
>> +	bool invalid;
>> +
>> +	if (strcmp(tablename, "raw") == 0 && hook_mask == NF_IP_PRE_ROUTING)
>> +		return true;
>> +	if (strcmp(tablename, "filter") != 0)
>> +		return false;
>> +	invalid = hook_mask & ~((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD));
>
>Use generic validation please. This logic also looks overly complicated.

I suppose you mean

	.table = "filter"

with "generic validation". I cannot use that, because it can be used in
two tables. [ See below ]



On Jul 18 2007 17:02, Jozsef Kadlecsik wrote:
> On Wed, 18 Jul 2007, Patrick McHardy wrote:
>
>> > +	/* This packet will not be the same as the other: clear nf fields */
>> > +	nf_conntrack_put(nskb->nfct);
>> > +	nskb->nfct = NULL;
>
> If the target is called from the raw table, please attach the fake untrack
> entry to the created packet so that we could use TARPIT and conntrack nicely.

Indeed. Unfortunately, since I do not see a way to get the table name
in the xt_tarpit_target() function, I need to store a flag in a custom
struct xt_tarpit_state or so. Not a problem, but the ->targetsize
stuff needs to be done right. (If anyone could kindly look at it :))



On Jul 19 2007 09:38, Yasuyuki KOZAKAI wrote:
>Josef wrote:
>> If the target is called from the raw table, please attach the fake untrack 
>> entry to the created packet so that we could use TARPIT and conntrack 
>> nicely.
>
>I'm not sure that we should make TARPIT usable in raw table, but anyway
>why the fake untrack entry is necessary ? I think that the created packet
>is better to pass through LOCAL_OUT hook so that nf_conntrack can attach an
>appropriate entry. That is what REJECT does.

The original TARPIT advertised that TARPIT is cheap -- when connection
tracking is not used. With a notrack entry, we can live up to that even
when connection tracking is loaded.



On Jul 19 2007 02:44, Patrick McHardy wrote:
> Yasuyuki KOZAKAI wrote:
>> I'm not sure that we should make TARPIT usable in raw table, but anyway
>> why the fake untrack entry is necessary ? I think that the created packet
>> is better to pass through LOCAL_OUT hook so that nf_conntrack can attach an
>> appropriate entry. That is what REJECT does.
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


On Jul 19 2007 10:09, Yasuyuki KOZAKAI wrote:
>From: Patrick McHardy <kaber@trash.net>
>> I don't really like adding a notrack reference in the TARPIT target
>> though, I would prefer to use the one from the original packet (as in
>> REJECT) and for NOTRACK you would simply mark the original packet.
>
>You're right. Yes, nf_ct_attach is also necessary. I need caffeine.

So what's the final verdict? If TARPIT shall not imply NOTRACK,
then of course I will remove the checks for "raw", etc. Please vote.

But IMO, it is easier to just TARPIT a connection and imply NOTRACK
instead of trying to MARK and NOTRACK separately.

(And additionally, TARPIT should also attach the notrack ct to the _original_
direction, not only the reply.)




	Jan
-- 
