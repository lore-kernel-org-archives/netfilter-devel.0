From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: Fix connlabel.conf install location
Date: Wed, 12 Jun 2013 09:51:55 +0200
Message-ID: <20130612075155.GA21252@breakpoint.cc>
References: <20130610093544.GA31559@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34817 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab3FLHv6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:51:58 -0400
Content-Disposition: inline
In-Reply-To: <20130610093544.GA31559@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> As reported by Danny Rawlins in bug #828, connlabel.conf is unconditionally
> installed in /etc/xtables instead of using prefix set at configure time.  Fix
> to use sysconfdir variable.

It was intentional.
I don't want userspace to start guessing where the config file is.
