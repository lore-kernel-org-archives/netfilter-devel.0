From: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 2/2 RFC] Remove Libc5 support code
Date: Mon, 4 May 2015 12:48:09 +0200
Message-ID: <20150504104809.GH22481@breakpoint.cc>
References: <20150502195138.GB17994@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Felix Janda <felix.janda@posteo.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45625 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbbEDKsL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 06:48:11 -0400
Content-Disposition: inline
In-Reply-To: <20150502195138.GB17994@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Felix Janda <felix.janda@posteo.de> wrote:
> Current code makes the assumption that !defined(__GLIBC__) means libc5
> which is very unlikely the case nowadays.
> 
> Fixes compile error because of conflict between kernel and musl headers.
> ---
> If libc5 is considered still relevant, I could try to come up with an
> autoconf test.

I'm all for removing libc5 support if this is whats preventing iptables
to be built with current non-glibc systems.

Pablo, Patrick, Eric, Jozsef - whats your take on this?
