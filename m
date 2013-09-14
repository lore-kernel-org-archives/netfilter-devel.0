From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipv6: icmpv6_manip_pkt comparing codes to
 types
Date: Sat, 14 Sep 2013 21:24:45 +0200
Message-ID: <20130914192445.GA16387@localhost>
References: <20130913010416.GA8656@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48956 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab3INTZX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:25:23 -0400
Content-Disposition: inline
In-Reply-To: <20130913010416.GA8656@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 12, 2013 at 06:04:16PM -0700, Phil Oester wrote:
> In commit 58a317f1 (netfilter: ipv6: add IPv6 NAT support), icmpv6_manip_pkt
> was added with an incorrect comparison of ICMP codes to types.  This causes
> problems when using NAT rules with the --random option.  Correct the
> comparison.
> 
> This closes netfilter bugzilla #851, reported by Alexander Neumann.

Applied, thanks Phil.
