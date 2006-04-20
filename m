From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: Strange MASQUERADING behaviour, bug or feature?
Date: Thu, 20 Apr 2006 12:40:18 +0200 (CEST)
Message-ID: <40417.217.166.60.19.1145529618.squirrel@217.166.60.19>
References: <44440CD2.6060006@rtij.nl> <444610DD.9000807@ufomechanic.net>
	<44466513.8080000@rtij.nl> <4447422A.20704@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4447422A.20704@ufomechanic.net>
To: "Amin Azez" <azez@ufomechanic.net>
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

Amin Azez zei:

> I think that if you could, it would cause you other problems, it is
> harmful/useless to change the source address of TCP connections partway
> through.

It is also useless to reroute a tcp connection through a different
interface with different masquerading while keeping the old masquerading,
so in either case, your tcp connection will not work anymore. If however
only SYNs are sent up till now, changing the source address WOULD work
(from a tcp point of view, not from a conntrack pov).

My thinko was that changing the route (output interface) would make MASQ
tear down the connections, just like when the interface went down and then
up.

> Perhaps you could explain what problem you are trying to solve with this
> method.

Dial on demand, when pppd doesn't cut it. And combine that with
masquerading. It seems to work on 2.6 when I do:
- add masquerading rules for both real and dummy interface
- create dummy interface and route with high metric
- while forever
  - if packets arrive at the dummy interface
    - bring up the real interface
    - add route with normal metric
    - destroy and recreate the dummy interface (so the contracks are
destroyed)

This works more or less, which is enough for me at the moment.
Unfortunately, it does not work on my 2.4 setup, but that's probably a
different issue related to tun/tap  (cannot destroy the dummy interface,
it just lives on).

M4
