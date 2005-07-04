From: Patrick Schaaf <bof@bof.de>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 4 Jul 2005 07:55:42 +0200
Message-ID: <20050704055541.GA29624@oknodo.bof.de>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
	<20050703123650.GW3186@sunbeam.de.gnumonks.org>
	<20050703220525.GA3331@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20050703220525.GA3331@eychenne.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Trying to insert potentially many LOG rules to empirically determine
> the maximum prefix length is far less complex, that's for sure. ;-)

Do we already have indeterminate log prefix length? I thought we had
one, fixed size, no probing neccessary. Am I wrong?

> For now, that's the only way an upper-level tool will produce valid
> LOG rules in all cases.

The way to produce valid log rules in all cases, is to keep this
fancy long long stuff in user level, and set pointer / index values
or whatever small token can be used, for a log prefix in the kernel.

Any scheme which probes the possible length, will also need some
fallback when kernel length is smaller than user desire. If your
goal is 'valid in all cases'. Right? Then you'll need such a
token/pointer approach anyway!

> Probably many of you won't care, but for this kind of upper-layers
> (which I'm particularly concerned with) netfilter/iptables sometimes
> makes it hard to turn "should work" into "will work".
> That LOG thing is only one example, though probably not the best.

Then maybe you could provide a better one?

> > I also don't really like using out-of-band interfaces such as /proc
> > to determine how to communicate rules via {get,set}sockopt()
> 
> Maybe you don't like /proc, but the kernel still has to provide a way
> to inform userspace about the fixed size of some of its data (as
> kernelspace doesn't like dynamic things very much...). If you see a
> better way, that's ok, but the need is still there.

If getsockopt is good to communicate iptables rules and other stuff,
it must be good enough to also communicate 'length of X is Y'...

best regards
  Patrick
