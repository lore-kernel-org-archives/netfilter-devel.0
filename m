From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_TCPMSS: correct return value in
 tcpmss_mangle_packet
Date: Wed, 4 Sep 2013 14:57:32 +0200
Message-ID: <20130904125732.GA4542@localhost>
References: <20130901153221.GB10125@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35636 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759384Ab3IDM5g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:57:36 -0400
Content-Disposition: inline
In-Reply-To: <20130901153221.GB10125@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 01, 2013 at 08:32:21AM -0700, Phil Oester wrote:
> In commit b396966c4 (netfilter: xt_TCPMSS: Fix missing fragmentation handling),
> I attempted to add safe fragment handling to xt_TCPMSS.  However, Andy Padavan
> of Project N56U correctly points out that returning XT_CONTINUE in this
> function does not work.  The callers (tcpmss_tg[46]) expect to receive a value
> of 0 in order to return XT_CONTINUE.

Applied, thanks Phil.
