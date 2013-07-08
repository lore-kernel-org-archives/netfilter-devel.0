From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: Sort table names in ip[6]tables-save
Date: Mon, 8 Jul 2013 04:39:19 +0200
Message-ID: <20130708023919.GA14122@localhost>
References: <20130703042912.GA12864@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, zenczykowski@gmail.com
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52469 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3GHCke (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:40:34 -0400
Content-Disposition: inline
In-Reply-To: <20130703042912.GA12864@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 03, 2013 at 12:29:12AM -0400, Phil Oester wrote:
> Depending upon the load order of rules, the output from ip[6]tables-save
> will vary, as ip[6]_tables_names is sorted LIFO.  As reported by
> Linus van Geuns, this makes comparing output from ip[6]tables-save across
> reboots difficult.  Fix this by sorting table names prior to walking
> the tables, making output consistent.

Better add an option to explicitly request the sorting, so we stick to
the old behaviour by default.

But, how can the unsorted table output be useful?
