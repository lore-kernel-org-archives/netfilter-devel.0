From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_log] Add include needed for integer type
 definition.
Date: Fri, 15 May 2015 20:24:12 +0200
Message-ID: <20150515182412.GA4637@salvia>
References: <1430297458-20973-1-git-send-email-ncopa@alpinelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Natanael Copa <ncopa@alpinelinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59339 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbbEOSTY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 14:19:24 -0400
Content-Disposition: inline
In-Reply-To: <1430297458-20973-1-git-send-email-ncopa@alpinelinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 29, 2015 at 10:50:58AM +0200, Natanael Copa wrote:
> The sys/types.h is needed for u_int*_t types.

Applied.
