From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] Open Port match
Date: Thu, 5 May 2005 10:47:45 +0200
Message-ID: <1561393117.20050505104745@dns.toxicfilms.tv>
References: <1115264925.2118.3.camel@localhost.localdomain>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1115264925.2118.3.camel@localhost.localdomain>
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

Hello,

This is starting to make me wonder.
Why do we all duplicate similar checks for packet validity
in netfilter matches?

Should not we move this into functions like:

int skb_is_fine(struct sk_buff *sk,...)
int th_is_fine(struct tcphdr, ...)
int uh_is_fine(struct udphdr, ...)
int ih_is_fine(struct icmphdr, ...)

And use them consistenly throughout the matches?

        if (!th_is_fine(th))
                goto dropit;

I am refering to code like below:
+       /* If we don't have the whole header, drop packet. */
+       th = skb_header_pointer(skb, skb->nh.iph->ihl * 4,
+                               sizeof(_tcph), &_tcph);
+       if (th == NULL)
+               goto dropit;
+
+       /* Malformed. */
+       if (th->doff*4 < sizeof(*th))
+               goto dropit;
+

It would give less duplication, less occasions to make a mistake
and more readable code, no need for lots of comments around.

--
Regards,
Maciej
