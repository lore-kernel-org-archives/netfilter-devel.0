From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: prearation of removing skb_linearize()
Date: Tue, 21 Sep 2004 21:40:40 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409211240.i8LCef7b015885@toshiba.co.jp>
References: <200409160318.i8G3IAOw010298@toshiba.co.jp>
	<4150128F.4020400@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4150128F.4020400@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 21 Sep 2004 13:37:51 +0200

> Looks good, I'm going to review your patch more in-depth tonight.
> One thing I noticed while looking over it:

Thanks! And I've started to change match/target modules to use
skb_header_pointer().

> 
> >@@ -1535,26 +1546,31 @@
> > 
> > static int
> > tcp_find_option(u_int8_t option,
> >-		const struct tcphdr *tcp,
> >-		u_int16_t datalen,
> >+		const struct sk_buff *skb,
> >+		unsigned int tcpoff,
> >+		unsigned int optlen,
> > 		int invert,
> > 		int *hotdrop)
> > {
> >-	unsigned int i = sizeof(struct tcphdr);
> >-	const u_int8_t *opt = (u_int8_t *)tcp;
> >+	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
> >+	char _opt[60 - sizeof(struct tcphdr)], *op;
> >  
> >
> 
> This should stay a u_int8_t, look at
> http://netfilter.org/security/2004-06-30-2.6-tcpoption.html

Oh, thank you for notice.

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
