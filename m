From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 00/26] ipset patches for nf-next
Date: Tue, 1 Oct 2013 22:07:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1310012130320.1883@blackhole.kfki.hu>
References: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu> <20131001102421.GA5653@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:56428 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3JAUHd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:07:33 -0400
In-Reply-To: <20131001102421.GA5653@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 1 Oct 2013, Pablo Neira Ayuso wrote:

> On Mon, Sep 30, 2013 at 09:50:11PM +0200, Jozsef Kadlecsik wrote:
> > Hi Pablo,
> > 
> > Here follows a huge batch of ipset patches for nf-next. Besides a lot of small
> > fixes and corrections, it contains two new set types, a reworked extensions
> > support with a new extension (per element comments) and netns support.
> > Please consider applying them.
> 
> Pulled, thanks Jozsef!
> 
> Please, could you send me a short summary of changes commenting the 
> patchset? Something similar to what I usually send to David when I make 
> a pull-request would be just fine. Thanks.

Sure, here it comes:

The patchset contains the following fixes and new features for ipset:

* Don't call ip_nest_end needlessly in the error path from me, suggested 
  by Pablo Neira Ayuso.
* Fixed sparse warnings about shadowed variable and missing rcu annotation
  and fix of "may be used uninitialized" warnings, from me.
* Renamed simple macro names to avoid namespace issues, reported by David 
  Laight.
* Use fix sized type for timeout in the extension part, and cosmetic
  ordering of matches and targets separatedly in xt_set.c, from me.
* Support package fragments for IPv4 protos without ports from Anders K. 
  Pedersen. For example this allows a hash:ip,port ipset containing the 
  entry 192.168.0.1,gre:0 to match all package fragments for PPTP VPN 
  tunnels to/from the host. Without this patch only the first package 
  fragment (with fragment offset 0) was matched.
* Introduced a new operation to get both setname and family, from me.
  ip[6]tables set match and SET target need to know the family of the set
  in order to reject adding rules which refer to a set with a non-mathcing
  family. Currently such rules are silently accepted and then ignored
  instead of generating an error message to the user.
* Reworked extensions support in ipset types from me. The approach of
  defining structures with all variations is not manageable as the
  number of extensions grows. Therefore a blob for the extensions is
  introduced, somewhat similar to conntrack. The support of extensions
  which need a per data destroy function is added as well.
* When an element timed out in a list:set type of set, the garbage
  collector skipped the checking of the next element. So the purging
  was delayed to the next run of the gc, fixed by me.
* A small Kconfig fix: NETFILTER_NETLINK cannot be selected and
  ipset requires it.
* hash:net,net type from Oliver Smith. The type provides the ability to 
  store pairs of subnets in a set.
* Comment for ipset entries from Oliver Smith. This makes possible to
  annotate entries in a set with comments, for example:

  ipset n foo hash:net,net comment
  ipset a foo 10.0.0.0/21,192.168.1.0/24 comment "office nets A and B"

* Fix of hash types resizing with comment extension from me.
* Fix of new extensions for list:set type when an element is added
  into a slot from where another element was pushed away from me.
* Introduction of a common function for the listing of the element 
  extensions from me.
* Net namespace support for ipset from Vitaly Lavrov.
* hash:net,port,net type from Oliver Smith, which makes possible
  to store the triples of two subnets and a protocol, port pair in
  a set.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
