From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/6] build: also use libtool for install stage
Date: Wed, 20 Mar 2013 00:42:13 +0100
Message-ID: <20130319234213.GA4246@localhost>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de>
 <1359381586-11940-2-git-send-email-jengelh@inai.de>
 <20130205033007.GA20407@localhost>
 <20130306110836.GA4017@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab3CSXmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:42:21 -0400
Content-Disposition: inline
In-Reply-To: <20130306110836.GA4017@altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 06, 2013 at 03:08:36PM +0400, Dmitry V. Levin wrote:
[...]
> With regards to libtool's warnings about relinking, it happens to all
> hundreds of packages that manipulate RPATH entries during build, so
> the amount of annoyance among libtool users would hardly increase.

The thing is that the libtool patch for iptables was introduced to
resolve a linking problem in ip6t_NETMAP. That could have been easily
fixed with a little patch by using xtables_ip6mask_to_cidr.

I'm going to post a patch to fix that linking issue that way and roll
back to the previous situation where we were not using libtool.
