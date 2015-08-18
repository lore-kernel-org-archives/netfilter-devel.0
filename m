From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] configure: fix 3rd arg w/AC_ARG_ENABLE
Date: Tue, 18 Aug 2015 08:09:58 +0200
Message-ID: <20150818060958.GA15306@salvia>
References: <1439662415-4374-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33817 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbbHRGDy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 02:03:54 -0400
Content-Disposition: inline
In-Reply-To: <1439662415-4374-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 15, 2015 at 02:13:35PM -0400, Mike Frysinger wrote:
> The 3rd arg is used when --{enable,disable}-foo are passed in, not when
> the feature is enabled.  Use the existing $enableval instead.

Applied, thanks.
