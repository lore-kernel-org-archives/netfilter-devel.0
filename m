From: Patrick Schaaf <bof@bof.de>
Subject: Re: cttest-0.1
Date: Sat, 6 Jul 2002 17:23:42 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020706172342.H13116@oknodo.bof.de>
References: <20020705165354.GD3729@aaricia.hemmet.chalmers.se> <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com> <20020706091259.F13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020706091259.F13116@oknodo.bof.de>; from bof@bof.de on Sat, Jul 06, 2002 at 09:12:59AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I have released http://bei.bof.de/cttest-0.2.tar.gz. It is now easier
to modify the list of sizes and hashes that should be plotted, and
there's timing code for the hash functions, together with average
used list length analysis.

> Actually, I now have this nice <128-byte-icache snippet which computes the
> next-smaller-prime, given any 32 bit unsigned. And it's fast.

If somebody wants to review this code, have a look at cttest-0.2/prime.c

The pictures at http://bei.bof.de/ex1/ have been updated to the produce
of cttest-0.2.

I'd like to see some runs from Athlon and Pentium4 systems, to compare
the hash function timings.

best regards
  Patrick
