From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 21:03:42 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625190342.GK7975@naboo.ols.wavesec.org>
References: <Pine.LNX.4.33.0206251119260.4927-100000@blackhole.kfki.hu> <01ff01c21c45$c90eb2a0$0489cb8a@etbx180> <20020625155038.A527@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020625155038.A527@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 03:50:38PM +0200, Patrick Schaaf wrote:
> > In my opinion, a first step should be to reconsider timeout values but
> > also timer mechanisms.
> 
> No. A first step MUST be pointing out that the current timeouts become
> a problem in REAL LIFE. Right now you are speculating.  On all setups
> I personally know, the timeouts are NOT a problem.
> 
> Regarding timer _mechanisms_ I have seen no indication at all that the
> current mechanism is a problem. If you want to insist, _please_ learn
> about kernel profiling, and start posting FACT.

I've been talking about this with a couple of people here at the kernel
summit, and it looks like the per-packet del_timer/add_timer in
ip_ct_refresh should be a severe performance hit on SMP boxes.

Changing this to 'do not update timer if update would be < HZ different
than current timer' is a two-line patch.  

As stated before, I'm currently away of my testing equipment, so if 
anybody wants to give it a try...

> regards
>   Patrick

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
