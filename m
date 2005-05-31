From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/3] OSF: code beautification.
Date: Wed, 1 Jun 2005 02:57:31 +0400
Message-ID: <20050601025731.7dac3234@zanzibar.2ka.mipt.ru>
References: <cede307105053115377afb8aac@mail.gmail.com>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pavel A. Nekrasov" <pnekras@gmail.com>
In-Reply-To: <cede307105053115377afb8aac@mail.gmail.com>
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

On Wed, 1 Jun 2005 00:37:05 +0200
"Pavel A. Nekrasov" <pnekras@gmail.com> wrote:

> hello!
> 
> >@@ -186,12 +181,10 @@
> > 	df = ((ntohs(ip->frag_off) & IP_DF)?1:0);
> > 	window = ntohs(tcp->window);
> > 	
> >-	if (tcp->doff*4 > sizeof(struct tcphdr))
> >-	{
> >+	if (tcp->doff*4 > sizeof(struct tcphdr)) {
> > 		optsize = tcp->doff*4 - sizeof(struct tcphdr);
> 
> This won't work with fragments, you consider here that the tcp header
> is linear and that isn't always true.

It does.
Ip, tcp and options are obtained using fragment aware methods.

> BTW, fix a deadlock. match() can be called from both bh and process context.

Neither it suffers rcu lock in nf_hook_slow()?

> kind regards,
> Pavel


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
