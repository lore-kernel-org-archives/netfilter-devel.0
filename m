From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.21-rc6] [netfilter] early_drop imrovement
Date: Fri, 06 Apr 2007 17:08:28 +0200
Message-ID: <4616626C.9020100@trash.net>
References: <4615FE1D.80206@sw.ru>
	<20070406102433.d3a670a5.dada1@cosmosbay.com>
	<4616203A.80203@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
To: Vasily Averin <vvs@sw.ru>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4616203A.80203@sw.ru>
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

Vasily Averin wrote:
> No, I've not investigated this scenario. It looks like you are right and my
> patch can leads to a long delays.
> 
> In my experiments I've decreased ip_conntrack_max lower than number of hash
> buckets and got the "table full, dropping packet" errors in logs. I've looked on
> the conntrack list and found a huge number of conntracks that can be freed.
> However my hash bucket was empty and therefore I even did not have any chances
> to free something. That's why I would like to check the other hash buckets too.
> 
> Ok, let's limit the number of conntracks that can be checked inside
> early_drop(). What do you prefer: some round number (for example 100) or
> fraction of ip_conntrack_max (for example 1%)?


A (small) fraction sounds better. We could even consider keeping track
of the number of conntracks that can be evicted (not assured), so in a
DOS situation we could save unnecessary table scans. Not sure if its
worth the effort though.

Anyway, please base your patch on the net-2.6.22 tree, which doesn't
include ip_conntrack anymore.
