From: don-cs3@isis.cs3-inc.com (Don Cohen)
Subject: hashing answers
Date: Sun, 7 Jul 2002 01:26:40 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15655.64320.272481.341687@isis.cs3-inc.com>
References: <200207022303.g62N3No03454@baskerville.CS.Arizona.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <200207022303.g62N3No03454@baskerville.CS.Arizona.EDU>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I see why table sizes that are powers of two don't work well
in the ABCD(EF) algorithm and how to fix it.  Similarly why
multiples of 2 in A-F cause trouble.

Suppose your modulus is 2^i.

[Sorry, I mix c notation with normal math:
 ^ means expt, << means shift]

In the term A*srcip only the bottom i bits of srcip and A matter.
Consider A = Ahigh<<i + Alow and
         srcip = shigh<<i + slow
with slow and Alow < 2^i

Then A*srcip =
 Alow * slow + 
 1<<i * (Ahigh * slow + Alow * shigh) +
 1<<(i+i) * Ahigh * shigh
which, mod 2^i is Alow*slow mod 2^i

If you want to use 2^i as a modulus then in order to make every part
of the input count you have to process it in chunks no larger than
i bits.  So for my standard test table size of 8K (2^13) it's not even
good enough to split ip addresses in half and use ports as-is - all
these 16 bit quantities are ignoring the top 3 bits.  

Similarly, if we use 32 bit arithmetic in the ABCD algorithm, even if
the modulus is odd, the high order bit of srcip can only affect
srcip*A in the high order bit, and even then only if A is odd!  In
fact, if A has i multiples of 2 then the top i bits of srcip have no
effect on the intermediate 32 bit result, and hence no effect on the
final answer.

On the other hand, if you want a table size or 1M (2^20) then it's not
good enough to take the sum of a bunch of products of pairs of 8-bit
quantities - the answer would only be on the order of n*2^16 where n
is the number of terms.  This problem can be solved by multiplying 
the 8 bit pieces of key by secret random numbers that are much larger
than 8 bits so as to spread the result across the larger modulus.

This all suggests the safe thing would be to take very small pieces of
the key (in the ultimate case, single bits) and multiply each by its
own constant which is large enough to supply bits to the whole
modulus.  Of course, the smaller the pieces and the bigger the
modulus, the more multiplies you have to do.  (I did get the
theoretically expected results for my 8K table by processing the
data one byte at a time.)

At the moment I think it's a reasonable compromise to require the
modulus to be odd and break the key into 16 bit pieces.  If we
multiply 16 bit pieces of key by 16 bit random numbers, then each
bit of key affects 16 bits of intermediate result, and the fact that 
the modulus is odd means that each of these bits affects the
remainder. 
