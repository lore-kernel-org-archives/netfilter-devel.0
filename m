From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 10:53:37 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15644.41633.528107.723418@isis.cs3-inc.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
	<20020628082339.I2890@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020628082339.I2890@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:

 > > I assume that the hash function maps a connection to each bucket
 > > with equal probability, P = 1/B.
 > 
 > Can you find an analysis that permits some non-uniformity, given as
 > a parameter?  I am pretty sure that the hash function we use for
 > conntracking is nonuniform in lots of real world cases. Thus, if
 > you want to propose using that probability derived length limit,
 > then you must prove uniformity of our hash function.

The effect of nonuniformity in the hash function is very easy to
analyze.  It just changes the probability of different buckets.
For any bucket b the same formula works, just replacing P with P[b].
So if we take the most commonly used bucket, call its probability P',
then a pessimistic approximation is that the chance of a new
connection encountering a full bucket is given by the earlier formula
with the number of buckets reduced to 1/P'.

 > I have the vague feeling (being a programmer, not a mathematician :)
 > that even small nonuniformities will have large impact on your
 > probability distribution.
I guess it depends on what you consider "small" non-uniformities.
I think the opposite is true.
The danger in a hash function is that there will be a high correlation
among the hashes of the items that arrive.  In this case I don't see
much danger.  

 > May I suggest a different, experimental approach: extract the hash function
 > from the code, creating a small userlevel tool which reads in the saved
 > contents of some /proc/net/ip_conntrack, and with a hash bucket and limit
 > specified on the commandline, counts the distribution for that specific
 > set of connections, maybe comparing it with the theoretical prediction,
 > resulting in a "how does that real world conntrack table fit to theory"
 > metric? Once done, such a tool could permit command line selection of
 > different hash functions, for comparison.

Sounds easy enough.  You have some "real" (or at least "realistic") data?
