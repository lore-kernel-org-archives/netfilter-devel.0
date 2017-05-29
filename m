From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_hashlimit: fix uint64_t printf
 formats
Date: Mon, 29 May 2017 14:02:08 +0200
Message-ID: <20170529120208.GA11167@salvia>
References: <1495610038-29297-1-git-send-email-alin.nastac@technicolor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Alin Nastac <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750986AbdE2MCS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 08:02:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 502B8303D04
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:02:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FD5F100A6C
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:02:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A188DFF6FE
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:02:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495610038-29297-1-git-send-email-alin.nastac@technicolor.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 09:13:58AM +0200, Alin Nastac wrote:
> From: Alin Nastac <alin.nastac@gmail.com>
>
> The remaining %llu formats are used for unsigned long long values.

Hm, still problems here:

libxt_hashlimit.c: In function ‘hashlimit_mt_print’:
libxt_hashlimit.c:739:3: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘__u64’ [-Wformat=]   printf(" burst %"PRIu64, cfg->burst);
   printf(" burst %"PRIu64, cfg->burst);
   ^
libxt_hashlimit.c: In function ‘hashlimit_mt_save’:
libxt_hashlimit.c:849:3: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘__u64’ [-Wformat=]
   printf(" --hashlimit-burst %"PRIu64, cfg->burst);
