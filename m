From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] include: Remove datatype_register().
Date: Fri, 30 Jun 2017 12:45:38 +0200
Message-ID: <20170630104538.GA1876@salvia>
References: <cover.1498814530.git.rvarsha016@gmail.com>
 <b88dbf72f3c57fb3e4d55ddb3685547aedd08b61.1498814530.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47954 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752486AbdF3Kp7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jun 2017 06:45:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8956249D2
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 12:45:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9129D1CAA
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 12:45:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91090B8013
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 12:45:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <b88dbf72f3c57fb3e4d55ddb3685547aedd08b61.1498814530.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 30, 2017 at 02:56:19PM +0530, Varsha Rao wrote:
> Remove datatype_register() function and its calling __init functions.
> Add arguments of datatype_register() function to datatype array.

Applied, thanks Varsha.
