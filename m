From: Patrick Schaaf <bof@bof.de>
Subject: Re: new chain after egress for statistical purpose
Date: Thu, 3 Mar 2005 11:54:30 +0100
Message-ID: <20050303105430.GH31334@oknodo.bof.de>
References: <200503022335.09403.pawlakus@oswiecim.eu.org>
	<20050303061402.GG31334@oknodo.bof.de>
	<57712.62.87.185.5.1109845255.squirrel@oswiecim.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>
To: pawlakus@oswiecim.eu.org
Content-Disposition: inline
In-Reply-To: <57712.62.87.185.5.1109845255.squirrel@oswiecim.eu.org>
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

> Best place for accounting is in the kernel, it's the only way to
> use MARKs, CONNMARKs, etc. so iptables is 'a natural choice'. and it's
> good for this job. just lacks of hopefully-last-chain-before-wire ;)

Hmmmmm. Couldn't you use a setup as described in
	http://ebtables.sourceforge.net/examples.html
under "Filtering with ebtables on interfaces not enslaved to a bridge".
And use ebtables POSTROUTING. Do any shaping on br0, and that should
only see the remaining traffic. Some traffic could still be dropped,
I guess, when the network card won't accept it, but any shaping should
already be done, right? And you could write new ebtables matches /
targets to do fancy accounting.

best regards
  Patrick
