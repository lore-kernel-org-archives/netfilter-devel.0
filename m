From: Patrick Schaaf <bof@bof.de>
Subject: cttest-0.4
Date: Sun, 7 Jul 2002 19:37:18 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707193717.P13116@oknodo.bof.de>
References: <20020707151703.M13116@oknodo.bof.de> <1026054628.1283.170.camel@tux> <20020707181007.O13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020707181007.O13116@oknodo.bof.de>; from bof@bof.de on Sun, Jul 07, 2002 at 06:10:07PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> 	http://bei.bof.de/ex2crc
> 	http://bei.bof.de/ex3crc

These are updated with a faster version of crc32, called crc32_bof for now.
A seed is XORed with the source IP, and an unrolled CRC is done over the
sport, dip, and dport. Curves look close enough to crc32, as far as I
can see. For the speedup, I must caution that the timing is done for
the unrealistic case of a dense loop doing not much of anything
besides calculating the hash function over and over. This means that
the 1k crc32_table will be in L1 cache on all interesting processors.
However, this may not be the case for a system doing more than calculating
hashes. It is likely that the crc32 timings here are best-case values.
For the other hashes, the timings should reflect reality.

I have made cttest-0.4.tar.gz. In addition to the crc32_bof, this includes
seed selection, which may be interesting for experimentors. The seed used
in the crc32 hashes, can be set in the ctreport.hashes.XXX control file,
by appending "+1234" to the hash name.  Append "+R" for random seed
selection. By default, the new crc32 functions use one of Don's
constants (C) as a default seed. The crc32 itself is unmodified.

I haven't done anything yet with that seed selection. Feel free to play.

While you compare these functions, I'd like to mention something we _may_ need
to look out for. Some of the hash functions we are looking at, behave the
same whether big endian or little endian. Others factually are two different
hash functions, one on little endian, and one on big endian. Up to now I did
not care much about this, but I see all our known results so far have been
on little endian machines. We need some runs on big endian gear.

That's it for today - have a nice evening, whereever you are.

best regards
  Patrick
