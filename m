From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nf-next 0/1] payload mangling support
Date: Mon, 9 Nov 2015 16:30:29 +0100
Message-ID: <20151109153029.GA7759@breakpoint.cc>
References: <1447078234-21628-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54299 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbbKIPac (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 10:30:32 -0500
Content-Disposition: inline
In-Reply-To: <1447078234-21628-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> So the main questions is basically, do we want to support stateless NAT?
> The downside is that we have to add protocol specific checksumming functions.

For now i'm only be interested in mangling MAC addresses for nft bridge
to provide ebtables snat/dnat/redirect equivalents.
