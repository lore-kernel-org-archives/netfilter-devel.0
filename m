From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: cttest-0.3 (conntrack hashing)
Date: Mon, 8 Jul 2002 14:30:22 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15658.1134.560895.290945@isis.cs3-inc.com>
References: <20020708114504.CAF79473F@lists.samba.org>
	<15657.50484.842528.683308@isis.cs3-inc.com>
	<20020708194044.U13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020708194044.U13116@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


It turns out that your question about endianness was right on the
mark.  My suboptimal results were related to the fact that the more 
variable parts of the data were in the high bits and I was not doing 
a good job of causing those to influence the results.
The original idea of stuff like ans += ans >>16 was to spread the
variation in the high bits to the low bits where they would affect
mod 2^i for small i.  The version below works better.

I assume that 32x32=>64 bit multiplication is not too expensive.

static u32 hash_conntrack(struct ct_key *key)
{
  unsigned long long ls, ld, lsp, ldp, sum;
  ls = (unsigned long long) key->sip * A;
  ld = (unsigned long long) key->dip * B;
  lsp = (unsigned long long) C * key->sport;
  ldp = (unsigned long long) D * key->dport;
  sum = 
    (ls + (ls >> 32) +
     ld + (ld >> 32) +
     lsp + (lsp >> 32) +
     ldp + (ldp >> 32) +
     E * key->proto) ^ F;
 
 return sum;

With the standard data -u I got these results
table size: max bucket sizes 
 256:167 512:88 1K:51 2K:31 4K:20 8K:13 16K:9 32K:9 64K:7 256K:4
which are pretty close to expected.

The theory is that in multiplying a 32 bit number, such as sip, 
by random 32 bit A, bit i of A influences bits i thru i+31 of 
the result.  By adding (or xoring, etc) bits 32-63 to bits 0-31
we get a 32 bit result in which each bit of sip influences each
bit of the result.  The same thing works for 16 bit sport.
Actually, if you like, you can pack sport and dport into a single
32 bit word and multiply by C (or D), which saves one multiply.
I figure it hardly matters whether I do the analogous thing for
proto, since it's so short.
