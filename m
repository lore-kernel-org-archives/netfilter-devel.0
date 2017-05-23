From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3] List handles of added rules if requested
Date: Tue, 23 May 2017 23:05:50 +0200
Message-ID: <20170523210550.GA5247@salvia>
References: <20170519114532.4484-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161597AbdEWVGK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 17:06:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D825E1227
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:06:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E12BFF2CF
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:06:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43199FC3DB
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:05:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170519114532.4484-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 01:45:32PM +0200, Phil Sutter wrote:
> Changes since v2:
> - Introduce --echo flag to turn the feature explicitly on instead of
>   reusing --handle option.
> - Don't add NLM_F_ECHO to flags if echo_output is not enabled.

BTW, please, update manpage to document this new option. Thanks.
