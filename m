From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Fri, 13 Jul 2012 10:02:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
 <4FFF6EF2.6010108@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42753 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab2GMIC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:02:28 -0400
In-Reply-To: <4FFF6EF2.6010108@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 13 Jul 2012, Mr Dash Four wrote:

[...]
> JK: "src,src" != "src,dst", but
> JK: with your patches in some cases
> JK: "src,in" == "src,src" or "src,in" != "src,src"
> 
> Me: Could you provide me with an example please? I am intrigued!
> 
> JK: This is ridiculous, as if I haven't provided it countless times:
> JK: list1 src,src
> JK: list1 src,in
> 
> Me: Well, in the above example I fail to see where "src,in" == "src,src" -
> Me: that is *never* the case!
> 
> JK: According to your patches if list1 contains *only* hash:net,iface type of
> JK: setst, then "src,in" == "src,src" because
> JK:
> JK: list1 src,in
> JK:
> JK: is identical in result with
> JK:
> JK: list1 src,src
> JK:
> JK: However, if list1 contains hash:net,iface type of sets *and* other types
> JK: as well, then "src,in" != "src,src" because
> JK:
> JK: list1 src,in
> JK:
> JK: is not identical in result with
> JK:
> JK: list1 src,src

You stated: "I fail to see where "src,in" == "src,src" - that is *never* 
the case!". 

I provided an example, and you simply skipped the answer and made no 
effort to understand it.

> JK: Moreover, "list1" can be updated with new member sets any time, and
> JK: depending on the *syntax*, again, the result may change.
> 
> 09/07/2012
> ~~~~~~~~~~
> Me: You are changing the members of a given set - therefore, the result is
> always
> Me: bound to be different, no matter what. 
[...]

Here again, no effort on your part to understand the case, just a 
ridiculous comment.

Just for you, just for one time, because it seems you do not want to get 
it at all, let the last case *also* be expressed, letter by letter.

Let there be four sets: 

	list1 is list:set type
	ip0 is say hash:ip type 
	netiface0 is hash:net,iface type
	ipport0 is hash:ip,port type

list1 is empty and ip0, netiface0 and ipport0 have got elements.

We have an iptables rule matching list1, which - according to you - could 
be expressed using "src/dst" or "in/out" syntax.

	a. iptables -m set --match set list1 src,dst -j ACCEPT

	OR

	b. iptables -m set --match set list1 src,out -j ACCEPT

1. step

	ipset add list1 ip0

    Rule a. and rule b. produce exactly the same result.

2. step

	ipset add list1 netiface0

    Rule a. and rule b. still produce exactly the same result.

3. step

	ipset add list1 ipport0

    From now on, rule a. and rule b. can produce different results.

4. step

	ipset del list1 netiface0

    Rule a. and rule b. produce again the same result.

That is exactly what I originally wrote, even highlighted the important 
factor: "Moreover, "list1" can be updated with new member sets any time, 
and depending on the *syntax*, again, the result may change."

I'm awaiting your patches. If my comments are handled properly (and no 
other, including coding style mistakes are there), I'll apply them. 
Otherwise your patches will be rejected, with terse comments.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
