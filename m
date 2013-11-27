From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [PATCH iptables] iptables/Makefile.am: fix more static linking
 issues
Date: Wed, 27 Nov 2013 10:20:02 -0300
Message-ID: <5295F182.8020604@zacarias.com.ar>
References: <1385555493-25856-1-git-send-email-gustavo@zacarias.com.ar> <20131127131010.GB10214@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:43731 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3K0NUU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:20:20 -0500
In-Reply-To: <20131127131010.GB10214@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/27/2013 10:10 AM, Florian Westphal wrote:

> Hmmm, it seems simpler to just kill #include <dlfcn.h>
> from ip(6)tables-save.c -- I don't see why it would be needed there.

Fair enough, i'll send a revised patch.
Regards.


