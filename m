From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/6] monitor: Fix printing of set declarations
Date: Tue, 25 Jul 2017 17:57:41 +0200
Message-ID: <20170725155741.GA591@salvia>
References: <20170725145629.20974-1-phil@nwl.cc>
 <20170725145629.20974-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38260 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdGYP5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 11:57:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6CBE17D423
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 17:57:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A137BD1CAB
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 17:57:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A76BD1D98
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 17:57:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725145629.20974-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 25, 2017 at 04:56:25PM +0200, Phil Sutter wrote:
> diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
> index d94016beb0767..6ea36cb9d11d6 100644
> --- a/tests/monitor/testcases/set-maps.t
> +++ b/tests/monitor/testcases/set-maps.t
> @@ -2,7 +2,7 @@
>  I add table ip t
>  O add table ip t
>  I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
> -O add map ip t portip { type inet_service : ipv4_addr;flags interval }
> +O add map ip t portip { type inet_service : ipv4_addr;flags interval; }

So the proposal is to remove the whitespace? I think it's more
readable the way it is already.

Unless I'm overlooking anything, please, leave it as it is. Thanks.
