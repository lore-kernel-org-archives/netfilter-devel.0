From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools v2] ipv6: remove use of
 HAVE_INET_PTON_IPV6
Date: Tue, 6 Jun 2017 17:37:57 +0200
Message-ID: <20170606153757.GA3791@salvia>
References: <20170529162523.GA22681@salvia>
 <1496130986-27403-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751391AbdFFPiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 11:38:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 477771F4B6F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:37:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3897FFF6F0
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:37:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49D0BFF6F0
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:37:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496130986-27403-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 30, 2017 at 09:56:26AM +0200, Nicolas Dichtel wrote:
> The goal of this patch is to fix the ipv6 support when conntrackd is
> cross-compiled. The AC_RUN_IFELSE macro must be avoided as much as possible.
> See section 6.6 of the gnu autoconf:
> "If you really need to test for a runtime behavior while configuring, you can
>  write a test program to determine the result, and compile and run it using
>  AC_RUN_IFELSE. Avoid running test programs if possible, because this prevents
>  people from configuring your package for cross-compiling."
> 
> Let's remove this check and test the returned error to handle the case where
> ipv6 is not supported (inet_pton() returns -1 when the family is not supported).

Applied, thanks Nicolas.
