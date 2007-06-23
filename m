From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Follow packets in rules
Date: Sat, 23 Jun 2007 18:45:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706231843350.22171@blackhole.kfki.hu>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca> <467020F6.2050906@trash.net>
	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
	<46713EE8.6060906@trash.net>
	<Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>
	<46714F7D.4010309@trash.net>
	<Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>
	<467BDA90.7090802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467BDA90.7090802@trash.net>
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

On Fri, 22 Jun 2007, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
>> Attached you can find the reworked TRACE target, which does not suffer
>> from backward incompatibility. Unfortunately I had to steal one unused
>> bit from skbuff to be able to mark the packets so that it surely does
>> not clash with any rules using the standard "MARK" target. Logging
>> level, flags and type are hardcoded. What do you think?
>
> Could you send me a Signed-off-by: line so I can queue this for 2.6.23?

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

>> +static inline void trace_packet(struct sk_buff *skb,
>> +				unsigned int hook,
>> +				const struct net_device *in,
>> +				const struct net_device *out,
>> +				char *tablename,
>> +				struct xt_table_info *private,
>> +				struct ipt_entry *e)
>
>
> I'm going to remove the inline here ..

Yes, that's better.

>
>>  /* Returns one of the generic firewall policies, like NF_ACCEPT. */
>>  unsigned int
>>  ipt_do_table(struct sk_buff **pskb,
>> @@ -267,6 +371,12 @@
>>
>>  			t = ipt_get_target(e);
>>  			IP_NF_ASSERT(t->u.kernel.target);
>> +
>> +			/* The packet is traced: log it */
>> +			if ((*pskb)->nf_trace)
>> +				trace_packet(*pskb, hook, in, out,
>> +					     table->name, private, e);
>> +
>
> and mark this unlikely so we don't bloat the main loop of ipt_do_table.

OK, fine and thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
