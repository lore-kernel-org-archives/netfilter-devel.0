From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ipv6: nf_defrag: Kill frag queue on
 RFC2460 failure
Date: Fri, 2 Feb 2018 18:28:15 +0100
Message-ID: <20180202172815.7periot3kisi2ell@salvia>
References: <1517399401-9299-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754195AbeBBR2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Feb 2018 12:28:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C3751F4B8B
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 18:28:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FC81D2CB9
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 18:28:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1517399401-9299-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 31, 2018 at 04:50:01AM -0700, Subash Abhinov Kasiviswanathan wrote:
> Failures were seen in ICMPv6 fragmentation timeout tests if they were
> run after the RFC2460 failure tests. Kernel was not sending out the
> ICMPv6 fragment reassembly time exceeded packet after the fragmentation
> reassembly timeout of 1 minute had elapsed.
> 
> This happened because the frag queue was not released if an error in
> IPv6 fragmentation header was detected by RFC2460.

Applied, thanks Subash.
