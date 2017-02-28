From: Florian Westphal <fw@strlen.de>
Subject: Re: nft authentication
Date: Wed, 1 Mar 2017 00:24:51 +0100
Message-ID: <20170228232451.GA24798@breakpoint.cc>
References: <e7b26751-8914-e32e-0760-c300bf217b50@students.fh-hagenberg.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Fabian Franz <s1410239008@students.fh-hagenberg.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36346 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751623AbdB1X5T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 18:57:19 -0500
Content-Disposition: inline
In-Reply-To: <e7b26751-8914-e32e-0760-c300bf217b50@students.fh-hagenberg.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Franz <s1410239008@students.fh-hagenberg.at> wrote:
> I am working on my module but I cannot get the match visible to the nft
> tool. Could you please give me a hint, what is wrong in the code? I have
> uploaded it to my web server: http://files.fabian-franz.eu/nft_auth.c

I do not know what 'visible to the nft tool' means.
No 'obvious' mistake in the register department.

My only comment is that it looks like you are re-inventing the wheels
we already have, such as nf_log and nf_queue.

If this is a learning exercise, fine, but we have real missing
functionality that could be added instead.

If this targets upstream, you should really discuss what problem wants
to be solved.  The building blocks we already have should be enough
to do uid based authentication.

(something like
 nf_log/queue -> userspace daemon -> query -> update nft set w. uid)
