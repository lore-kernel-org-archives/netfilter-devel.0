From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [PATCH] iptables: link libxtables against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 13:36:13 -0300
Message-ID: <520A607D.1010901@zacarias.com.ar>
References: <1376399723-9967-1-git-send-email-gustavo@zacarias.com.ar> <20130813135932.GJ29345@breakpoint.cc> <520A4084.200@zacarias.com.ar> <20130813153234.GL29345@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:59368 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab3HMQgZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:36:25 -0400
In-Reply-To: <20130813153234.GL29345@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/13/2013 12:32 PM, Florian Westphal wrote:

> I can't reproduce it using ld 2.23.1, even with "-Wl,--no-copy-dt-needed-entries".
> 
> Why does libxtables depend on lnf-conntrack?  And why don't you need to add
> libm explicitly?

Actually it doesn't, i've patched in the wrong place even though it
"fixed it" - i'll send a V2 patching xtables-multi instead.

> Yes, but that is with --enable-static.
> 
> The Makefile handles it correctly for statistics and rateest extensions
> (it adds -lm) but not for the connlabel extension.

You can have both --enable-static and --enable-shared at the same time.
It's added in iptables/Makefile* hence my first point, i was barking at
the wrong place :)
Regards.
