From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset type "expire"
Date: Thu, 19 May 2005 21:09:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505192036030.12768@blackhole.kfki.hu>
References: <20050519132414.GH6159@clifford.at>
	<Pine.LNX.4.58.0505191553010.12421@blackhole.kfki.hu>
	<20050519150406.GH30011@ns.snowman.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20050519150406.GH30011@ns.snowman.net>
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

On Thu, 19 May 2005, Stephen Frost wrote:

> * Jozsef Kadlecsik (kadlec@blackhole.kfki.hu) wrote:
> > | A new set type called 'iptree' (inspired and triggered by Clifford
> > | Wolf) added, which makes possible to store IP addresses which
> > | automatically time out. Please note, this is an initial new feature with
> > | some hardcoded parameter (like the frequency of garbage collection) and
> > | thus may change in the future.
>
> Stupid question, does this now do everything ipt_recent does but better?

iptree type of ipset does not have anything equivalent with --seconds,
--hitcount or -rttl of recent match. Also, if an address is in the set
and there is an attemtp to add it again, it's equivalent with --update.
Otherwise one can implement about the same kind of things using either of
them.

> I certainly don't mind my module being depreciated in favor of this
> provided it's better/faster/etc.  ipt_recent didn't need to implement
> garbage collection, but perhaps that means you're able to support a
> larger number of IP addresses than ipt_recent could?  Is it hash-based?
> Are the set/check/update rules able to do the same thing?

iptree uses a natural tree to store the IP addresses: for example
when 168.1.2.3 stored alone from 168.1.2.0/24, it looks like

0. level [0,..,168,...255]
1. level        |-> [0,1,....255]
2. leve                |-> [0,1,2,...255]
3. level                        |-> [0,0,0,timeout,0,...0]

At checking the tree is walked and just the timeout value is compared.
Therefore in order to get rid of "empty" levels or branches, garbage
collection is initiated from time to time.

I think they are like apple and pear :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
