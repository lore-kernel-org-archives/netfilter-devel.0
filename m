From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: re: conntrack hash function comparison
Date: Tue, 21 Jan 2003 12:12:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu>
References: <15916.59019.853598.788888@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
In-Reply-To: <15916.59019.853598.788888@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 20 Jan 2003, Don Cohen wrote:

>  > Please look trough the web pages and comment it.
>
> I see several hash functions have been added since I last looked.
> Aftr some search I see the code in http://bei.bof.de/
> (I suggest a reference to it from the advertised page.)

I added the reference to cttest to the frontpage as well.

The extended cttest source I used hasn't been sent back to Patrick yet,
because depending on the answer from the author, I might have to remove
the buzhash code from the source.

> This code looks a bit old.  Below is the version I'm using at
> present.  I suggest you try testing this version too.

Fine, I'll test it.

> I expect it will be a little slower (using long numbers) but
> a little better, for instance, on table sizes that are powers of 2.

I don't think we should restrict ourselves to hashes which work with any
kind of hashsize. Be the hast as fast as possible and as good as possible
:-).

> A few details:
> - The ABCD(EF) algorithms were actually suggested to me by Rich
> Schroeppel.

Then credicts goes to him and to you as well.

> - I don't see what you consider odd about the random results.

I believe the random hash should give a smooth distribution of the
entries. But for example in the case of the matrix dataset/8191 hash size
it gives:

Count   Length  CT
5       21      0.14%
3       20      0.22%
11      19      0.50%
29      18      1.19%
50      17      2.32%
99      16      4.43%
180     15      8.02%
290     14      13.41%
445     13      21.11%
662     12      31.67%
833     11      43.85%
1011    10      57.29%
1051    9       69.87%
1046    8       80.99%
911     7       89.47%
716     6       95.18%
442     5       98.12%
254     4       99.47%
105     3       99.89%
38      2       99.99%
7       1       100.00%
3       0       100.00%

The number of the longest hash buckets is out of the distribution - there
are more of them than the hash buckets just shorter than the longest one.
(As I wrote on the pages, we actually test the random number generator in
Linux too so I count these examples as the indication of little
weaknesses in the generator.) This is the very reason why I "measured" the
distances from the ideal hash instead.

> The idea behind ABCD(EF) is that the coefficients A,B,C,D(,E,F) are
> secrets, chosen randomly by each connection tracking machine.
> So far I don't know how this can be attacked.  My current code assumes
> that, if it can be attacked at all, this will at least take a long
> time.  The solution is that (1) I detect that the current coeffecients
> are not working as well as expected (simply that some bucket gets
> filled past a very unlikely threshold), and in that case (2) we choose
> new randome coeffecients and rehash everything (which probably takes
> less than a second unless you have millions of connections).

I don't really like the idea of rehashing if the hash function is
(so) strong.

What is your opinion on the abcdx variant, where the four random
multipliers were chosen so that at any bit postition in the four
numbers there are exactly two zeros and two ones (similarly to the
rtable in buzhash, http://www.cl.cam.ac.uk/users/kw217/pub/Hash.adt.ps.gz).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
