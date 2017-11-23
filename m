From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] evaluate: print error for null string befort assert
 statement
Date: Thu, 23 Nov 2017 22:25:51 +0100
Message-ID: <20171123212551.GA22063@breakpoint.cc>
References: <20171123185514.16711-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33136 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753046AbdKWV0y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Nov 2017 16:26:54 -0500
Content-Disposition: inline
In-Reply-To: <20171123185514.16711-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Harsha Sharma <harshasharmaiitr@gmail.com> wrote:
> Print error "Null string is not allowed" before assert statement.
> For e.g.
> nft add rule filter input meta iifname '""'
> Error: Null String is not allowed
> add rule filter input meta iifname ""

Is there any case where "" should be allowed?

If not, I'd rather change scanner.l to not recognize "" as
a quoted string.
