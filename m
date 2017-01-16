From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] expr: Add const qualifiers to *2str translation
 arrays
Date: Mon, 16 Jan 2017 11:33:13 +0100
Message-ID: <20170116103313.GA5682@salvia>
References: <20170113105009.14502-1-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbdAPKdR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 05:33:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4AB6CE8381
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:33:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3999F8E7ED
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:33:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0991C961D3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:33:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170113105009.14502-1-tklauser@distanz.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 13, 2017 at 11:50:09AM +0100, Tobias Klauser wrote:
> Add const qualifiers to the "to string" translation arrays used by
> various *2str() functions.
> 
> This fixes GCC warnings such as the following when compiling with
> -Wwrite-strings:
> 
>   expr/byteorder.c:176:25: warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
> 
> In order to catch these in the future, also add -Wwrite-strings to
> default CFLAGS.

Applied, thanks.
