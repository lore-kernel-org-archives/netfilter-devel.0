From: Patrick Schaaf <bof@bof.de>
Subject: Re: cttest-0.1
Date: Sat, 6 Jul 2002 09:12:59 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020706091259.F13116@oknodo.bof.de>
References: <20020705165354.GD3729@aaricia.hemmet.chalmers.se> <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Andrew Smith <nfml@k1k2.com>
Content-Disposition: inline
In-Reply-To: <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com>; from nfml@k1k2.com on Sat, Jul 06, 2002 at 04:10:01PM +1000
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > if (hashsize%2 == 0)
> > 	hashsize--;
> 
> Just so you don't underestimate a requirement ... :-)

Underestimating is desirable here. User gives upper bound - observe it!

> (assume we are checking positive numbers ;-)

We are, the variable in question, is unsigned.

Actually, I now have this nice <128-byte-icache snippet which computes the
next-smaller-prime, given any 32 bit unsigned. And it's fast.

If the core team doesn't puke, that's what I would like to do at
conntrack module load time.

best regards
  Patrick
