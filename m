From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 17:15:01 +0000
Message-ID: <1129050901.3378.17.camel@localhost.localdomain>
References: <20051010164141.GG5627@rama>
	<20051010.141518.60492651.davem@davemloft.net>
	<20051011104446.GJ4290@rama>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051011104446.GJ4290@rama>
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

Op di, 11-10-2005 te 12:44 +0200, schreef Harald Welte:
> On Mon, Oct 10, 2005 at 02:15:18PM -0700, David S. Miller wrote:
> > Ebtables needs it too.  "git grep num_possible_cpus" shows all
> > of the users in the whole tree, %80 of which are the netfilter
> > cases we're fixing here :-)
> 
> mh. I'm not very familiar with the ebtables specific changes, and
> apparently it differs quite a bit in counter handling.

Counters are allocated separately from the rules so that rules don't
need to be duplicated for each cpu. But the fix for ebtables should be
very similar to the one for iptables.

> Anyway, I've tried to come up with a patch that also includes ebtables.
> 
> Bart: Could you please comment on it? If you have missed the previous
> thread: some systems have smp processor id's "0 2" but no "1", e.g.
> num_possible_cpus() is 2 (and we allocate two rulesets), but then we try
> to index it with '2', e.g. the non-existing 3rd copy.

I will once I can see it :)

cheers,
Bart
