From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH iptables] iptables/ip(6)tables-save.c: remove dlfcn.h
 include
Date: Thu, 28 Nov 2013 23:43:00 +0100
Message-ID: <20131128224300.GC2067@breakpoint.cc>
References: <1385558472-17365-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40251 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab3K1WnD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Nov 2013 17:43:03 -0500
Content-Disposition: inline
In-Reply-To: <1385558472-17365-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> It's not required and breaks on static-only uClibc builds which don't
> have the header file.

Applied, thanks.
