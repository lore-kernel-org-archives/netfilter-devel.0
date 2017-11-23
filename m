From: Florian Westphal <fw@strlen.de>
Subject: Re: nft crashes on empty interface name
Date: Thu, 23 Nov 2017 13:54:17 +0100
Message-ID: <20171123125417.GM24866@breakpoint.cc>
References: <CANMOCy0pZS=wWQuuBnUGyah6D4g0_ECstOyhkx=q848DQZBBSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59758 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751911AbdKWMzT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Nov 2017 07:55:19 -0500
Content-Disposition: inline
In-Reply-To: <CANMOCy0pZS=wWQuuBnUGyah6D4g0_ECstOyhkx=q848DQZBBSw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Harsha Sharma <harshasharmaiitr@gmail.com> wrote:
> This is with reference to bug 1198 reported as "nft crashes on empty
> interface name". Here is a link for the same
> https://bugzilla.netfilter.org/show_bug.cgi?id=1198
> How am I supposed to test this as I just get "syntax error, unexpected
> newline" for empty interface name ?

nft add rule filter input meta iifname '""'
nft: evaluate.c:238: expr_evaluate_string: Assertion `strlen(data) > 0' failed.
