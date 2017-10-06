From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH] nftables: make pointers in string
 arrays constant
Date: Fri, 6 Oct 2017 15:25:02 +0200
Message-ID: <20171006132502.GA17724@salvia>
References: <20171005084647.22988-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42063 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbdJFNZK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 09:25:10 -0400
Content-Disposition: inline
In-Reply-To: <20171005084647.22988-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 05, 2017 at 02:16:47PM +0530, Harsha Sharma wrote:
> static const char * array should probably be static const char *
> const array as per linux-kernel coding style

$ git am /tmp/nftables-make-pointers-in-string-arrays-constant.patch
Applying: nftables: make pointers in string arrays constant
error: patch failed: src/evaluate.c:33
error: src/evaluate.c: patch does not apply

It seems this patch doesn't apply cleanly.

Please, git pull --rebase on your tree and resend this patch.

Thanks.
