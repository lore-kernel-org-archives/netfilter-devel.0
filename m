From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] entry_data
Date: Sun, 18 Jun 2006 00:55:22 +0200
Message-ID: <200606180055.25350.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it> <448FD0F6.3010506@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <448FD0F6.3010506@anduras.de>
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

On Wednesday 14 June 2006 11:03 am, Sven Anders wrote:

> > As explained in my previous posts the purpose of this patch is to give
> > matches the opportunity to store entry specific data. Several matches
> > already achieve this reserving some space in the data fields, but these
> > come from userspace and I don't think it is the Right Way(TM) to do it.
>
> Does this mean we can reuse these fields for other puroposes without
> breaking compatibility with iptables?

Yes, with some caveats.

> I'm particularly interested in adding a negation to the "limit" match and I
> think the match is using one of these special data fields...
>
>  > /* Ugly, ugly fucker. */
>  >  struct xt_rateinfo *master;
>
> If this gives us the possibility to add the negation, who do we distinguish
> between the old and new limit version. In other words: Who do we reach a
> maximum compatibility?

In your case, the current version doesn't use master in userspace and
immediately wipes it in kernel space.
You could just replace it with another field (without changing the total
size), start using it in the new libipt_limit and detect it accordingly from
userspace while using my patch for the real master (supposing my patch is
accepted).
This would never lead to a crash, but the new userspace wouldn't be able to
distinguish if it has an appropriate kernel and it may silently drop the
negation with older versions.
For this purpose you could use the revision field and set a higher minum
revision when the limit is negated.

This leads me to a more radical proposal. Is there any reason we don't have a
general way to negate matches? It wouldn't be too difficult and we could
implement some new features such as negating the whole set of matches or a
single entry.
We could even abandon the madatory logical AND of every entry and pass a
minterm set (with AND as the default), but maybe this is too general.

--
Saluti,
   Massimiliano Hofer
        Nucleus
