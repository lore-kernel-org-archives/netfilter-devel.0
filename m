From: Glen Miner <shaggie76@hotmail.com>
Subject: iptables at scale
Date: Wed, 11 Mar 2015 15:10:01 -0400
Message-ID: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from snt004-omc1s50.hotmail.com ([65.54.61.87]:52832 "EHLO
	SNT004-OMC1S50.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbbCKTPD convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 15:15:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We built a proxy system on top of netfilter for our online game; it wor=
ks pretty well but we've run into some problems at scale that I thought=
 you might be interested in. I'm also keenly interested in any feedback=
 or suggestions that you may have for scaling higher because the market=
s we're moving into need a lot more proxies than iptables can handle ri=
ght now.

What it does: makes UDP NAT proxies so people with strict-NAT or multi-=
layer NAT can communicate. This essentially works out to be 4 iptables =
rules created for a pair of peers. They talk to our server and our serv=
er makes it look like they're talking to each other; fighting bad NAT w=
ith our NAT is somewhat ironic but it's quite elegant.

The good: the system load scales *very* well -- we have it servicing th=
ousands of players and 40+mbit of game traffic on a single node right n=
ow and the CPU is 95% idle.

The bad: under load we're creating or deleting rules 10-20 times per se=
cond and want to scale that much higher.=A0

Our initial implementation used sudo iptables however this had consider=
able overhead; we were able to cut that time in half by converting 4 ip=
tables calls into 1 iptables-restore with noflush. We then rewrote our =
server to run as root and use the native iptc APIs (knowing full well w=
e're at the mercy of things changing) and this made things about 20x fa=
ster.

The ugly: as the number if iptables rules increases the time required t=
o modify the table grows. At first this is linear but it starts to go s=
uper-linear after about 16,000 rules or so;=A0=A0I assume it's blowing =
out a CPU cache.

Here's some real world numbers for creation time (again, note 1 proxy =3D=
 4 iptables rules)

The first 100 proxies take under 1ms each
At 750 proxies we're seeing them take 10ms each
At 4000 proxies we're at 70ms each
At 5000 proxies we're at 100-160ms each (it's erratic)

I can post a graph somewhere if people want to see it.

I did a bit of timing; for the 1st proxy created it's very fast:

104us iptc_init
19us=A0=A02x iptc_insert_entry and 2x iptc_append_entry
50us ipc_commit
65us iptc_free

At the 5000 proxy / 20,000 rule mark the timings are nearly 1000x longe=
r; note timings are in=A0milliseconds instead of=A0microseconds:

38 ms for iptc_init("nat");
0.05 ms for 2x iptc_insert_entry and 2x iptc_append_entry
72 ms for iptc_commit
5.5 ms for iptc_free

My test machine is an old Intel(R) Pentium(R) D =A0CPU 2.66GHz (obvious=
ly we use big iron for production servers) and I've observed the same s=
caling problems in production.

At this point I'm getting desperate and am questioning my sanity -- loo=
king at the iptc interfaces I just don't see how I could improve things=
 -- even the allocator overhead for 20,000 rules is painful. The best I=
 can do is a whole lot of async back flips to batch up operations that =
have accumulated while we were grinding in iptc_* and try to flush them=
 through in a single init/commit -- I might be eating over 100ms of lat=
ency per batch but I might be able to sustain a higher throughput.

Will nftables scale any better? I'm not sure how much headache it would=
 be to ride the bleeding edge but if that's what it takes I'll do it.=A0

Is there any way to shard the tables so that I can operate on smaller s=
lices? I'm sure the answer here is 'no.'

I haven't looked at libiptc's internals -- I assume the problem is the =
current pattern of 'get it all, modify it, put it all back.' I'm guessi=
ng that since nobody has yet made it support incremental changes that t=
his is probably not easy.

Thoughts, suggestions and criticism welcome.

-g



 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
