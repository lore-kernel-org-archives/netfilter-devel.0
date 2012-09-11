From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Tue, 11 Sep 2012 17:44:58 +0200
Message-ID: <20120911154458.GB28012@1984>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
 <20120906170253.GA17317@1984>
 <CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46625 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346Ab2IKS6c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:58:32 -0400
Content-Disposition: inline
In-Reply-To: <CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 10, 2012 at 04:24:49PM -0700, Ansis Atteka wrote:
[...]
> >
> >> +
> >> +#ifdef __NR_setns
> >> +
> >> +static int root_fd = -1;
> >
> > This root_fd should go to STATE(ns).root_fd:
>
> Right, it makes more sense to put it inside ct_state for
> now.
> 
> Once conntrackd will become multi-namespace
> aware, we will have to move it somewhere else,
> because all the namespaces(i.e. ct_states) will
> use the same root_fd.

Can you develop a bit more the change that should happen in your
opinion) to conntrackd to support multi-namespace? I'd like to get an
idea before that patch lands on the mailing list.

[...]
> Thanks for review! I will send updated patch soon.

Thanks.
