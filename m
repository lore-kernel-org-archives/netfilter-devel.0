From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] entry_data
Date: Tue, 13 Jun 2006 22:56:09 +0200
Message-ID: <200606132256.10384.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it>
	<200606121445.42157.max@nucleus.it>
	<448ED795.3010509@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <448ED795.3010509@netfilter.org>
Content-Disposition: inline
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

On Tuesday 13 June 2006 5:19 pm, Pablo Neira Ayuso wrote:

> >  static int
> >  match(const struct sk_buff *skb, const struct net_device *in,
> > -      const struct net_device *out, const void *matchinfo, int offset,
> > -      unsigned int protoff, int *hotdrop)
> > +      const struct net_device *out, const struct xt_match *match,
> > +      const void *matchinfo, int offset,
> > +      unsigned int protoff, int *hotdrop, void *entry_data)
>
> Hm, then you must have a patch to modify the interface match()?

Of course. I sent a patch in the previous message:
https://lists.netfilter.org/pipermail/netfilter-devel/2006-June/024656.html

The patches are available here:
https://lists.netfilter.org/pipermail/netfilter-devel/attachments/20060605/94b0d808/2.6.17-rc5-entry_data_core-0001.bin
https://lists.netfilter.org/pipermail/netfilter-devel/attachments/20060605/94b0d808/2.6.17-rc5-entry_data_matches-0001.bin

-- 
Bye,
   Massimiliano Hofer
