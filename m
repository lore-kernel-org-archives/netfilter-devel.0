From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Wed, 07 Jul 2004 01:33:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40EB36BE.5090109@trash.net>
References: <200406240404.NAA01264@toshiba.co.jp> <40DABA52.9070700@trash.net> <19040125165321.GA4640@obroa-skai.de.gnumonks.org> <40EA7CE7.2000502@trash.net> <40EB2ECB.4090404@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
  netfilter-devel@lists.netfilter.org,  kisza@securityaudit.hu,
 usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40EB2ECB.4090404@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:
> Hi Patrick,
> 
> Patrick McHardy wrote:
> 
>> skb_copy_bits is taking about twice as much cycles as tcp_match
>> and 20% of total cycles.
> 
> AFAIK we are using skb_copy_bits because it walks through fragment list 
> in a safe way, I read an old thread (Harald and DaveM discussion) about 
> this. If I'm not wrong, that's why this was the method selected when 
> conntrack started handling fragments in 2.6 in a different way.

skb_copy_bits does three things: it copies memory from the linear part
between skb->head and skb->tail, it copies memory from the paged part
in skb->frags[], and it walks skb->frag_list for defragmented packets.

> 
> Well, I wonder if we could check if current skb is fragmented (something 
> like skb->data_len!=0), in that case use skb_copy_bits, if not walk 
> through skb payload directly as we use to do in 2.4 and save that memcpy.

I don't think we should do that, the number of copies would still be
dependant on the ruleset. I see two possibilities: We could linearize
the transport protocol headers or we could copy it to skb->cb.

Linearizing has three cases:
- data is already linear: nothing to do
- parts of data are in paged part in skb->frags[]: append data of frags
   to skb->end until we have enough
- parts of data are in frag_list: walk frag_list until enough linear
   data is in first skb, copy linear data, handle paged data like
   described above

I don't know if this turns out to be much more efficient than the old
call to skb_linearize. Copying to skb->cb is simpler, but the frequent
case of already linear data is handled less efficient than with
linearizing.

Regards
Patrick
