From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: conntrack performance/DoS formula
Date: Thu, 27 Jun 2002 13:46:28 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15643.31140.525551.843205@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I had mentioned that I was hoping to remember/find the appropriate
formula for the probability of a hash bucket reaching its limit.
I got out my prob-stat book from I-won't-mention-how-many years ago.

Suppose there's a limit of L connections to be put in a hash table
with B buckets, each bucket allowed to hold a max of M entries.
I assume that the hash function maps a connection to each bucket
with equal probability, P = 1/B.
Suppose the table is full, meaning it has L connections in it.
The probability that a given bucket has n connections in it is:

c(L,n) (P ^ n) ((1-P) ^ (L-n))  [called binomial distribution]

where c(L,n) is the number of ways of choosing n things out of L,
which is L! / (L-n)! n!, i.e., 10x9x8/3x2x1 ways to choose 3 out of 10.
The binomial formula comes from the fact that we've chosen n
connections out of L to put in this bucket, each of those with
probability P, and of course the other L-n went into other buckets
with probability 1-P. 

BTW, this is closely approximated by a Poisson distribution.

Anyhow, on to some answers.  My initial guess was that with L/2
buckets (so the average bucket length is 2), max bucket size M=10
would result in only a microscopic chance of overflow.
The chance is bigger than I expected, about 1E-5.
Raising M to 15 reduces it to about 1E-10 and raising M to 20 makes it
about 1E-15, which seems quite respectable. 

There's a pretty straight forward tradeoff between space and time.
Instead of increasing the time (# iterations = M) you can increase 
the space (# buckets).  Changing from L/2 buckets to L we get
M=10 probability 1E-9 of filling a bucket
M=15 probability 1E-14
M=20 probability 1E-20

And while we're at it, with 2L buckets (average occupancy .5)
M=10 prob ~ 1E-11
M=15 prob ~ 1E-18
M=20 prob ~ 1E-25

My guess is that the amount of time required to do 20 iterations
comparing connection data with elements of a list in a bucket is
very small compared to the amount of time otherwise spent on a
packet.  On the other hand, a hash bucket is also pretty cheap.
The data for a connection takes much more space than 2 hash buckets, 
or even 10.  And with 10L buckets the chance of overflow at M=10
is only 1E-19, for M=20 it's somewhere around 1E-40.

So, there you have it.
