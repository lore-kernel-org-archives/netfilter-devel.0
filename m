From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TARPIT
Date: Mon, 30 Jul 2007 15:35:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707301532380.26373@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707181309510.27468@fbirervta.pbzchgretzou.qr>
	<469E0FD5.9060309@trash.net>
	<Pine.LNX.4.64.0707181659260.19782@blackhole.kfki.hu>
	<200707190038.l6J0c3pR002571@toshiba.co.jp>
	<469EB401.8000700@trash.net>
	<Pine.LNX.4.64.0707190846470.20544@blackhole.kfki.hu>
	<Pine.LNX.4.64.0707291608550.9488@fbirervta.pbzchgretzou.qr>
	<46ADD84C.2070202@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Sami Farin <safari-netfilter@safari.iki.fi>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46ADD84C.2070202@trash.net>
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


On Jul 30 2007 14:23, Patrick McHardy wrote:
>
>>>>+static bool xt_tarpit_check(const char *tablename, const void *entry,
>>>>+                            const struct xt_target *target, void *targinfo,
>>>>+                            unsigned int hook_mask)
>>>>+{
>>>>+	bool invalid;
>>>>+
>>>>+	if (strcmp(tablename, "raw") == 0 && hook_mask == NF_IP_PRE_ROUTING)
>>>>+		return true;
>>>>+	if (strcmp(tablename, "filter") != 0)
>>>>+		return false;
>>>>+	invalid = hook_mask & ~((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD));
>>>
>>>Use generic validation please. This logic also looks overly complicated.
>> 
>> 
>> I suppose you mean
>> 
>> 	.table = "filter"
>> 
>> with "generic validation". I cannot use that, because it can be used in
>> two tables. [ See below ]
>
>The origin version was simply restricted to some hooks. Why
>does the table matter?

The original version limited it to filter-INPUT and filter-FORWARD.
But if raw-PREROUTING was to be added, the generic validation
things cannot be used, because two tables cannot be represented with it.
Anyway, since you say no to implicit notracking, the issue is gone.


	Jan
-- 
