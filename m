From: Florian Westphal <fw@strlen.de>
Subject: Re: [xtables-addons] "unknown option `--gw'" for target TEE
Date: Wed, 25 Nov 2009 10:05:37 +0100
Message-ID: <20091125090537.GC21600@Chamillionaire.breakpoint.cc>
References: <20091125083434.GC4295@lxiv.inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Sebastian =?iso-8859-1?Q?Cla=DFen?=
	<sebastian.classen@freenet.de>, Jan Engelhardt <jengelh@medozas.de>
To: Olivier Mehani <olivier.mehani@inria.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51741 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934443AbZKYJFc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:05:32 -0500
Content-Disposition: inline
In-Reply-To: <20091125083434.GC4295@lxiv.inria.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Olivier Mehani <olivier.mehani@inria.fr> wrote:
> # ip6tables -t mangle -A PREROUTING -i eth0 -j TEE --gw PFX1:46ff:fee0:dfcc
> ip6tables v1.4.5: unknown option `--gw'
> Try `ip6tables -h' or 'ip6tables --help' for more information.

The Documentation is wrong, try "--gateway".
