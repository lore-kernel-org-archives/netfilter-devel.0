From: "Christopher Taylor" <chtaylo3@gmail.com>
Subject: Re: reentrant requirement for nfq_callback
Date: Tue, 1 Apr 2008 12:11:53 -0400
Message-ID: <2590773a0804010911l6b9cd33cmdff6ba33e8c4fa78@mail.gmail.com>
References: <2590773a0803311046x72c2e4c5y9a6a49a738f3db74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:39359 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYDAQLy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:11:54 -0400
Received: by an-out-0708.google.com with SMTP id d31so576205and.103
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Apr 2008 09:11:53 -0700 (PDT)
In-Reply-To: <2590773a0803311046x72c2e4c5y9a6a49a738f3db74@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok, I admit that was a rather stupid question.  For the sake of anyone
else googling this later:

1) nfq_callback maps to nfnl_callback and there's no such requirement
on nfnl_callback
2) More obviously, one must provide a response via nfq_set_verdict
(NF_ACCEPT, NF_DROP, NF_STOLEN, etc) before the next invocation of the
callback.

Hope this helps someone else!

-Chris

On Mon, Mar 31, 2008 at 1:46 PM, Christopher Taylor <chtaylo3@gmail.com> wrote:
> I'm assuming that nfq_callback must be reentrant, is this correct?
>
>  Respectfully,
>  Christopher Taylor
>
