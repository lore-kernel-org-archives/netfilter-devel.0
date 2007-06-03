From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 1/2] xt_u32 (kernel) - match arbitrary bits and bytes of
 a packet
Date: Sun, 3 Jun 2007 22:09:53 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706031929450.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706022346490.10578@yvahk01.tjqt.qr>
	<4662F908.4090401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4662F908.4090401@trash.net>
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


On Jun 3 2007 19:23, Patrick McHardy wrote:
>
>Jan Engelhardt wrote:
>>     *	added ipv6 support since that seemed dead simple, given u32's
>> 	task. I would have even liked to unlock u32 for _all_ protocols,
>> 	but .family = AF_UNSPEC does not do the right thing right now,  
>> 	but that's not so much a showstopper.
>> 
>> 	And arptables seems miles away from using iptables modules. So
>> 	AF_INET and AF_INET6 it is for now.
>
>arp_tables doesn't support matches at all.

Oh well, so much for that idea.

>> 
>>     *	Reduced the buffer size to 17 KB. I think that is quite ok since
>> 	I added an overflow check,  SHOULD THERE BE ANY device with an  
>> 	MTU larger than our loopback masterpiece (16436 bytes).
>> 
>> 	Are there such devices that support Megasuperjumboframes?
>> 	The previous buffer size of 64 KB was probably the cutting edge,
>> 	as a single IPv4 fragment/packet does not support more than that
>> 	anyway.
>
>Think of TSO.

Right, next version already uses kmalloc.

>> +	uint32_t min, max;
>
>We use u_int32_t in all netfilter files. Also
>
>	u_int32_t min;
>	u_int32_t max;
>
>please (and everywhere else of course).

Is this a showstopper? After all, uint32_t is close to the same-named 
C99 type. It's kinda strange to have __u32, u32, u_int32_t and uint32_t 
for one and the same thing.

>> +	  Details and examples are in the kernel module source.
>
>Details and examples belong in the manpage.

I agree.

>> +static char xt_u32_buffer[17*1024];
>64k and please allocate this.

Yup.

>> +	if (head == NULL) {
>> +		*hotdrop = 1;
>> +		return false;
>> +	}
>
>might as well BUG_ON since a copy of size <= skb->len cant fail.

Hmm, scripts/checkpatch.pl barfs on BUG_ONs :-)
Use WARN_ON + hotdrop, or still go with BUG_ON?

>> +	base = head;
>> +	for (testind = 0; testind < data->ntests; ++testind) {
>> +		ct = &data->tests[testind];
>> +
>> +		at  = 0;
>> +		pos = ct->location[0].number;
>> +		if (at + pos + 3 > skb->len || at + pos < 0) {
>> +			spin_unlock_bh(&xt_u32_lock);
>> +			return false;
>
>what about inversion?

If it was not supported before, I have not implemented it.

>Matches return int, so please use 0/1
>(or send me a patch to convert all of them to boolean first).

Alright!



Thanks,
	Jan
-- 
