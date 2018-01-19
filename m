From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V5 0/5] netfilter: nf_nat_snmp_basic: use ASN.1 decoder
Date: Fri, 19 Jan 2018 13:57:01 +0100
Message-ID: <20180119125701.azjipcr6g4y5zjg7@salvia>
References: <20180107150917.26020-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43298 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755828AbeASM5H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:57:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6C33DA72B
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:57:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96264DA841
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:57:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180107150917.26020-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 08, 2018 at 12:09:17AM +0900, Taehee Yoo wrote:
> The goal of this patch set are to use the ASN.1 decoder library
> to parse SNMP ASN.1 payload.

Thanks, I'm going to apply to nf-next.

I've been postponing this to schedule time to test this intensively,
but I've been failing to find the time.

Given you've done hard work on this, I'm going to trust you have
tested this intensively, so we get no fallout.

And thanks for your patience.
