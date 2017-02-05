From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] statement: Print NAT IPv4 address in nat_stmt_print()
Date: Sun, 5 Feb 2017 21:46:14 +0100
Message-ID: <20170205204614.GC6584@salvia>
References: <20170203185038.GA6536@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdBEUqT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Feb 2017 15:46:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 172C2131CAD
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:46:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08116DA7F7
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:46:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC315DA7E0
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:46:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170203185038.GA6536@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 03, 2017 at 04:50:38PM -0200, Elise Lennion wrote:
> The case which "nat.addr != NULL && nat.proto != NULL && type != ipv6"
> wasn't caught in nat_stmt_print(). Now all cases should be considered.
> 
> Also, the if statements were reorganized to get rid of one nested if.
> 
> Fixes(Bug 1117 - Table ipv4-nat prerouting dnat doesn't accept dest IP:PORT)

Thanks Elise. Florian was very fast to catch this one too.

Let's remember to keep him on Cc so he also knows what you're working
on.
