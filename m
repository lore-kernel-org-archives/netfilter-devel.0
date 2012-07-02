From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Mon, 2 Jul 2012 09:54:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207020916030.4335@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com> <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
 <4FF04647.7060807@googlemail.com> <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu> <4FF04DDA.3020609@googlemail.com> <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu> <f1ffdaf291ae86a1e111d3edbae4cfa3@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:47661 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2GBHyX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:54:23 -0400
In-Reply-To: <f1ffdaf291ae86a1e111d3edbae4cfa3@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2 Jul 2012, Amos Jeffries wrote:

> As you say Mr Dash Four brings up a good point about confusion. It certainly
> seems to confuse him/her, and very likely others with less documentation
> reading experience.
> 
> IME the practice when this type of thing happens is good to find some
> alternative clear naming for the parameters and to deprecate the old ones.
> That allows the old names to be dropped from documented use, but kept
> supported for existing config with a warning that admin need to check the docs
> for new usage.
> 
> For myself, given the man page snippet it is clear what you intended src/dst
> to be the "local" src/dst. But it is inconsistent with iptables usages of
> src/dst and will trip up anyone not reading that page. Which is not a good
> situation to be in.
> 
> Having been in that situation myself I sympathize and had this same argument
> about the same scope concept with other developers several times now. We
> usually end up using some form of "local" terminology for the box internal
> details to differentiate from end-to-end scope terminology. In this case
> --iface-ip / --oface-ip would probably be the clearest contenders for your
> selection. But that is up to you.

The issue is related to the hash:net,iface type alone and only the 
interface part of the type: which interface is the "source" of the packet 
and which one is the "destination". (There's no problem whatsoevert to 
associate "src" and "dst" to the IP addresses/port/MAC of the packets.)

Maybe ASCII art helps better to explain the different views:

- Mr Dash Four

                     -----------
  pkt comes in ----- | machine | ----- pkt goes out
                   ^ ----------- ^
                 destination   source

- my view follows how the subsytem sees the interfaces

                             ------------------
  pkt comes in --- interface | ipset subsytem | interface --- pkt goes out
                           ^ ------------------ ^
                       source               destination

As we learned, the latter is wrong and inconsistent, moreover buggy.

"src" and "dst" are generic keywords of the set match and SET target of 
iptables/ip6tables and independent of the set types. The match and target 
have no idea what is "src" and "dst", the given set interprets them 
according to the type. 

Also, it is not possible to introduce alternate keywords just for the sake 
of the hash:net,iface, because ipset supports list of sets and in that 
case the underlying sub-types are practically unknown to the match/target 
(and additionally can be changed anytime).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
