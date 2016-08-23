From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2 1/2] xtables-translate: add escape_quotes
 option to comment_xlate
Date: Tue, 23 Aug 2016 14:04:08 +0200
Message-ID: <20160823120408.GA27577@salvia>
References: <20160822105615.32483-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753542AbcHWMEN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 08:04:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ACBA4B6C7E
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:04:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C2D5100A7A
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:04:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C5A4100A76
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 14:04:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160822105615.32483-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 12:56:14PM +0200, Pablo M. Bermudo Garay wrote:
> The comment_xlate function was not supporting this option that is
> necessary in some situations.

Applied, thanks.
