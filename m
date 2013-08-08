From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: state match incompatibilty across versions
Date: Thu, 8 Aug 2013 18:16:03 +0200
Message-ID: <20130808161603.GA7525@localhost>
References: <20130807234449.GA22535@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ljlane@debian.org,
	jengelh@medozas.de
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55738 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934213Ab3HHQQR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:16:17 -0400
Content-Disposition: inline
In-Reply-To: <20130807234449.GA22535@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 04:44:49PM -0700, Phil Oester wrote:
> As reported in Debian bug #718810 [1], state match rules added in < 1.4.16
> iptables versions are incorrectly displayed by >= 1.4.16 iptables versions.
> Issue bisected to commit 0d701631 (libxt_state: replace as an alias to
> xt_conntrack).
> 
> Fix this by adding the missing .print and .save functions for state match
> aliases in the conntrack match.

The problem seems to be related with xtables_mt_prefer, which ranks
the conntrack match higher than state match itself, as it treats state
as an alias. This is OK in the userspace to kernel path, where state
is internally transformed to conntrack, but not from kernel to
userspace, where the state match info is being interpreted by the
conntrack match.

We could fix this from libxtables, but adding some parameter to
xtables_find_match to indicate what path this function is called from.
But that requires a new ABI change to resolve it, which will break
Jamal's tc action again, I guess stephen will not be very happy with
it.

I'm going to take your patch, it's simple and it fixes this issue.

Thanks Phil.
