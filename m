From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] scanner: support for wildcards in include statements.
Date: Tue, 27 Jun 2017 18:11:11 +0200
Message-ID: <20170627161111.GA5969@salvia>
References: <20170627121459.32608-1-ismo.puustinen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ismo Puustinen <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54080 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752371AbdF0QLV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2017 12:11:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8683DEAA60
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 18:11:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76CA5DA840
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 18:11:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71A65DA840
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 18:11:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170627121459.32608-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 27, 2017 at 03:14:58PM +0300, Ismo Puustinen wrote:
> Use glob() to find paths in include statements. The rules are these:
> 
>   1. If no files can be found in the pattern with wildcards, do not
>      return an error.
>   2. Do not match any files beginning with '.'.
>   3. Do not handle include directories anymore. For example, the
>      statement:
>        include "foo/"
>      would now need to be rewritten:
>        include "foo/*"

Applied, thanks Ismo.

P.S: I made some comestic changes to make it fit into the existing
coding style, no issue.
