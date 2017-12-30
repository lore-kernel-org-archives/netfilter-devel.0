From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] tests: change char * pointer to constant (const
 char *)
Date: Sat, 30 Dec 2017 21:59:09 +0100
Message-ID: <20171230205909.h77npwjewilwijso@salvia>
References: <20171229064939.30699-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750895AbdL3U7N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 15:59:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5011BC9EC4
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Dec 2017 21:59:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4091271C2
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Dec 2017 21:59:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171229064939.30699-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 29, 2017 at 12:19:39PM +0530, Harsha Sharma wrote:
> As the parameter for function is pointer to constant, change it to
> constant. This fix compilation warning in libnftnl with make check.

Applied, thanks.
