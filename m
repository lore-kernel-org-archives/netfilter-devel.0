From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula -- answer
Date: Mon, 1 Jul 2002 15:24:42 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15648.54954.625112.168634@isis.cs3-inc.com>
References: <20020701121404.B78724512@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org, bof@bof.de
In-Reply-To: <20020701121404.B78724512@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


The answer from my friendly crypto expert:

Richard Schroeppel writes:
 > >   Problem: a firewall tries to track "connections" going through it
 >     (roughly identified by ip addresses and ports of source and destination)
 >     by keeping the currently active connections in a hash table.
 >     If the hashing algorithm is something simple and well known, such as
 >      bucket index = srcip+destip+srcport+destport mod tablesize
 >      and each bucket contains a list of entries
 >     then an attacker can send data that creates very long lists in very
 >     few buckets, i.e., you might as well not have a hash table.  And this
 >     makes the firewall spend all its time searching the table.
 > 
 >     One suggestion was to change the hash function above to crc where you
 >     start with a seed that is known only to the firewall (chosen randomly
 >     at startup).  The question is whether the attacker can still send data
 >     that causes the table to differ significantly from the result of a
 >     uniform hash.  I don't know enough about crc and hope you know more.
 >     The real question is what's a cheap computation that can't be attacked
 >     in this way.  Crc is already significantly more expensive than +/mod
 >     above.
 > 
 > A cheap trick:  At boot time, the firewall makes up 4 private
 > 32-bit random odd numbers A,B,C,D.
 > The new formula for the bucket index is
 > A*srcip + B*destip + C*srcport + D*destport
 > masked with 0x7fff...fff to make it positive, then continue
 > with mod tablesize.  I suggest tablesize be prime, or at least odd.
 > Also, it shouldn't divide ABCD, and even better has no common factor
 > with ABCD.
 > 
 > This scheme can be broken by a determined attack, if the attacker can
 > figure out (probably any one of) A,B,C,D.
 > He might do this by timing firewall activity based on his inputs,
 > if the timing data is available to high enough resolution.
 > My guess is that the timing data isn't available, and would be
 > obscured by normal traffic, but maybe in the middle of the night
 > he could get something to work.
 > 
 > As a last resort defense, if the firewall detects such an attack,
 > due to hash bucket overflow, it could try to cope by splitting the
 > bucket based on a secondary hash with other coefficients, and/or
 > early expiration of random bucket entries.
 > Or, if an attack is noticed, choose a new random A'B'C'D', and
 > rehash the old table, or rebuild a new table from scratch.
 > 
 > If you use the CRC scheme and the attacker knows some details
 > of the CRC, he can cause some bucket overflow.  The scheme matters.
 > In some cases, the starting seed would be irrelevant, affecting
 > only which bucket got the overflow.
 > 
 > If multiply is too costly, you get nearly the same effect by
 > creating a random table at boot with maybe 256*10 entries, and
 > adding up Table[srcip-leftmost-byte] etc.  But the Pentium
 > multiplier is pretty fast, maybe faster than memory access.
