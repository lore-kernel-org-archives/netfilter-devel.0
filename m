From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] xt_u32 (kernel) - match arbitrary bits and bytes
 of a packet
Date: Mon, 04 Jun 2007 13:25:55 +0200
Message-ID: <4663F6C3.9070100@trash.net>
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706022346490.10578@yvahk01.tjqt.qr>
	<4662F908.4090401@trash.net>
	<Pine.LNX.4.61.0706031929450.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706031929450.10578@yvahk01.tjqt.qr>
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
> On Jun 3 2007 19:23, Patrick McHardy wrote:
> 
>>>+	uint32_t min, max;
>>
>>We use u_int32_t in all netfilter files. Also
>>
> 
> Is this a showstopper? After all, uint32_t is close to the same-named 
> C99 type. It's kinda strange to have __u32, u32, u_int32_t and uint32_t 
> for one and the same thing.


We try to keep things consistent at least along subsystems, so yes,
I won't apply a patch that adds to the inconsistency.

>>>+	if (head == NULL) {
>>>+		*hotdrop = 1;
>>>+		return false;
>>>+	}
>>
>>might as well BUG_ON since a copy of size <= skb->len cant fail.
> 
> 
> Hmm, scripts/checkpatch.pl barfs on BUG_ONs :-)
> Use WARN_ON + hotdrop, or still go with BUG_ON?


BUG_ON please, this is what we use for all other impossible
skb_copy_bits failures.

>>>+	base = head;
>>>+	for (testind = 0; testind < data->ntests; ++testind) {
>>>+		ct = &data->tests[testind];
>>>+
>>>+		at  = 0;
>>>+		pos = ct->location[0].number;
>>>+		if (at + pos + 3 > skb->len || at + pos < 0) {
>>>+			spin_unlock_bh(&xt_u32_lock);
>>>+			return false;
>>
>>what about inversion?
> 
> 
> If it was not supported before, I have not implemented it.


We don't add new matches without inversion anymore, so please add
support for it.
