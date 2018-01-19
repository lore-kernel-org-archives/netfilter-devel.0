From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] configure: Remove AC_HEADER_STDBOOL, AC_C_ and
 AC_TYPE_ macros
Date: Fri, 19 Jan 2018 13:05:45 +0100
Message-ID: <20180119120545.qutf4ar45x4oixef@salvia>
References: <20180119030017.12432-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754873AbeASMFt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:05:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26ADBDA72B
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:05:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16A89DA856
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:05:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180119030017.12432-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 19, 2018 at 08:30:17AM +0530, Varsha Rao wrote:
> The following macros check if particular C types in specific header file
> exists, these header files defines them and are already included in the
> source code. So, remove them.
> 
> AC_HEADER_STDBOOL - stdbool.h
> AC_TYPE_INT and AC_TYPE_UINT - stdint.h or inttypes.h
> AC_TYPE_OFF_T and AC_TYPE_UID_T - sys/types.h
> AC_TYPE_SIZE_T - stddef.h, string.h, stdlib.h or stdio.h
> 
> Remove AC_C_CONST and AC_C_INLINE as gcc supports inline and const
> keywords.

Applied, thanks Varsha.
