From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: conntrack: Use flags in nf_ct_tmpl_alloc()
Date: Wed, 5 Aug 2015 10:55:06 +0200
Message-ID: <20150805085506.GA3618@salvia>
References: <1438738440-5320-1-git-send-email-joestringer@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Joe Stringer <joestringer@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48677 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbbHEItJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2015 04:49:09 -0400
Content-Disposition: inline
In-Reply-To: <1438738440-5320-1-git-send-email-joestringer@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 06:34:00PM -0700, Joe Stringer wrote:
> The flags were ignored for this function when it was introduced. Also
> fix the style problem in kzalloc.

Applied, thanks Joe.

