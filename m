From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: performance issues (nat / conntrack)
Date: Sun, 23 Jun 2002 21:46:29 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15638.42021.31206.821255@isis.cs3-inc.com>
References: <20020623132739.12D52455E@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020623132739.12D52455E@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
 > >  > Since in my test, each connection is ephemeral (<10ms) ...

One question here is whether the traffic generator is acting like
a real set of users or like an attacker.  A real user would not keep
trying to make connections at the same rate if the previous attempts 
were not being served.  I suspect you're acting more like an attacker.

 > > So I'm guessing that large number of entries in conntrack table is
 > > evidence that packets are being lost.  
 > not only: a crashed endpoint breaking the tcp sequence causes also
 > garbage entries in conntrack (known issue).
Again, a crashed endpoint would likely not get as many hits.
My guess is that the reason for all the conntrack entries is related
to what I described in my earlier mail.  Creating conntrack entries is
expensive.  My machine could only do it about 1000 time/sec.  Off hand
I don't know which packets are dropped.  I'd guess that the ones that
make it through the conntrack code do get forwarded, but I don't know.
If, for example, the return packets are lost because we're too busy 
adding new conntrack entries, then there's nothing to cause the
entries to go away, other than those timeouts.

 > > Just wondering, how did you measure cpu load?
 > procinfo -n10 ; [d] for showing differences, which in fact, computes
 >                    the differences of cumulated cpu time (got from 
 >                    /proc/stat) on the given period: (tsys1-tsys0)/T
I see /proc/stat - user, nice, system, idle.  Thank you.  Very useful.

================

 > > Everybody agrees that NAT is evil and it should be avoided in all
 > circumstances.
This is news to me!  Is this just because the implementation is
lacking or some more fundamental reason?
