From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] iptables: set errno correctly in iptcc_chain_index_alloc
Date: Thu, 4 Jul 2013 09:52:17 -0700
Message-ID: <20130704165217.GA12208@linuxace.com>
References: <20130704011610.GA9791@linuxace.com>
 <20130704074222.GC2351@breakpoint.cc>
 <20130704161845.GA11465@linuxace.com>
 <20130704163325.GD2351@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49074 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3GDQwU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:52:20 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc8so1374913pbc.4
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jul 2013 09:52:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130704163325.GD2351@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 04, 2013 at 06:33:25PM +0200, Florian Westphal wrote:
> My point is, that we should not muck with errno, especially
> after libc functions that usually already set it on error.

  # grep -c 'errno = ' libiptc/libiptc.c 
  52

But ok, we can avoid adding yet another instance and drop this patch.

Phil
