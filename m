From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] examples: Remove the use of nftnl_mnl_batch_put()
Date: Mon, 16 Jan 2017 11:40:39 +0100
Message-ID: <20170116104039.GA7993@salvia>
References: <20170112192255.GA20246@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46204 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbdAPKku (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 05:40:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 856E0E8385
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:40:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7766DA8257
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:40:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38B97FF6FC
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 11:40:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170112192255.GA20246@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 12, 2017 at 05:22:55PM -0200, Elise Lennion wrote:
> use nftnl_batch_begin() and nftnl_batch_end() instead, to keep examples
> consistent and avoid code duplication.

Applied, thanks Elise.
