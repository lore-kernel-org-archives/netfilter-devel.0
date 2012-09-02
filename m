From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] pgsql: add SSL connection implementation to PGSQL
 plugin
Date: Mon, 3 Sep 2012 01:32:28 +0200
Message-ID: <20120902233228.GA22069@1984>
References: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Eric Leblond <eric@regit.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59545 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab2IBXce (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Sep 2012 19:32:34 -0400
Content-Disposition: inline
In-Reply-To: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 01, 2012 at 01:51:51PM +0100, Mr Dash Four wrote:
> This patch fixes a NULL pointer reference bug which existed in the
> PGSQL output plugin, as well as enables SSL connections to be made
> to PostgreSQL server by the ulog daemon.

I won't take a patch that fixes a NULL pointer dereference and adds a
new feature.

Please, split this in two patches. First fix the bug, then add the new
fature.

Thanks.
