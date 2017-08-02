From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: Remove unused variable in
 compat_copy_entry_from_user()
Date: Wed, 2 Aug 2017 14:26:10 +0200
Message-ID: <20170802122610.GA20955@salvia>
References: <20170729113100.17554-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:51475 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdHBM0n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 08:26:43 -0400
Content-Disposition: inline
In-Reply-To: <20170729113100.17554-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 29, 2017 at 08:31:00PM +0900, Taehee Yoo wrote:
> The target variable is not used in the compat_copy_entry_from_user().
> So It can be removed.

Applied, thanks.
