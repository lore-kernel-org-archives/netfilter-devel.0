From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Fri, 5 Jul 2002 21:25:26 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705212526.E13116@oknodo.bof.de>
References: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com> <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu> <20020704235831.GO20357@naboo.ists.dartmouth.edu> <200207051201.21457.fabrice@celestix.com> <20020705142127.GK21280@naboo.ists.dartmouth.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Fabrice MARIE <fabrice@celestix.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20020705142127.GK21280@naboo.ists.dartmouth.edu>; from laforge@gnumonks.org on Fri, Jul 05, 2002 at 04:21:27PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

On Fri, Jul 05, 2002 at 04:21:27PM +0200, Harald Welte wrote:
> 
> > You could just add a boolean field 'terminating' to the iptables_target.
> > Then, make sure iptables abort and complains if it sees more than one
> > terminating target being requested in a single rule.
> 
> no, it's not about how to distinguish it internally.  It was more like:
> How does the user know which targets terminate and which don't [just by
> looking at the name or it's usage]

Random notice: the same question waits for the user who wants to understand
the action of some "previous user defined chain" he just sees. Does that
user defined chain terminate in any case?

My point? iptables rulesets tend to become sufficiently complex in a
short time so that "vague inspection" won't make a given ruleset
easily understandable. IMHO that's a tribute to the flexibility
we have with iptables. Engage brain before making modifications.

have a nice weekend
  Patrick
