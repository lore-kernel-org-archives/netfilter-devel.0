From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH iptables] iptables/Makefile.am: fix more static linking
 issues
Date: Wed, 27 Nov 2013 14:10:10 +0100
Message-ID: <20131127131010.GB10214@breakpoint.cc>
References: <1385555493-25856-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34936 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907Ab3K0NKM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:10:12 -0500
Content-Disposition: inline
In-Reply-To: <1385555493-25856-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> On uClibc-based targets dlfcn.h isn't available when built for
> static-only targets.
> Add up -DNO_SHARED_LIBS when building static so as to guard off the
> include.

Hmmm, it seems simpler to just kill #include <dlfcn.h>
from ip(6)tables-save.c -- I don't see why it would be needed there.
