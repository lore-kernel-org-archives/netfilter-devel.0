From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 04:44:52 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625024452.GO7229@naboo.rchrd.phub.net.cable.rogers.com>
References: <20020623132739.12D52455E@lists.samba.org> <15638.42021.31206.821255@isis.cs3-inc.com> <20020624080618.Q5183@oknodo.bof.de> <15638.48245.84830.480715@isis.cs3-inc.com> <20020624084836.R5183@oknodo.bof.de> <15638.49692.902811.4513@isis.cs3-inc.com> <20020624091325.S5183@oknodo.bof.de> <15639.14434.1338.37297@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15639.14434.1338.37297@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 24, 2002 at 08:18:57AM -0700, Don Cohen wrote:

First of all, excuse me being very quiet about this thread so far.

I want to point out that the core team is definitely interested in
reports of performance and/or security/dos weaknesses, as well as
proposed solutions how to fix them.

Thus, even if there are people arguing that we have been pointing out 
potential problems of the hash function or the overall conntrack
implementation weeks/months ago, it still doesn't mean that there is no
interest of having them fixed.

The current problem seems to be that nobody has enough time to
thoroughly debug any of those issues.

So in the direction of Don this means:

1) we appreciate your reports
2) if you want this to be fixed soon, please do more detailed profiling
   in order to point out the code causing the problems
3) don't be discouraged if the overall response from the netfilter
   developers seems slow. For my part, I'm extremely busy right now, 
   since I'm at the linux kernel summit together with other kernel
   subsystem maintainers, and I'm going to visit some two other
   conferences until mid-july.  Apart from that, there's always the
   'normal' maintaining and the long TODO list as well as the 2.5.x
   plans keeping me busy...

Thanks

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
