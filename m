From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack performance/DoS formula
Date: Fri, 5 Jul 2002 15:47:09 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705134709.GE21280@naboo.ists.dartmouth.edu>
References: <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com> <20020628232819.H4136@oknodo.bof.de> <15644.58258.483223.56527@isis.cs3-inc.com> <20020629110332.I4136@oknodo.bof.de> <15645.58583.30187.70748@isis.cs3-inc.com> <20020629192218.P4136@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Don Cohen <don-nf@isis.cs3-inc.com>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020629192218.P4136@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jun 29, 2002 at 07:22:18PM +0200, Patrick Schaaf wrote:
> I think my analysis shows a possible problem with your approach: when such
> a port scan results in an overly long single bucket list, that list will
> prevail for up to 5 days. If N is the number of buckets, and newly arriving
> connections are evenly spread over the buckets, then every Nth connection
> will fall into that overly long bucket - being blocked if we apply your
> cutting logic unmodified.
> 
> However, in my observation of those problematic buckets, the connections
> are UNREPLIED. Then we can use the same trick that is used when
> ip_conntrack_max is reached: recycle one of those UNREPLIED
> connections immediately for the new conntrack.

this sounds like a sane way to go.

> NO. They were "alone in their bucket". In other words, no active connection
> fell into the same bucket, so they won't come into play at all during lookup.
> And, as each entry has its individual timer, there is no scanning of the
> overall table, so they would be really untouched in real life, until they
> timeout after 5 days.

but how high is the probability that they are [and remain] 'alone in
their bucket' ?  This could just be a coincidence...

> At this point, I would like to stop for some time, and await results
> from other's real world ip_conntrack setups.

I'm going to do this on a couple of my firewalls on Jul 08 [that's the
single day I'm going to be in .de between my different trips...].  Right
now I only have dialup modem internet... So please wait another couple
of days.

Thanks.

> best regards
>   Patrick

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
