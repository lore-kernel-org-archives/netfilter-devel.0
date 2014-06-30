From: Florian Westphal <fw@strlen.de>
Subject: Re: Starting point in netfilter development
Date: Mon, 30 Jun 2014 17:22:45 +0200
Message-ID: <20140630152245.GC9515@breakpoint.cc>
References: <CAFgy_YLvGwc3y3R3vv0hdTPsQ+yX7eUW8YUppef9xJQsdH9frw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Quentin Headen <qheaden@phaseshiftsoftware.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39545 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167AbaF3PWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:22:46 -0400
Content-Disposition: inline
In-Reply-To: <CAFgy_YLvGwc3y3R3vv0hdTPsQ+yX7eUW8YUppef9xJQsdH9frw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Quentin Headen <qheaden@phaseshiftsoftware.com> wrote:
> * Is there an active IRC channel for netfilter developers?

Not that I am aware of.  There is #netfilter on freenode,
sometimes developers are also on this channel though its mostly
dealing with end-user questions.

> * When pulling repository changes, do I use git.netfilter.org, or the
> main Linux kernel git repo?

nf.git and nf-next.git from kernel.org. git.netfilter.org
mostly hosts the userspace tools like iptables/nftables
and the associated libraries.

> * Where is a good place for me to get started with netfilter contributions?

It depends on wheter you want to focus on kernel or userspace,
and on what area you'd like to work on.

nftables is currently under active development; f.e. you could
add one of the missing iptables extensions such as hashlimit
or nfacct.

At least for hashlimit I suspect that an nftables equivalent should
not 'copy' hashlimit to nftables but instead take advantage
of nftables' architecture by e.g. using register(s) as input
(as compared to the packet).

Would avoid avoid adding all the hashlimit-mode/src-mask options
from the iptables match in the nft version, and it would be more
flexible because the data extraction/compaction would be in userspace.

Alternatively, you could look at the open bug reports/feature wishlist
items:
http://bugzilla.netfilter.org/buglist.cgi?product=nftables&component=nft&resolution=---

> * Is there any bug tracking done outside of the mailing list?

There is bugzilla.netfilter.org that some people use.
