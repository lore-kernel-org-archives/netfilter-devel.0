From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070620_2
Date: Fri, 22 Jun 2007 13:43:26 +0200
Message-ID: <467BB5DE.8010609@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706221331530.26568@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Andrew Beverley <andy@andybev.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706221331530.26568@fbirervta.pbzchgretzou.qr>
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
> On Jun 22 2007 13:14, Patrick McHardy wrote:
> 
>>>+		    memcmp(&conn->tuple, &tuple, sizeof(tuple)) == 0 &&
>>>+		    found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT)
>>
>>
>>It should support other protocols as well.
> 
> 
> It does support UDP and UDPLITE.


I didn't realize that. Still, why doesn't it support all protocols?

>>Also nothing guarantees that you're looking at a TCP connection here.
> 
> 
> True that. What is the SCTP state (include/linux/netfilter/nf_conntrack_tcp.h)
> I am looking for? (And DCCP does not seem to have states.)


SCTP states are defined in the .c file itself I think.

>>>+	rv = info->inverse ^ (connections > info->limit);
>>
>>Switching the two expressions seems more logical.
> 
> 
> Like...?
> 	ret = connections > info->limit;
> 	ret ^= info->inverse


Or just "(connections > info->limit) ^ info->inverse".


>>>+#if DEBUG
>>>+	printk(KERN_DEBUG "xt_connlimit: src=%u.%u.%u.%u mask=%u.%u.%u.%u "
>>>+	       "connections=%d limit=%u match=%s\n",
>>>+	       NIPQUAD(iph->saddr), NIPQUAD(info->mask),
>>>+	       connections, info->limit, match ? "yes" : "no");
>>
>>Excessive debugging, also shouldn't use ifdef but pr_debug if
>>absolutely necessary.
> 
> 
> Should it go or not?


I certainly don't need it. If there's a bug I prefer to think about
the code instead of recompiling with debugging and getting lots
of spam in my logs. I also have the suspicion that too much debugging
statements cause more bugs because the code gets harder to read.

> 
> 
>>>+static bool connlimit_check(const char *tablename, const void *ip,
>>>+			    const struct xt_match *match, void *matchinfo,
>>>+			    unsigned int hook_mask)
>>>+{
>>>+	struct xt_connlimit_info *info = matchinfo;
>>>+	unsigned int i;
>>>+
>>>+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
>>>+		printk(KERN_WARNING "cannot load conntrack support for "
>>>+		       "address family %u\n", match->family);
>>>+		return false;
>>>+	}
>>>+
>>>+	/* init private data */
>>>+	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
>>
>>This will make it forget its state everytime you add or delete _any_
>>rule.
> 
> 
> Sorry, what state?
> Each rule keeps its own list of known connections, yes :-/


Thats the state. It will forget them every time you change _anything_
in the ruleset. On second though, I guess it doesn't matter because
the state can be entirely reconstructed at runtime?
