From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] evaluate: fix export length and data corruption
Date: Mon, 16 Jan 2017 21:49:10 +0100
Message-ID: <20170116204910.GA19547@salvia>
References: <1484573912-23612-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55160 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbdAPUt0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 15:49:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6858E5A43
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 21:49:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6B53A7EE4
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 21:49:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1727FA6D6
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 21:49:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484573912-23612-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 16, 2017 at 02:38:32PM +0100, Florian Westphal wrote:
> Pablo reported that ipv6 tests would fail on some systems:
> WARNING: line: 5: 'src/nft add rule --debug=netlink ip6 test-ip6 input iif "lo" ip6 flowlabel set 0':
> '[ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]' mismatches
> '[ bitwise reg 1 = (reg=1 & 0x00000000 ) ^ 0x00000000 ]'
>                                     ^ should be 'f'
> 
> Problem is that mpz_export_data expects the size of the output
> buffer in bytes, but this gave bit-based size.
> 
> Then, when mpz_export_data clears the output buffer it will
> also clear 8 extra bytes on stack; depending on compiler version (stack
> layout) this will then clear the bitmask value that we want to export.
> 
> Fixes: 78936d50f306c ("evaluate: add support to set IPv6 non-byte header fields")
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

This fixes my tests, thanks Florian.

Tested-by: Pablo Neira Ayuso <pablo@netfilter.org>
