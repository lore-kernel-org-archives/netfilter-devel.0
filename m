From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: cttest-0.3 (conntrack hashing)
Date: Mon, 8 Jul 2002 10:00:36 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15657.50484.842528.683308@isis.cs3-inc.com>
References: <20020708114504.CAF79473F@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020708114504.CAF79473F@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 > From: Martin Josefsson <gandalf@wlug.westbo.se>
 > The rt hash doesn't do well at all on your data. The winner on your data
 > is crc32 which is very robust in all tests on all data it seems. It's
 > just a shame that it's so cpu-consuming compared to the other hashes.

You're missing the main point here.  I believe that crc is very easy
to attack.  It's clearly trivial without choosing a random initial
seed.

 > From: Patrick Schaaf <bof@bof.de>
 > The abcd hash also fares very well, if we disregard the results for
 > the (avoidable) bad bucket counts. abcd plus prime bucket counts would
 > be as good as crc32, if I did not overlook some result.

I believe that odd is just as good as prime.

 > For the abcd hash, random generation of the multipliers is also an option.

Not an option but a necessity if you want to prevent attack.
Actually, recall my proposal that when a bucket overflows you choose
new coefficients and rehash the whole table.  I think this is also a
necessity.  But if you do that, then I guess it wouldn't be so bad to
always start with the same coefficients - just waiting for the first
attack.

 > But I'll stay undecided on the issue for some more time. We are still lacking
 > any data from genuine web servers, and we only have a vague feeling about
 > what an attacker may do.

Unfortunately it's way too easy to come up with new candidate
functions.  It's much harder to find convicing evidence that
(1) they perform well in the sense of approximating the random
distribution 
(2) convince yourself that they're hard to attack.
Cttest is useful for showing that (1) is NOT true, but offers
only weak evidence that (1) IS true, other than for particular data.  
And, of course, it does not offer any evidence for (2).

My friend the crypto expert told me that crc is easy to attack,
and suggested ABCD(EF) because it has the right properties to
resist attack.  It would take more work for me to demonstrate that
crc is bad, and to better understand ABCD and possibly adjust it,
but just on the basis of expert opinion, I think it's worth working
on ABCD and giving up on crc and most of the others.

I welcome input from any other crypto experts out there.
