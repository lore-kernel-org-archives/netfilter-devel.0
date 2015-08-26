From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libiptc: fix fortify errors in debug code
Date: Wed, 26 Aug 2015 21:09:26 +0200
Message-ID: <20150826190926.GB23435@salvia>
References: <1440069179-21334-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51211 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbbHZTDJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 15:03:09 -0400
Content-Disposition: inline
In-Reply-To: <1440069179-21334-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 20, 2015 at 07:12:59AM -0400, Mike Frysinger wrote:
> When using open(O_CREAT), you must supply the mode bits, otherwise the
> func will pull random garbage off the stack.

Also applied, thanks.

