From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: prearation of removing skb_linearize()
Date: Tue, 21 Sep 2004 13:37:51 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4150128F.4020400@trash.net>
References: <200409160318.i8G3IAOw010298@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200409160318.i8G3IAOw010298@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Yasuyuki,

Yasuyuki Kozakai wrote:

>Hi,
>
>I updated the patch which prepares to remove skb_linearize() from ip6_tables.c
>
>This patch uses skb_header_pointer() so that packets can be parsed even though
>skb_linearize() doesn't exist. But this patch doesn't remove skb_linearize()
>yet. We can remove it after changing all match/target modules.
>
>Moreover ...
>	- I deleted the optimization not to parse IPv6 extension header
>	  many time from previous patch. I'll send the patch to do this
>	  separately.
>	- fixed the bug that "offset" argument of match functions are always 0.
>	- deleted "hdr" and "datalen" argument and added "protoff" argument
>	  to match functions. "protoff" means the offset to Layer 4 protocol
>	  header.
>	- the argument order of target function is changed likely IPv4 modules.
>	  This prevents user from meeting kernel panic when they use old
>	  match modules.
>	- changed {tcp,udp,icmp6}_match(). These functions became very similar
>	  to codes in ip_tables.c again.
>
>I tested this patch with some configurations(attached file: "tests.txt")
>In these tests, I also used quick hack to fragment skb at the end of IPv6
>header before filtering to confirm that I didn't forget to use
>skb_header_pointer() somewhere.
>
>Double checks and more tests are welcome.
>  
>
Looks good, I'm going to review your patch more in-depth tonight.
One thing I noticed while looking over it:

>@@ -1535,26 +1546,31 @@
> 
> static int
> tcp_find_option(u_int8_t option,
>-		const struct tcphdr *tcp,
>-		u_int16_t datalen,
>+		const struct sk_buff *skb,
>+		unsigned int tcpoff,
>+		unsigned int optlen,
> 		int invert,
> 		int *hotdrop)
> {
>-	unsigned int i = sizeof(struct tcphdr);
>-	const u_int8_t *opt = (u_int8_t *)tcp;
>+	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
>+	char _opt[60 - sizeof(struct tcphdr)], *op;
>  
>

This should stay a u_int8_t, look at
http://netfilter.org/security/2004-06-30-2.6-tcpoption.html

Regards
Patrick
