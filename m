From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: BUG: Kernel panic at masquerade
Date: Wed, 14 Jan 2015 18:27:02 +0100
Message-ID: <20150114172702.GA20830@salvia>
References: <54B048D1.6040009@mail.ru>
 <CAOkSjBieyfUV6HMENQcETwcoADT2YMxhgBfv9Kx9kiM8YYAhKA@mail.gmail.com>
 <20150113194111.GB23967@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Linke <linkerpro@mail.ru>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46701 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbbANRYI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:24:08 -0500
Content-Disposition: inline
In-Reply-To: <20150113194111.GB23967@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 13, 2015 at 07:41:12PM +0000, Patrick McHardy wrote:
> Related to this, what also kind of sucks is that you have to manually
> take care of creating the opposite NAT chain (pre/postrouting, in/output)
> to have NAT work properly.

We can add some dependency chains that are automagically installed,
eg. if you install a NAT prerouting chain, then install the
postrouting chain that mirrors. But then, we will be assumming things
on the user configuration, and I think that may results in problems
when some user comes up later with some strange combination that he
cannot achieve because of some automagic configuration we brought up.

> We should make sure that the user can't mess this up.

I'm not so sure, I think we can just make sure users can't crash the
kernel. I mean, there are many ways users can screw it up when
configuring their firewall, they should understand what they are
doing.

> Simlarly we need to prevent to have multiple NAT chains for the same
> hook.

This should be easy to check, yes.

> Generally I think the current NAT chain implementation is very
> wrong. We need to invoke the core functions once for each direction
> if NAT is used independantly of any chains. So they probably
> shouldn't be tied together.

Then, we'll have to register the hooks on some magic priority. The
chains provide the way the user can configure where he wants the NAT
engine to show up.
