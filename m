From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Mon, 28 Jun 2004 22:31:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40E08034.8040301@trash.net>
References: <200406240404.NAA01264@toshiba.co.jp> <40DABA52.9070700@trash.net> <19040125165321.GA4640@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
 netfilter-devel@lists.netfilter.org,  kisza@securityaudit.hu,
 usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <19040125165321.GA4640@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Thu, Jun 24, 2004 at 01:26:10PM +0200, Patrick McHardy wrote:
> 
>>One call to skb_linearize would most likely be less expensive. I'm
>>thinking about putting the copied protocol header in the control
>>buffer, this would reduce this extensive copying a lot. We could also
>>do some common preprocessing steps in one place, like converting
>>things to host byte order.
> 
> 
> yes, it would be only one copy... but to real memory..
> Maybe we need some benchmarking on this.

It may be only to cache, but in case the skb is non-linear skb_copy_bits
calls local_bh_disable and kmap_atomic for the paged part, and walks
frag_list. I don't expect skb_ip_make_writable to be much faster in
all cases, but a new function which would only linearize the transport
headers, without copying the entire skb, probably would be.
Unfortunately I don't have time to implement and benchmark it right now.

>>Regards
>>Patrick
> 
> 
