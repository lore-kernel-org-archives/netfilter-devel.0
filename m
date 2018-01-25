From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] configure: Remove macro AC_CHECK_FUNCS
Date: Thu, 25 Jan 2018 20:49:38 +0100
Message-ID: <20180125194938.czzacqrktyetfhrm@salvia>
References: <20180125151853.4740-1-rvarsha016@gmail.com>
 <20180125151853.4740-2-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751108AbeAYTtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jan 2018 14:49:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 06679209907
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 20:49:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC1C9DA729
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 20:49:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180125151853.4740-2-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 25, 2018 at 08:48:53PM +0530, Varsha Rao wrote:
> Functions memmove, strchr, strerror and strdup are defined in string.h
> header file. Also, strtoull is defined in stdlib.h header file. These
> header files are checked by AC_CHECK_HEADERS macro. AC_CHECK_FUNCS macro
> is not required, so remove it.

Also applied, thanks.
