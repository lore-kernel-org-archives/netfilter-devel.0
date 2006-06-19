From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] entry_data
Date: Mon, 19 Jun 2006 19:45:22 +0200
Message-ID: <4496E2B2.6010209@trash.net>
References: <200606050029.08602.max@nucleus.it> <448FD0F6.3010506@anduras.de>
	<200606180055.25350.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606180055.25350.max@nucleus.it>
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

Massimiliano Hofer wrote:
> This leads me to a more radical proposal. Is there any reason we don't have a
> general way to negate matches? It wouldn't be too difficult and we could
> implement some new features such as negating the whole set of matches or a
> single entry.
> We could even abandon the madatory logical AND of every entry and pass a
> minterm set (with AND as the default), but maybe this is too general.

It would be useful for some matches (basically those that only check
a single attribute), others may want to combine negated matching
on some attributes with non-negated matching on others. In these
cases it might still be useful to negate the entire result. It
would have the advantage of getting more consistent behaviour,
currently some matches treat unknown conditions or errors as
"always no match", independant of inversion.

For example xt_connmark:
        const u_int32_t *ctmark = nf_ct_get_mark(skb, &ctinfo);
        if (!ctmark)
                return 0;


... my opinion is that if the packet doesn't have a mark the expression
! <mark> is clearly true. Another questionable behaviour in my opinion
is using hotdrop to drop packets which are missing the information we
are interested in. The same argument holds here, if something is not
present, it just doesn't match. And negated it does match. The least
we should do is have consistent behaviour, so either connmark should
also use hotdrop, or nobody should (well, except for the few cases
where it is unsed in case of memory allocation failures and things
like that).
