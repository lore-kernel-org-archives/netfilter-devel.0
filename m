From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: re: conntrack hash function comparison
Date: Tue, 21 Jan 2003 08:59:12 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15917.31840.767508.76359@isis.cs3-inc.com>
References: <15916.59019.853598.788888@isis.cs3-inc.com>
	<Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 > > I expect it will be a little slower (using long numbers) but
 > > a little better, for instance, on table sizes that are powers of 2.
 > 
 > I don't think we should restrict ourselves to hashes which work with any
 > kind of hashsize. Be the hast as fast as possible and as good as possible
 > :-).
If it's not going to work well on certain table sizes then you should
really do something to ensure that the table size is one of the good
ones.  At least make the default good and add a comment saying which
sizes are good/bad.

Perhaps I should tell you what the changes are supposed to be good for.
The code I saw in cttest (I only suppose you're using the same code)
multiplies 32 bit source IP by 32 bit random number.  The question is
then what part of the result is used.  If you do 32 bit adds then only
the last 32 bits if the product is used.  Note that, while the last
bit of source address affects all 32 of these result bits, the first
bit of source address affects only the first result bit, and that only
if the last bit of the random number is 1.  What I want is for every
bit of input to affect every bit of output.  I therefore now split the
64 bit result in two and add the two halves.  (Which has that effect.)
So before if the table size was, say, 2^13 (8K), only the last 13 bits
of the inputs would affect the result.  So 1.2.3.4 would hash to the 
same thing as 17.39.3.4, or even worse if you're unlucky with
endianness, 1.2.3.4 might hash the same as 1.2.17.39 !
In any case, regardless of the likelihood of this sort of thing
arising in legitimate data, it makes intentional attack a lot easier.

 > > - I don't see what you consider odd about the random results.
 > 
 > I believe the random hash should give a smooth distribution of the
 > entries. But for example in the case of the matrix dataset/8191 hash size
 > it gives:
 > 
 > Count   Length  CT
 > 5       21      0.14%
 > 3       20      0.22%
 > 11      19      0.50%
 > 29      18      1.19%
 > 50      17      2.32%
 > 99      16      4.43%
 > 180     15      8.02%
 > 290     14      13.41%
 > 445     13      21.11%
 > 662     12      31.67%
 > 833     11      43.85%
 > 1011    10      57.29%
 > 1051    9       69.87%
 > 1046    8       80.99%
 > 911     7       89.47%
 > 716     6       95.18%
 > 442     5       98.12%
 > 254     4       99.47%
 > 105     3       99.89%
 > 38      2       99.99%
 > 7       1       100.00%
 > 3       0       100.00%
 > 
 > The number of the longest hash buckets is out of the distribution - there
 > are more of them than the hash buckets just shorter than the longest one.

The expected number is "smooth", but of course you shouldn't expect a
given test to follow the expected number exactly.  This looks to me
like a perfectly reasonable data point.  Generally I'm happy if the
longest bucket is not much longer than expected.  That is, use the
formula from last summer's discussion to see the expected number of 
buckets of length 21, and if it's > .1 then don't worry.  If it's
between .1 and .001 then try a few more tests.  If it's 1e-12 then
your hash function is no good.

 > I don't really like the idea of rehashing if the hash function is
 > (so) strong.
At some point it's clearly worth rehashing.  You have to decide what
that point is.  If the function is so good and successfully resists
attack then you'll never (or hardly ever) need to rehash, so all you
pay is a tiny amount of space for code that's never used.
Whereas, if you're extremely unlucky, or a clever new attack method
comes along, that small amount of code will help you a whole lot.
You choose your table size and rehash threshold in order to make the 
search time acceptable (max length of bucket) and also the probability
of rehash very small. 
I think at the moment I use 20 as my rehash threshold and a table
size that's the number of entries I plan to put in it, so average
bucket occupancy <= 1.  
(Dusting off my old code, 20 entries in a given bucket in that case
seems to have probability ~ 1e-19.
So even with 1e6 buckets, not very likely.)

 > What is your opinion on the abcdx variant, where the four random
 > multipliers were chosen so that at any bit postition in the four
 > numbers there are exactly two zeros and two ones (similarly to the
 > rtable in buzhash, http://www.cl.cam.ac.uk/users/kw217/pub/Hash.adt.ps.gz).

Immediate reactions:
- I'd like to hear the rationale for this - what good is it supposed
to do?  Conversely, what problems arise from not doing it?
- Rich did mention to me that it would be good for the random numbers
to each contain approximately the same number of 1's and 0's.
It's at least clear that zero would be a bad choice.  Perhaps when
you choose random numbers you could just require, e.g., every byte
contain 3-5 1's (and 0's), i.e., eliminate the cases of 0,1,2, of
which there are 2+16+56=74, leaving 182 out of 256 possible values... 

Right now I simply rely on rehash to fix any such problems (or any
OTHER problems for that matter) that actually arise.  Since I argue
you really ought to have that as a backup anyway, I don't mind using
it to solve this problem.  I do recommend a log entry if you ever have
to rehash, and frequent rehash would be worth notification if you have
such a facility.
