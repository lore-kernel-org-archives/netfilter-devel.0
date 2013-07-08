From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH v2] iptables: Sort table names in ip[6]tables-save
Date: Sun, 7 Jul 2013 21:21:46 -0700
Message-ID: <20130708042146.GB5532@linuxace.com>
References: <20130703042912.GA12864@gmail.com>
 <20130708023919.GA14122@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, zenczykowski@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3GHEVp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 00:21:45 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so3854326pbb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jul 2013 21:21:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130708023919.GA14122@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 08, 2013 at 04:39:19AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 03, 2013 at 12:29:12AM -0400, Phil Oester wrote:
> > Depending upon the load order of rules, the output from ip[6]tables-save
> > will vary, as ip[6]_tables_names is sorted LIFO.  As reported by
> > Linus van Geuns, this makes comparing output from ip[6]tables-save across
> > reboots difficult.  Fix this by sorting table names prior to walking
> > the tables, making output consistent.
> 
> Better add an option to explicitly request the sorting, so we stick to
> the old behaviour by default.

The old behavior is random depending upon module load order.  We should
keep random behavior?  

> But, how can the unsorted table output be useful?

Ask Maciej - he is the one that requested this be provided as an option.

Phil
