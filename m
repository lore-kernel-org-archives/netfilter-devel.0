From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] build: add missing backslash to list of CFLAGS
Date: Mon, 16 Jan 2017 11:37:25 +0100
Message-ID: <20170116103725.GA6974@salvia>
References: <20170113142409.15705-1-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43902 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbdAPKha (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 05:37:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2830E8382
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:37:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 946E03515
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:37:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56562201EF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:37:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170113142409.15705-1-tklauser@distanz.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 13, 2017 at 03:24:09PM +0100, Tobias Klauser wrote:
> Due to a missing backslash in the AM_CFLAGS list some warning flags do
> not get added to the generated default CLFAGS. Add the missing backslash
> to include them as well.

Also applied, thanks.
