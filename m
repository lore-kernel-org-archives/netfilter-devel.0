From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Fix conntrack iteration.
Date: Tue, 28 Dec 2004 12:22:42 +1100
Message-ID: <1104196962.6910.10.camel@localhost.localdomain>
References: <1103888157.4000.2.camel@localhost.localdomain>
	<41CD79F8.5060003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41CD79F8.5060003@trash.net>
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

On Sat, 2004-12-25 at 15:32 +0100, Patrick McHardy wrote:
> >  	WRITE_LOCK(&ip_conntrack_lock);
> > -	/* Make sure don't leave any orphaned expectations lying around */
> > -	if (ct->expecting)
> > -		remove_expectations(ct, 1);
> > +	BUG_ON(ct->expecting);
> 
> This doesn't look right. The call to remove_expectations was
> added to deal with the TFTP helper registering expectations
> for unconfirmed connections.

Ah, right!  I'll add a comment there instead.  I couldn't see how it
could happen, but this makes sense.

Thanks,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
