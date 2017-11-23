From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft crashes on empty interface name
Date: Thu, 23 Nov 2017 14:36:08 +0100
Message-ID: <20171123133608.GB13013@salvia>
References: <CANMOCy0pZS=wWQuuBnUGyah6D4g0_ECstOyhkx=q848DQZBBSw@mail.gmail.com>
 <20171123125417.GM24866@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsha Sharma <harshasharmaiitr@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752985AbdKWNgO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Nov 2017 08:36:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 55BAE303D08
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2017 14:36:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47F98DA872
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2017 14:36:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171123125417.GM24866@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 23, 2017 at 01:54:17PM +0100, Florian Westphal wrote:
> Harsha Sharma <harshasharmaiitr@gmail.com> wrote:
> > This is with reference to bug 1198 reported as "nft crashes on empty
> > interface name". Here is a link for the same
> > https://bugzilla.netfilter.org/show_bug.cgi?id=1198
> > How am I supposed to test this as I just get "syntax error, unexpected
> > newline" for empty interface name ?
> 
> nft add rule filter input meta iifname '""'
> nft: evaluate.c:238: expr_evaluate_string: Assertion `strlen(data) > 0' failed.

Sorry, I haven't seen you've replied :-)
