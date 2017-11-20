From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: Add test for IPv4 Mapped IPv6 address.
Date: Mon, 20 Nov 2017 14:28:13 +0100
Message-ID: <20171120132813.GA22282@salvia>
References: <20171119123432.8894-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751346AbdKTN2S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 08:28:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA9074DE728
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 14:28:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96BC778439
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 14:28:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171119123432.8894-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 19, 2017 at 06:04:32PM +0530, Varsha Rao wrote:
> This patch adds test case for IPv4 Mapped IPv6 address and renames
> file 0025named_limit_0 to 0026named_limit_0.

Applied, thanks Varsha.

Please, next time, send one patch for each thing. It's a good practise
to stick to one single patch per logical change.

In other words, if you see yourself saying in the patch description
something like: "This patch is doing X and Y", then it means X needs
one single patch for it, and Y another one.

Thanks!
