From: Florian Westphal <fw@strlen.de>
Subject: Re: [libnetfilter_conntrack PATCH] src/Makefile.am: drop hardcoded
 -ldl
Date: Wed, 21 Jan 2015 01:06:10 +0100
Message-ID: <20150121000610.GA14285@breakpoint.cc>
References: <1421249390-11620-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45296 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbbAUAGM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:06:12 -0500
Content-Disposition: inline
In-Reply-To: <1421249390-11620-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> This breaks static builds where the toolchain completely lacks libdl.

... and I also don't see any reason why we'd need it. So I applied your patch.

Thanks.
