From: Patrick Schaaf <bof@bof.de>
Subject: Re: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 16:34:02 +0100
Message-ID: <20070320153402.GA28954@oknodo.bof.de>
References: <45FFF8C3.9050606@info.ucl.ac.be> <45FFFCE5.6030705@netfilter.org>
	<45FFFD2A.9080508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45FFFD2A.9080508@trash.net>
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

> > We can't just get rid of it since bloom filters have false positives, so
> > it could happen that we could miss some new connections that are not
> > actually in the conntrack table.
> 
> That wouldn't be a big problem in my opinion, you can freely tune the
> probability.

Wouldn't two conntrack entries in the hash for the same tuples be
catastrophic somewhere? (I have no idea, actually)

The other thing about bloom filters that worries me, having read
the wikipedia entry, is that you cannot remove elements. Probability
of false positives thus increases as conntracks are added. And a
future repetition of exactly the same tuple would certainly be
a false positive. Tuples repeat pretty fast with things like BGP,
and a filter regeneration seems to involve shuffling all current
conntracks into a fresh bloom filter.

Either I misunderstand something fundamental, which is not
unlikely, or that kills the idea.

best regards
  Patrick
