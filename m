From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: IPtables performance (fwd)
Date: Fri, 2 May 2003 09:57:23 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305020947070.8241-100000@fantomas.insite.com.br>
References: <1051455460.11505.143.camel@robban.port80.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Chris Wilson <chris@netservers.co.uk>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
	John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Robert Olsson <robban@robtex.com>
In-Reply-To: <1051455460.11505.143.camel@robban.port80.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 27 Apr 2003, Robert Olsson wrote:

> On Sun, 2003-04-27 at 15:02, Harald Welte wrote:
> > On Tue, Apr 22, 2003 at 12:04:26PM +0100, Chris Wilson wrote:
> > > Dear Sirs,
> > > 
> > > We have been having a problem with the performance of iptables in loading
> > > large and complex rulesets for a long time. We have tracked it down to the
> > > mark_source_chains kernel function, which takes about 15 seconds to
> > > execute with a fairly large and complex ruleset on decent hardware.
> > 
> > yup, we are aware of this problem.  However, most people tend to execute
> > iptables 1000 times for inserting 1000 rules, which is obviously the
> > wrong way to do it.  This way you end up doing 1000 ruleset-loads and
> > 1000 loop checks.  iptables-restore takes away that burden.
> 
> I wish it was that easy, but it was equally slow to me when I tried it a
> long time ago, so my analysis was that this function is called for every
> single rule-insertion even for iptables-restore?

	My profiling of iptables-restore indicates that on my rule set, 
about half of the time is spent memcpy'ing inside insert_rule after the 
handle is recreated. The other half of the time is spent mostly inside 
populate_cache, which is rebuilt after every rule insertion. My test took 
5 minutes to run, of which only 40 seconds were kernel time. Total: 16 
thousand rules, 1000 chains.

	Andre
