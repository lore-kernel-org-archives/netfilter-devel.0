From: Jeff Wu <wujiafu@gmail.com>
Subject: Re: [PATCH nf] netfilter: x_tables: speed up jump target validation
Date: Tue, 12 Jul 2016 15:49:43 -0700
Message-ID: <CAOFAV8i3mgJTdhhQjWVhsWLhv3FsAxQZxaNfC7qWKJDkghnH7w@mail.gmail.com>
References: <1468341323-15047-1-git-send-email-fw@strlen.de> <CAOFAV8gh4Bxrt_UG3rog6XoJ--6pYFRUR6FgJtV4ANPgWju=dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34620 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbcGLWu1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 18:50:27 -0400
Received: by mail-io0-f194.google.com with SMTP id g86so1915478ioj.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 15:50:05 -0700 (PDT)
In-Reply-To: <CAOFAV8gh4Bxrt_UG3rog6XoJ--6pYFRUR6FgJtV4ANPgWju=dg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied this patch on Debian 3.16.7-ckt25-2+deb8u3 and it works great!

Jeff

On Tue, Jul 12, 2016 at 1:57 PM, Jeff Wu <wujiafu@gmail.com> wrote:
> Cool! I applied your previous ipv4 only patch(bsearch_offsets.patch)
> on Debian 3.16.36-1 kernel and it works great!
>
> Now, I'm trying this full patch.
>
> Thanks!
>
> Jeff
>
