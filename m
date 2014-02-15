From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sat, 15 Feb 2014 14:36:13 +0100
Message-ID: <20140215133613.GB28751@breakpoint.cc>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net
To: Nikolay Aleksandrov <nikolay@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51034 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbaBONgQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:36:16 -0500
Content-Disposition: inline
In-Reply-To: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nikolay Aleksandrov <nikolay@redhat.com> wrote:
> The new "write" expression can be used to manipulate packet data.

Thanks.  This is very useful feature (needed also for TCPMSS mangling
for instance).

General question: How are/should packet checksums be handled after packet
content was altered?
