From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2 1/2] iptables: remove duplicated argument
 parsing code
Date: Fri, 17 Mar 2017 14:14:34 +0100
Message-ID: <20170317131434.GB12186@salvia>
References: <20170316075502.2337-1-lorenzo@google.com>
 <20170316075502.2337-2-lorenzo@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jscherpelz@google.com,
        subashab@codeaurora.org, zlpnobody@gmail.com
To: Lorenzo Colitti <lorenzo@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751010AbdCQNZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 09:25:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21680FB431
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:14:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06FBBDA865
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:14:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BFCDDDA3AC
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:14:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170316075502.2337-2-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 16, 2017 at 04:55:01PM +0900, Lorenzo Colitti wrote:
> 1. Factor out repeated code to a new xs_has_arg function.
> 2. Add a new parse_wait_time option to parse the value of -w.
> 3. Make parse_wait_interval take argc and argv so its callers
>    can be simpler.

Also applied, thanks Lorenzo.
