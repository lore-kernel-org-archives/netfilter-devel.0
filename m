From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Wed, 07 Jul 2004 00:59:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40EB2ECB.4090404@eurodev.net>
References: <200406240404.NAA01264@toshiba.co.jp> <40DABA52.9070700@trash.net> <19040125165321.GA4640@obroa-skai.de.gnumonks.org> <40EA7CE7.2000502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
  netfilter-devel@lists.netfilter.org,  kisza@securityaudit.hu,
 usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40EA7CE7.2000502@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Patrick McHardy wrote:

> skb_copy_bits is taking about twice as much cycles as tcp_match
> and 20% of total cycles.


AFAIK we are using skb_copy_bits because it walks through fragment list 
in a safe way, I read an old thread (Harald and DaveM discussion) about 
this. If I'm not wrong, that's why this was the method selected when 
conntrack started handling fragments in 2.6 in a different way.

Well, I wonder if we could check if current skb is fragmented (something 
like skb->data_len!=0), in that case use skb_copy_bits, if not walk 
through skb payload directly as we use to do in 2.4 and save that memcpy.

regards,
Pablo
