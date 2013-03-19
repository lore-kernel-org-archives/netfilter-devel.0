From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 15:34:56 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr>
References: <20130319141442.150005875@eitzenberger.org> <20130319141605.158831637@eitzenberger.org> <20130319.102620.2063759629502166169.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: holger@eitzenberger.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:59472 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab3CSOe6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:34:58 -0400
In-Reply-To: <20130319.102620.2063759629502166169.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-03-19 15:26, David Miller wrote:
>
>> +			if (par->family == NFPROTO_IPV4)
>> +				queue = (((u64) hash_v4(skb) * info->queues_total) >>
>> +						 32) + queue;
>> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>> +			else if (par->family == NFPROTO_IPV6)
>> +				queue = (((u64) hash_v6(skb) * info->queues_total) >>
>> +						 32) + queue;
>> +#endif
>
>Maybe add a helper function so you don't have to indent so deeply.  Something
>like:

And combined with smart arranging of clauses, won't need an extra 
helper function.
http://www.braceless.org/Various/The%20Else%20Statement%20Considered%20Harmful

Something like

+static unsigned int
+nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_NFQ_info_v3 *info = par->targinfo;
+	u32 queue = info->queuenum;
+
+	if (info->queues_total == 1)
+		return NF_QUEUE_NR(queue);
+	if (info->flags & NFQ_FLAG_CPU_FANOUT) {
+		int cpu = smp_processor_id();
+
+		queue = info->queuenum + cpu % info->queues_total;
+	} else if (par->family == NFPROTO_IPV4) {
+		queue = (((u64) hash_v4(skb) * info->queues_total) >>
+				 32) + queue;
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	} else if (par->family == NFPROTO_IPV6) {
+		queue = (((u64) hash_v6(skb) * info->queues_total) >>
+				 32) + queue;
+	}
+#endif
+	return NF_QUEUE_NR(queue);
+}
