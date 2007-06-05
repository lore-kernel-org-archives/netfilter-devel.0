From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] xt_u32 (kernel) - match arbitrary bits and bytes
 of a packet
Date: Tue, 05 Jun 2007 13:34:08 +0200
Message-ID: <46654A30.4080309@trash.net>
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706022346490.10578@yvahk01.tjqt.qr>
	<4662F908.4090401@trash.net>
	<Pine.LNX.4.61.0706050901210.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706050901210.20829@yvahk01.tjqt.qr>
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
>>>+	spin_lock_bh(&xt_u32_lock);
>>>+
>>>+	head = skb_header_pointer(skb, 0, min(skb->len,
>>>+	       sizeof(xt_u32_buffer)), xt_u32_buffer);
> 
> 
> I'd like to hear opinions about:
> 
>  * open coding skb_header_pointer
> 
>    In the "hlen - offset >= len" case in skb_header_pointer(), it just
>    returns a pointer to the existing skb without copying, in which
>    case we would not need to take a lock at all.


No special-case solutions please, this affects many netfilter modules
and we want this for all or none.

>  * use percpu buffers, with or without opencoding skb_header_pointer
>    so that cpus/threads do not have to wait for another -m u32 to finish.


Not worth the (potentially enormous) memory waste I guess.
