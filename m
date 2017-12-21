From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: Add macro _DEFAULT_SOURCE.
Date: Thu, 21 Dec 2017 09:10:03 +0100
Message-ID: <20171221081003.egaje2brytnfrspg@salvia>
References: <20171221033545.2676-1-rvarsha016@gmail.com>
 <20171221033545.2676-2-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbdLUIKI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Dec 2017 03:10:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58CF0B6B84
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:10:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A4E31150A7
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:10:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171221033545.2676-2-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 21, 2017 at 09:05:45AM +0530, Varsha Rao wrote:
> Define _DEFAULT_SOURCE as _BSD_SOURCE is deprecated.
> https://sourceware.org/glibc/wiki/Release/2.20#Packaging_Changes
> 
> This patch fixes the following warning:
> 
> warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use
> _DEFAULT_SOURCE" [-Wcpp]
>  # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use
>  # _DEFAULT_SOURCE"

Also applied, thanks.
