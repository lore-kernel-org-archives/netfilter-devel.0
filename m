From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 4/6] src/ruleset: Avoid reading garbage in
 nftnl_ruleset_cb()
Date: Fri, 15 Dec 2017 16:18:56 +0100
Message-ID: <20171215151856.6gg4xspj3zhmczqb@salvia>
References: <20171214194025.21334-1-phil@nwl.cc>
 <20171214194025.21334-5-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932250AbdLOPS7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Dec 2017 10:18:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E51E9C5146
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:18:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D513CFEFB2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:18:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171214194025.21334-5-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 14, 2017 at 08:40:23PM +0100, Phil Sutter wrote:
> If nftnl_ruleset_json_parse() is called with arg == NULL, ctx.data is
> left uninitialized and will later be used in nftnl_ruleset_cb(). Avoid
> this by using a C99-style initializer for 'ctx' which sets all omitted
> fields to zero.

Applied, thanks Phil.
