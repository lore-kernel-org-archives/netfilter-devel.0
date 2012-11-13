From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 20:24:32 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211132012500.21586@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
 <20121112233024.GA15215@1984> <50A257C8.8050700@earthlink.net> <alpine.DEB.2.00.1211131619040.21144@blackhole.kfki.hu> <50A291BF.70609@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42896 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab2KMTYe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:24:34 -0500
In-Reply-To: <50A291BF.70609@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 13 Nov 2012, Stephen Clark wrote:

> On 11/13/2012 10:25 AM, Jozsef Kadlecsik wrote:
> > On Tue, 13 Nov 2012, Stephen Clark wrote:
> > 
> > > A similar problem exists in the following scenario:
> > > You have two upstream isp that you are doing load balancing by having
> > > multiple
> > > default routes:
> > > default
> > >          nexthop via 66.xxx.xxx.xxx  dev eth1 weight 1
> > >          nexthop via 205.xxx.xxx.xxx  dev eth2 weight 1
> > > On one of the external interface you have a DNAT to
> > > an internal server on a private address. The DNAT makes
> > > a conntrack entry that is going to in effect do a SNAT on reponses
> > > from the internal server back out to the internet, but the load balancing
> > > decision on routing happens before this implicit SNAT so you have packets
> > > trying to go out an interface where the source address does not fall in
> > > the
> > > subnet of that interface.
> > In my opinion this is a broken network design. The DNAT should not depend
> > on the external interface, problem solved.
> >   
> Hmmm... what does this mean ^^^ ?
> Say you have the follwoing:
> eth1 with ips 66.xxx.xxx.1 and 66.xxx.xxx.2
> eth2 with ip 205.xxx.xxx.xxx
> eth0 with ip 10.0.1.254/24
> with a server at 10.0.1.253.
> 
> iptables -A PREROUTING -i eth1 -d 66.xxx.xxx.2 -j DNAT --to-destination
> 10.0.1.253
> 
> How else would you access an internal server at a private address 
> without using a DNAT from an external public ip? Is there some other way 
> to do this that I am not aware of?

Everything depends on your backup provider: does it route the network 
66.xxx.xxx.xxx/y to you or not?

- If the answer is no, then the rule above is correct but the internal 
  server cannot be reached when the backup line is up. So it does not
  matter what's in the conntrack table, no answer is sent over the backup
  link to you.
- If the answer is yes, then the rule should not contain the "-i eth1"
  part and your internal server could be reached as 66.xxx.xxx.2,
  independent of the uplinks.

Best regards,
Jozsef 
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
