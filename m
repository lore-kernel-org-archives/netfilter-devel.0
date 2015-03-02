From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] ruleset: crash in path error when we build
 the xml tree
Date: Tue, 3 Mar 2015 00:28:42 +0100
Message-ID: <20150302232842.GA4160@salvia>
References: <1425322779-6689-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53026 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbbCBXZG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 18:25:06 -0500
Content-Disposition: inline
In-Reply-To: <1425322779-6689-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 07:59:38PM +0100, Alvaro Neira Ayuso wrote:
> Crash when we try to release a tree that is not initialized.

Applied, thanks.
