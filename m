From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: Fix one compile error and some warnings
Date: Thu, 29 Oct 2015 20:46:24 +0100
Message-ID: <20151029194624.GA1741@salvia>
References: <BAY403-EAS15678F56E2C8951B1197C5095200@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58299 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbbJ2TjN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 15:39:13 -0400
Content-Disposition: inline
In-Reply-To: <BAY403-EAS15678F56E2C8951B1197C5095200@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 29, 2015 at 11:59:09PM +0800, Feng Gao wrote:
> The nf_conntrack_sip.c was not compiled with last patch.
> So I fail to find there was one compile error.
> Now I fix it and some compile warnings.

I didn't apply this, so the prefered way when changes are requested
is to send a new patch indicating the version number in the subject,
eg.

        [PATCH v2] netfilter: Add nf_conntrack_helpers_register()

But I would like to have the nf_ct_helper_init() patch in first place.

Thanks.
