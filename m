From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 1/2] xt_u32 (kernel) - match arbitrary bits and bytes of
 a packet
Date: Tue, 5 Jun 2007 09:07:23 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706050901210.20829@yvahk01.tjqt.qr>
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

Hi,

On Jun 3 2007 19:23, Patrick McHardy wrote:
>Also
>
>	u_int32_t min;
>	u_int32_t max;
>
>please (and everywhere else of course).

Might get a bit verbose.

Question:
ipt_u32/xt_u32 uses a spinlock_bh to protect the buffer to which a packet
is copied to before analyzing.

>> +	spin_lock_bh(&xt_u32_lock);
>> +
>> +	head = skb_header_pointer(skb, 0, min(skb->len,
>> +	       sizeof(xt_u32_buffer)), xt_u32_buffer);

I'd like to hear opinions about:

 * open coding skb_header_pointer

   In the "hlen - offset >= len" case in skb_header_pointer(), it just
   returns a pointer to the existing skb without copying, in which
   case we would not need to take a lock at all.

 * use percpu buffers, with or without opencoding skb_header_pointer
   so that cpus/threads do not have to wait for another -m u32 to finish.


	Jan
-- 
