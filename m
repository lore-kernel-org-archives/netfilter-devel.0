From: Phil Oester <kernel@linuxace.com>
Subject: Re: /proc and/or /sys file to know if ip_tables is there?
Date: Thu, 28 Nov 2013 08:10:53 -0800
Message-ID: <20131128161053.GA21908@home>
References: <52971A7C.7000505@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50898 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3K1QK4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:10:56 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so12666705pbb.8
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2013 08:10:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <52971A7C.7000505@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 28, 2013 at 12:27:08PM +0200, Tomasz Bursztyka wrote:
> Hi,
> 
> I need to know reliably at runtime whether or not ip_tables is
> either currently loaded as a module or built-in the kernel.
> 
> Testing for /sys/module/ip_tables solves the first issue, but in
> case of built-in it's not usable.
> 
> I could check for ip_tables_* symbols in /proc/kallsyms but I guess
> it's not a nice way.
> 
> Any other proper way?

[ -f /proc/net/ip_tables_names ]

Although built in components will show up in /sys/module/ also.

Phil
