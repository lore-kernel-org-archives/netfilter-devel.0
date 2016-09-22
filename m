From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 libnftnl] expr: numgen: add number generation offset
Date: Thu, 22 Sep 2016 16:36:44 +0200
Message-ID: <20160922143644.GB6409@salvia>
References: <20160913115038.GA15797@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52958 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752286AbcIVOgz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:36:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8A4D9D344
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:36:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7F9FDA7FA
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:36:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB22BDA816
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:36:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160913115038.GA15797@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 13, 2016 at 01:50:41PM +0200, Laura Garcia Liebana wrote:
> Add support to pass through an offset value to the counter
> initialization. With this feature, the sysadmin is able to apply a value
> to be added to the generated number.
> 
> Example:
> 
> 	meta mark set numgen inc mod 2 offset 100
> 
> This will generate marks with series 100, 101, 100, 101, ...

Also applied, thanks.
