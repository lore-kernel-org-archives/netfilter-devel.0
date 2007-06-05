From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_u32 20070605 (kernel)
Date: Tue, 05 Jun 2007 13:59:26 +0200
Message-ID: <4665501E.3080203@trash.net>
References: <Pine.LNX.4.61.0706051311220.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051312370.20829@yvahk01.tjqt.qr>
	<46654BB0.4060201@trash.net>
	<Pine.LNX.4.61.0706051352540.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051352540.20829@yvahk01.tjqt.qr>
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
>>>+static bool xt_u32_match(const struct sk_buff *skb,
>>>+			 const struct net_device *in,
>>>+			 const struct net_device *out,
>>>+			 const struct xt_match *match, const void *matchinfo,
>>>+			 int offset, unsigned int protoff, bool *hotdrop)
>>>+{
>>>+	const struct xt_u32 *data = matchinfo;
>>>+	bool ret;
>>>+
>>>+	spin_lock_bh(&xt_u32_lock);
>>>+	ret = xt_u32_match_it(data, skb);
>>
>>Do we really need this wrapper?
> 
> 
> I thought "yes". Otherwise, I'd need a spin_unlock_bh at every return in
> xt_u32_match_it(), and also would need to fiddle data->invert too.
> With two functions (_match and _match_it), this is done nicely IMHO.

OK.

>>>+MODULE_PARM_DESC(buffer_size, "Buffer size to hold a packet "
>>>+	"(default: 65536 bytes)");
>>
>>No parameter for this. We need 64k.
> 
> 
> If no interface in a system has an MTU >17k (to be determined by
> the system's owner), why need 64?


Again, TSO. Long-term we want to move away from packet copying, so
I don't want to add any module parameters for this.
