From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TARPIT
Date: Mon, 30 Jul 2007 14:23:40 +0200
Message-ID: <46ADD84C.2070202@trash.net>
References: <Pine.LNX.4.64.0707181309510.27468@fbirervta.pbzchgretzou.qr>
	<469E0FD5.9060309@trash.net>
	<Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
	<200707190038.l6J0c3pR002571@toshiba.co.jp>
	<469EB401.8000700@trash.net>
	<Pine.LNX.4.64.0707190846470.20544@blackhole.kfki.hu>
	<Pine.LNX.4.64.0707291608550.9488@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Sami Farin <safari-netfilter@safari.iki.fi>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707291608550.9488@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> 
> On Jul 18 2007 15:04, Patrick McHardy wrote:
> 
>>Jan Engelhardt wrote:
>>
>>>+EXPORT_SYMBOL(secure_tcp_sequence_number);
>>
>>Seems unnecessary, we don't really care whether the sequence number is
>>secure or not.
> 
> 
> Will tcp->seq = 0 do?


I don't know.

>>>+	/* Truncate to length (no data) */
>>>+	ntcph->doff = sizeof(struct tcphdr)/4;
>>>+	skb_trim(nskb, ip_hdrlen(nskb) + sizeof(struct tcphdr));
>>>+	niph->tot_len = htons(nskb->len);
>>>+
>>>+	/* Swap source and dest */
>>>+	niph->daddr = xchg(&niph->saddr, niph->daddr);
> 
> 
> BTW, how come ipt_REJECT does not use xchg()?


Because its not necessary, as in this case.

>>>+static bool xt_tarpit_check(const char *tablename, const void *entry,
>>>+                            const struct xt_target *target, void *targinfo,
>>>+                            unsigned int hook_mask)
>>>+{
>>>+	bool invalid;
>>>+
>>>+	if (strcmp(tablename, "raw") == 0 && hook_mask == NF_IP_PRE_ROUTING)
>>>+		return true;
>>>+	if (strcmp(tablename, "filter") != 0)
>>>+		return false;
>>>+	invalid = hook_mask & ~((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD));
>>
>>Use generic validation please. This logic also looks overly complicated.
> 
> 
> I suppose you mean
> 
> 	.table = "filter"
> 
> with "generic validation". I cannot use that, because it can be used in
> two tables. [ See below ]


The origin version was simply restricted to some hooks. Why
does the table matter?

>>>I don't really like adding a notrack reference in the TARPIT target
>>>though, I would prefer to use the one from the original packet (as in
>>>REJECT) and for NOTRACK you would simply mark the original packet.
>>
>>You're right. Yes, nf_ct_attach is also necessary. I need caffeine.
> 
> 
> So what's the final verdict? If TARPIT shall not imply NOTRACK,
> then of course I will remove the checks for "raw", etc. Please vote.


I think I already did :)
