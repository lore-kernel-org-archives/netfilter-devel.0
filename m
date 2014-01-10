From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 15:03:40 +0100
Message-ID: <CAKfDRXgcfZW9cNYb4T-f1OAXc1h7XdW1fHHBSZCWeDJ5G6Y7dA@mail.gmail.com>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
	<20140110131406.GA8088@macbook.localnet>
	<CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
	<20140110132703.GA8224@macbook.localnet>
	<CAKfDRXi5v27Tiazb78rA6v7YrAFqXz+kMEZgeE9jJb1whwnYvQ@mail.gmail.com>
	<20140110134342.GA8720@macbook.localnet>
	<20140110135235.GA8797@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43055 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaAJODl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:03:41 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so4493378pbc.39
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 06:03:40 -0800 (PST)
In-Reply-To: <20140110135235.GA8797@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Jan 10, 2014 at 2:52 PM, Patrick McHardy <kaber@trash.net> wrote:
> Just to be clear, I'm not only talking about the naming, a statement
> is something fundamentally different. Every expression has a value,
> which a statement doesn't have. Therefore every expression has a
> a value, destination register, byteorder, ..., all of which don't
> apply to statements. This is why we have an entire separate class
> for this in nftables, and this is what I'm also proposing for
> libnftables.

Thanks for the clarification and I agree. "ct set" is already part of
ct_stmt in nftables, but I was unsure of how to transfer this to
libnftables. I therefor decided to follow meta and store sreg in
nf_expr_ct.

-Kristian
