From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 14:35:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706201417370.5731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
	<4678F7A2.6090203@netfilter.org>
	<Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
	<46790A58.9050106@netfilter.org>
	<Pine.LNX.4.64.0706201328260.5731@fbirervta.pbzchgretzou.qr>
	<46791704.4090609@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46791704.4090609@netfilter.org>
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


On Jun 20 2007 14:01, Pablo Neira Ayuso wrote:

> Does this give you a clue?

It is a start. Thank you.

> static int event(struct notifier_block *this, unsigned long events, void *ptr)
> {
> 	struct nf_conn *ct = (struct nf_conn *)ptr;
>
> 	if (ct == &nf_conntrack_untracked)
> 		return NOTIFY_DONE;
>
> 	if (events & IPCT_NEW)
> 		printk("ct %p has been created\n", ct);
> 	if (events & IPCT_DESTROY)
> 		printk("ct %p has been destroy\n", ct);

Correct me if I am wrong, but I think DESTROY is thrown when the connection
_really_ disappears, e.g. disappear from `conntrack -L`
(/proc/net/ip_conntrack). But TIME_WAIT connections still show up in
/proc/net/ip_conntrack and/or `conntrack -L`.
Or not?

	Jan
-- 
