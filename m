From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nft_hash: rename nft_hash to
 nft_jhash
Date: Mon, 6 Mar 2017 17:56:08 +0100
Message-ID: <20170306165608.GA4529@salvia>
References: <20170223111015.573g4cxe7ehkev3y@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754115AbdCFREh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 12:04:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2461E627
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:56:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94E31DA7E0
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:56:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66E8FDA7E0
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:56:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170223111015.573g4cxe7ehkev3y@nevthink>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2017 at 12:10:15PM +0100, Laura Garcia Liebana wrote:
> This patch renames the local nft_hash structure and functions
> to nft_jhash in order to prepare the nft_hash module code to
> add new hash functions.

Applied, thanks Laura.
