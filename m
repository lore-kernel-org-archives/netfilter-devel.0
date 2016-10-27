From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/4] src: add offset attribute for numgen expression
Date: Thu, 27 Oct 2016 18:57:53 +0200
Message-ID: <20161027165753.GA17733@salvia>
References: <cover.1477170966.git.nevola@gmail.com>
 <37be3c331f27312031dc6541073e44a4a7c1996a.1477170966.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934935AbcJ0Q6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:58:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7523726E08
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:58:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 669FDDA816
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:58:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CDFBDA841
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:57:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <37be3c331f27312031dc6541073e44a4a7c1996a.1477170966.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 22, 2016 at 11:36:07PM +0200, Laura Garcia Liebana wrote:
> Add support to add an offset to the numgen generated value.
> 
> Example:
> 
>  ct mark set numgen inc mod 2 offset 100
> 
> This will generate marks with serie like 100, 101, 100, ...

Applied this patch, thanks Laura.
