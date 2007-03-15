From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: NF structural changes (was: dangerous?)
Date: Thu, 15 Mar 2007 03:24:19 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703150227420.1199@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
	<45F8637D.3060600@trash.net>
	<Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
	<45F86D93.3030004@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F86D93.3030004@ufomechanic.net>
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


On Mar 14 2007 21:48, Amin Azez wrote:
> I think its fine. I still miss filter/mangle after nat on pre-routing and
> re-suggest merging nat as well.

Hm ok. It is not as if you could not abuse nat _today_ for filtering...
(Yes, it makes perfectly sense to merge nat as well, now that I have 
given it some more thought.)

> As for user-compatability, introduce a new character as a legal chain name,
> maybe @ and then let:
> iptables -t XXX -[AID] YYY
> refer to chain YYY@XXX
> and let there be a global table whose contents when flushed default to:
> -A PREROUTING -j PREROUTING@mangle
> -A PREROUTING -m ctstate --ctstate new -j PREROUTING@nat
> etc

Wanna merge the 'raw' table too - or would that cause increased coding
complexity in netfilter?
The same goes for brouting, which probably needs to stay separate from 
the 'main' table. If they all can be merged, the better.

> But at least lets merge mangle and filter in the medium term (and put 
> one after nat on prerouting?)

Here is the upgraded schematic graph. I have dubbed the 
filter/mangle/nat combo table 'main'.

http://jengelh.hopto.org/GFX0/nf_proposal2.png (.svg)



Jan
-- 
