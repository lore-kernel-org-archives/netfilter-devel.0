From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Sun, 01 Aug 2004 19:08:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <410D23AB.2070203@trash.net>
References: <200406250457.NAA07080@toshiba.co.jp> <Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu> <20040721213653.GR27487@obroa-skai.de.gnumonks.org> <200407290609.PAA13928@toshiba.co.jp> <20040801164653.GA10656@sunbeam2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	kadlec@blackhole.kfki.hu, netfilter-devel@lists.netfilter.org,
	kisza@securityaudit.hu, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040801164653.GA10656@sunbeam2>
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

>On Thu, Jul 29, 2004 at 03:09:02PM +0900, Yasuyuki Kozakai wrote:
>  
>
>>I got time to implement your idea. How about this ? (not tested)
>>
>>	struct tcphdr hdr;
>>	struct tcphdr *tcph
>>
>>	tcph = skb_get_bits(skb, &hdr, skb->nh.iph->ihl*4, sizeof(hdr));
>>
>>If skb is neither shared nor cloned, this function linearize up to tcp header
>>and returns the pointer to tcp header in skb.
>>
>>Otherwise, copies tcp header to "hdr" and return the pointer to it.
>>If error, return NULL.
>>    
>>
>
>This sounds like a very sane approach to me.  
>
>Since we don't have stable API's in 2.6.x anymore (kernel summit
>decision), we could even put this in our pending queue of patches for
>something like 2.6.10/2.6.11
>
>What does eveybody else think?  Comments?
>  
>
The number of copies will still depend on the ruleset with non-linear skbs.
skb_linearize_partial sounds like a much better idea to me.

Regards
Patrick
