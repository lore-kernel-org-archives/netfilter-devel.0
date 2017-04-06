From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC v2] extensions: libxt_TOS: Add translation to nft
Date: Fri, 7 Apr 2017 00:49:26 +0200
Message-ID: <20170406224926.GA2623@salvia>
References: <1490727018-25703-1-git-send-email-gs051095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gsoc2013@lists.netfilter.org, netfilter-devel@vger.kernel.org
To: Gargi Sharma <gs051095@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752467AbdDFWtd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:49:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D7C97137B8A
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:49:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8911DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:49:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28D1ADA7F7
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:49:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490727018-25703-1-git-send-email-gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 12:20:18AM +0530, Gargi Sharma wrote:
> diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
> index cef5876..f284d83 100644
> --- a/extensions/libxt_TOS.c
> +++ b/extensions/libxt_TOS.c
> @@ -183,6 +183,30 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
[...]
> +	xt_xlate_add(xl, "ip dscp set 0x%02x", dscp);
[...]
> +	xt_xlate_add(xl, " ip6 dscp set 0x%02x", dscp);
                          ^
And there's a space here. You have to be more careful.

Thanks!
