From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_u32 20070605 (kernel)
Date: Tue, 5 Jun 2007 13:56:53 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051352540.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706051311220.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051312370.20829@yvahk01.tjqt.qr>
	<46654BB0.4060201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46654BB0.4060201@trash.net>
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

Hi,


On Jun 5 2007 13:40, Patrick McHardy wrote:
>Mosty fine, but:
>
>> +struct xt_u32_location_element {
>> +	uint32_t number;
>> +	uint8_t nextop;
>> +};
>
>u_intXX_t

Ick, forget to go through the .h file.

>> +static DEFINE_SPINLOCK(xt_u32_lock);
>> +static unsigned int xt_u32_buffer_size = 64 * 1024;
>
>#define maybe

Hm, I don't know... I'd leave it so that memory constrained systems can
specify their own MTU without recompiling.

>> +static bool xt_u32_match_it(const struct xt_u32 *data,
>> +			    const struct sk_buff *skb)
>> +{
>> +		if (at + pos + 3 > skb->len || at + pos < 0)
>> +			return false;
>
>inversion?

Done in xt_u32_match() [below]

>> +static bool xt_u32_match(const struct sk_buff *skb,
>> +			 const struct net_device *in,
>> +			 const struct net_device *out,
>> +			 const struct xt_match *match, const void *matchinfo,
>> +			 int offset, unsigned int protoff, bool *hotdrop)
>> +{
>> +	const struct xt_u32 *data = matchinfo;
>> +	bool ret;
>> +
>> +	spin_lock_bh(&xt_u32_lock);
>> +	ret = xt_u32_match_it(data, skb);
>
>Do we really need this wrapper?

I thought "yes". Otherwise, I'd need a spin_unlock_bh at every return in
xt_u32_match_it(), and also would need to fiddle data->invert too.
With two functions (_match and _match_it), this is done nicely IMHO.

>> +module_init(xt_u32_init);
>> +module_exit(xt_u32_exit);
>> +module_param_named(buffer_size, xt_u32_buffer_size, uint, S_IRUGO);
>> +MODULE_PARM_DESC(buffer_size, "Buffer size to hold a packet "
>> +	"(default: 65536 bytes)");
>
>No parameter for this. We need 64k.

If no interface in a system has an MTU >17k (to be determined by
the system's owner), why need 64?



Thanks,
	Jan
-- 
