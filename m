From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft crashes on empty interface name
Date: Thu, 23 Nov 2017 14:35:54 +0100
Message-ID: <20171123133554.GA13013@salvia>
References: <CANMOCy0pZS=wWQuuBnUGyah6D4g0_ECstOyhkx=q848DQZBBSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36190 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752907AbdKWNgD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Nov 2017 08:36:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 42C76303D05
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2017 14:36:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33843DA812
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2017 14:36:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CANMOCy0pZS=wWQuuBnUGyah6D4g0_ECstOyhkx=q848DQZBBSw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 23, 2017 at 05:59:51PM +0530, Harsha Sharma wrote:
> Hello,
> This is with reference to bug 1198 reported as "nft crashes on empty
> interface name". Here is a link for the same
> https://bugzilla.netfilter.org/show_bug.cgi?id=1198
> How am I supposed to test this as I just get "syntax error, unexpected
> newline" for empty interface name ?

# nft add rule x y iifname \"\"
nft: evaluate.c:238: expr_evaluate_string: Assertion `strlen(data) >
0' failed.
Abort
