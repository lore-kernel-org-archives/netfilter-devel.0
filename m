From: Patrick Schaaf <bof@bof.de>
Subject: matching "many of one kind"
Date: Sat, 21 Sep 2002 11:33:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020921093322.GB282@oknodo.bof.de>
References: <638AA0336D7ED411928700D0B7B0D75B03053C9C@aimail.aiinet.com> <20020918221212.GG10465@oknodo.bof.de> <20020920170741.M3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20020920170741.M3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald & all,

> > However, in general, I'm not so sure that it makes sense to expand
> > all kinds of match options into multidimensional specification
> > languages for arbitrary subsets of their keyspaces, with all kinds
> > of option specific shortcut forms for how ranges and patterns are
> > written. Each option becomes its own mini-language. I don't like.
> 
> You seem to be reading my mind.  I already had this issue with the
> multiport match (I never liked it, in fact) - and I have the same 
> trouble with this kind of patches.  Somebody seems to be solving a 
> particular problem (efficiency?) the wrong way.

Do you have an idea about how to solve these efficiency problems?
I think we do have genuine cases on our hands that profit immensely
from such compact specification of more or less large one-dimensional
alternative lists. My ippool extension was born out of one such case,
where a small bitmap can replace hundreds of source or destination
IP specifications. Jay's multi-device-list, with his application
needing to match "one of 100 devices" out of a larger set, is
another good case.

With ippool, I decided to hide the "detailed list of set members"
in the ippool management, i.e. kept it away from normal rule
specification, so the rule management itself does not need a
more complicated API. This "trick" may as well be used for the
device list stuff, or for more complex multiport things (those
would be two new flavors of pools).

Do you know other approaches, maybe more logical / compact /
understandable, that may help us with this general problem?

Or, do you see iptables geared so much towards mainstream usage
that you don't worry too much about those pathologically complex
cases - after all, we proved that we can write our own specialcase
extensions to cover them, anyway. Note that this paragraph is not
meant as a sarcastic snide; such an approach could be taken.

In any case, before the iptables matches and targets become even
more baroque, I'd like to know what the core team things about
these issues.

best regards
  Patrick
