From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 kernel 16/29] add permanent byte/packet format
 capability to nfacct
Date: Wed, 10 Jul 2013 22:00:24 +0200
Message-ID: <20130710200024.GB27468@breakpoint.cc>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-17-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40891 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342Ab3GJUAZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:00:25 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-17-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> * add a 'fmt' variable to each nfacct object, allowing a permanent packets
> and bytes formatting to be stored. The two packet and byte formats are
> independent of each other.

Every other in-kernel byte counter (that I can think of) is a plain u64.

It might help if you'd explain why this is necessary.
