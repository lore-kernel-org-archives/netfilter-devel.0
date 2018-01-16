From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions : multiple to-dst/to-src arguments for
 ip6t_DNAT/SNAT not reported
Date: Tue, 16 Jan 2018 14:06:12 +0100
Message-ID: <20180116130612.iwzo3kbff7a7oobb@salvia>
References: <65034694-62fb-3e6a-b15c-1176e65eae65@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thierry Du Tre <thierry@dtsystems.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52846 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbeAPNGU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 08:06:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB720172C7E
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 14:06:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF01ADA81C
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 14:06:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <65034694-62fb-3e6a-b15c-1176e65eae65@dtsystems.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Thierry,

On Tue, Jan 16, 2018 at 01:44:37PM +0100, Thierry Du Tre wrote:
> This patch is fixing the detection of multiple '--to-destination' in a DNAT rule and '--to-source' in SNAT rule for IPv6.
> Currently, when defining multiple values for these, only the last will be used and others ignored silently.
> 
> The checks for (cb->xflags & F_X_TO_[DEST/SRC]) always fails because the flags are never set before.
> It seems to be a copy-paste artefact since introduction of the IPv6 DNAT/SNAT extensions based on IPv4 code.
> 
> I also removed the kernel_version checks because they seem useless. Extensions for IPv6 DNAT/SNAT are using xt_target with revision 1.
> That seems only added since kernel version 3.7-rc1 and therefore the check for > v2.6.10 will always return true.
> The check is probably also coming from the IPv4 copy-paste.

Thanks for fixing up this.

Would you also send us a patch to add tests:

        extensions/libip6t_DNAT.t
