From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 14:33:06 +0100
Message-ID: <CAKfDRXi5v27Tiazb78rA6v7YrAFqXz+kMEZgeE9jJb1whwnYvQ@mail.gmail.com>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
	<20140110131406.GA8088@macbook.localnet>
	<CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
	<20140110132703.GA8224@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47788 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaAJNdH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:33:07 -0500
Received: by mail-pb0-f46.google.com with SMTP id md12so4413519pbc.5
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 05:33:06 -0800 (PST)
In-Reply-To: <20140110132703.GA8224@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Jan 10, 2014 at 2:27 PM, Patrick McHardy <kaber@trash.net> wrote:
> No, I'm refering to the (ab)use of the expression. Anything not returning
> data is not an expression but a statement.

Ok, then I follow :) I followed the naming in meta, but I agree. What
would be a good naming convetion? I thought of something like
nft_expr_stmt_*. It is a bit clumsy, but it is at least clear that the
struct can be used to represent both an expression and a statement.

-Kristian
