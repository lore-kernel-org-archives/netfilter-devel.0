From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3] build: add --with-mini-gmp switch to disable linking
 libgmp
Date: Thu, 8 Jan 2015 12:26:36 +0100
Message-ID: <20150108112636.GA10236@salvia>
References: <1420700074-13333-1-git-send-email-cyrus@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Steven Barth <cyrus@openwrt.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54501 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbbAHLXs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:23:48 -0500
Content-Disposition: inline
In-Reply-To: <1420700074-13333-1-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 08, 2015 at 07:54:34AM +0100, Steven Barth wrote:
> This allows to disable linking the >400 KB big libgmp and replace it
> with the builtin mini-gmp which only increases size by ~30KB.
> 
> Enabling this selectively decreases debugging verbosity (pr_debug).

Applied, thanks Steven.
