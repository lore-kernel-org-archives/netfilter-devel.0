From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 20:54:05 +0000
Message-ID: <20140106205405.GA3236@macbook.localnet>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
 <20140106170523.GA9894@breakpoint.cc>
 <20140106171523.GC23002@macbook.localnet>
 <CAKfDRXir46pGb8-YpdW54RMgkdB11YEmqR_VNMJd3CTJKEo6TQ@mail.gmail.com>
 <20140106181928.GA19666@macbook.localnet>
 <CAKfDRXgPaCic9=qxSc5G=QvoX7xti3z8ii94ysBLwRrm4hDy3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56933 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbaAFUyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:54:16 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXgPaCic9=qxSc5G=QvoX7xti3z8ii94ysBLwRrm4hDy3Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 08:25:39PM +0100, Kristian Evensen wrote:
> On Mon, Jan 6, 2014 at 7:19 PM, Patrick McHardy <kaber@trash.net> wrote:
> >
> > Not sure what you're trying to achieve, we already support the connmark
> > in the ct expression:
> >
> > nft filter output ct mark 0x1 ...
> 
> What I want to achieve is to have functionality similar to connmark
> --save-mark, so that we can also set the connmark.

I see. We need a meta statement for this in userspace and corresponding
support for the kernel. I thought we'd had an example how to do this in
the meta expression, but apparently this is wrong. I'll add it for the
meta expression during the next days so you have a reference.
