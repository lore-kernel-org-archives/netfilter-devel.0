From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 libnftnl] expr: numgen: Rename until attribute by
 modulus
Date: Wed, 7 Sep 2016 15:25:14 +0200
Message-ID: <20160907132514.GA10526@salvia>
References: <20160907122942.GA23647@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37916 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757764AbcIGNZ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 09:25:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 986BF12A690
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 15:25:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8700B100A66
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 15:25:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7ED82100A7C
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 15:25:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160907122942.GA23647@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 07, 2016 at 02:29:45PM +0200, Laura Garcia Liebana wrote:
> The _modulus_ attribute will be reused as _until_, as it's similar to
> other expressions with value limits (ex. hash).
> 
> Renaming is possible according to the kernel module ntf_numgen that has
> not been released yet.

Applied, thanks Laura.
