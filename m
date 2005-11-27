From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] [PATCH] nf_conntrack_netlink port take#2
Date: Sun, 27 Nov 2005 16:12:23 +0100
Message-ID: <4389CCD7.2090503@trash.net>
References: <43836FFE.3020504@eurodev.net>	<200511250500.jAP50YL2008800@toshiba.co.jp>
	<200511270708.jAR78snC018182@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <200511270708.jAR78snC018182@toshiba.co.jp>
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

>>+static int icmp_tuple_to_nfattr(struct sk_buff *skb,
>>+				const struct nf_conntrack_tuple *t)
>>+{
>>+	NFA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
>>+		&t->src.u.icmp.id);
>>+	NFA_PUT(skb, CTA_PROTO_ICMP_TYPE, sizeof(u_int8_t),
>>+		&t->dst.u.icmp.type);
>>+	NFA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
>>+		&t->dst.u.icmp.code);
>>+
>>+	if (t->dst.u.icmp.type >= sizeof(valid_new) 
>>+	    || !valid_new[t->dst.u.icmp.type])
>>+		return -EINVAL;
> 
> 
> [both] Why this check isn't done before putting attributes ?

Why is this check done at all? We're just dumping the tuples
the kernel has already created and validated.

>>-void nf_conntrack_cleanup(void)
>>+void nf_conntrack_flush()
>> {
>>-	int i;
>>-
>> 	/* This makes sure all current packets have passed through
>> 	   netfilter framework.  Roll on, two-stage module
>> 	   delete... */
>>@@ -1383,6 +1550,18 @@ void nf_conntrack_cleanup(void)
>> 		schedule();
>> 		goto i_see_dead_people;
>> 	}
>>+	/* wait until all references to ip_conntrack_untracked are dropped */
>>+	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
>>+		schedule();
>>+}
> 
> 
> [nfct] nice catch! I think this would better to be applied to mainline ASAP.
> Could you re-send this in other patch ?

I agree to the fix, but disagree about abusing this function for
ctnetlink. ctnetlink doesn't care about references and doesn't
need to wait for untracked conntracks, it just needs to clean
the table. I have a patch here for ctnetlink that replaces the
use of this function by ip_ct_iterate_cleanup, which significantly
speeds up flushing the table on a busy (conntrack-wise) system.

>>static inline int
>>ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
>>{
>>	struct nfattr *nest_helper;
>>
>>	if (!ct->helper)
>>		return 0;
>>		
>>	nest_helper = NFA_NEST(skb, CTA_HELP);
>>	NFA_PUT(skb, CTA_HELP_NAME, CTA_HELP_MAXNAMESIZE, &ct->helper->name);
> 
> 
> [both] Oh, &ct->helper->name doesn't point intended area. Because
> ct->helper->name isn't declared as array.
> 
> [both] And its size may be less than CTA_HELP_MAXNAMESIZE.

And also larger. I don't think we need to limit the length at all, but
we should make sure to stop at the trailing \0 byte.
