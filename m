From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nf_conntrack & nf_conntrack_ipv4 are not loaded
Date: Fri, 20 Jul 2012 10:07:56 +0200
Message-ID: <20120720080756.GA13680@1984>
References: <CAAJpzgYZm8EzUA+EwwZd=J1hmi4euL+LkJj8x+VRiz2eE8Axcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40448 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab2GTIIA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:08:00 -0400
Content-Disposition: inline
In-Reply-To: <CAAJpzgYZm8EzUA+EwwZd=J1hmi4euL+LkJj8x+VRiz2eE8Axcw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 19, 2012 at 09:02:38PM -0700, Gomathivinayagam Muthuvinayagam wrote:
> The modules nf_conntrack & nf_conntrack_ipv4 are not loaded
> automatically in ulogd.
> It was posted in earlier forums that some code will be written to do this.
> Was there a patch released for the same?

There's already a patch that will be available in 3.6.

It will autoload nf_conntrack and nf_conntrack_netlink.

You still have to load nf_conntrack_ipv4 yourself, there's no way to
know what IPvX tracker you require from the conntrack events
subscription.
