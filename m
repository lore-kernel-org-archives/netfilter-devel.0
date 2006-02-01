From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: expectation mask handling in nfctnetlink
Date: Wed, 01 Feb 2006 22:16:06 +0900 (JST)
Message-ID: <200602011316.k11DG7lA011248@toshiba.co.jp>
References: <200601151307.k0FD7evx014168@toshiba.co.jp>
	<200601200457.k0K4vvAI001787@toshiba.co.jp>
	<43E01851.4040306@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <43E01851.4040306@netfilter.org>
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


From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 01 Feb 2006 03:09:21 +0100

> > I've re-visited this. For now, I'm not sure this is the best solution
> > because I don't see how format and contents of expectation mask
> > is required by libnetfilter_conntrack. It doesn't use dumped expectation
> > mask at all.
> 
> Maybe userspace helpers could need that information some day. I don't
> want to add limitations to libnetfilter_conntrack just because we have
> some assumptions.
> 
> > Then the other idea can be considerd, too. For example, dumping union of
> > l3part(mask->u3.all) and union of proto part(mask->u.all) without assumption
> > of specific address family/protocol. Do you have any idea on this ?
> 
> We shouldn't send the whole union via netlink. If the union is modified
> further, it will break backward compatibility for userspace applications
> since the size could change.

I don't think so because we can use 'len' field for that.
But anyway,

>
> So, the possibilities I see up to now are:
> 
> a) just remove the unlikely() statement.
> Drawback: Not so efficient, since that checking isn't always required.
> 
> b) back to my idea: set l3num to the maximum known value (0x1F), and add
> a bug trap in nf_ct_expect_related to check that nobody uses a value >=
> AF_MAX.
> Drawback: People surely will hit bug while writing their own helpers.

I'm fine to do a) for current nfctnetlink. Let's re-visit this
when it becomes clear about format to dump expectation mask.

-- Yasuyuki Kozakai
