From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Fix connlabel.conf install location
Date: Wed, 12 Jun 2013 10:04:14 +0200
Message-ID: <20130612080414.GA8135@localhost>
References: <20130610093544.GA31559@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35109 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3FLIET (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:04:19 -0400
Content-Disposition: inline
In-Reply-To: <20130610093544.GA31559@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 10, 2013 at 05:35:44AM -0400, Phil Oester wrote:
> As reported by Danny Rawlins in bug #828, connlabel.conf is unconditionally
> installed in /etc/xtables instead of using prefix set at configure time.  Fix
> to use sysconfdir variable.
> 
> This closes bugzilla #828.

Applied, thanks Phil.
