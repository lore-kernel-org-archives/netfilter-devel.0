From: Patrick Schaaf <bof@bof.de>
Subject: Re: performance issues (nat / conntrack)
Date: Mon, 24 Jun 2002 08:06:18 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020624080618.Q5183@oknodo.bof.de>
References: <20020623132739.12D52455E@lists.samba.org> <15638.42021.31206.821255@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15638.42021.31206.821255@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Sun, Jun 23, 2002 at 09:46:29PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jun 23, 2002 at 09:46:29PM -0700, Don Cohen wrote:
>  > From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
>  > >  > Since in my test, each connection is ephemeral (<10ms) ...
> 
> One question here is whether the traffic generator is acting like
> a real set of users or like an attacker.  A real user would not keep
> trying to make connections at the same rate if the previous attempts 
> were not being served.  I suspect you're acting more like an attacker.

He definitely is. The test he described is completely artificial, and does
not represent any normal real world workload.

Nevertheless, it does point out a valid optimization chance. We discussed
that months ago, and it's still there.

In the real world, nobody seems to care. I know I don't, and I really
looked. It doesn't matter.

As for theories, the last time, we almost agreed that the hash function
is very bad. Nobody did confirm that feeling, though.

>  > > Just wondering, how did you measure cpu load?
>  > procinfo -n10 ; [d] for showing differences, which in fact, computes
>  >                    the differences of cumulated cpu time (got from 
>  >                    /proc/stat) on the given period: (tsys1-tsys0)/T
> I see /proc/stat - user, nice, system, idle.  Thank you.  Very useful.

A lot better would be a test with kernel profiling enabled.

best regards
  Patrick
