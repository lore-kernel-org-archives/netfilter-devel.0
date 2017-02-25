From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] libiptc: don't set_changed() when checking rules with
 module jumps
Date: Sat, 25 Feb 2017 11:59:46 +0100
Message-ID: <20170225105946.GA6596@salvia>
References: <1487960119.27698.11.camel@redhat.com>
 <1487960755.27698.15.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Dan Williams <dcbw@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58464 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdBYLBJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 06:01:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3CEACA4178
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:59:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D62CDA7F7
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:59:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D13EDA7F7
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 11:59:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1487960755.27698.15.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 24, 2017 at 12:25:55PM -0600, Dan Williams wrote:
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Please, add a description to this patch, explaining why we need this
and so on.

Thanks.
