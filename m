From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] tests: shell: Test input descriptors for included
 files
Date: Mon, 26 Jun 2017 18:59:52 +0200
Message-ID: <20170626165952.GB8489@salvia>
References: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
 <1498219556-25179-2-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33950 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbdFZRAG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 13:00:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A3C81E0420
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 18:59:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93CF41B4055
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 18:59:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 769AC1B3D58
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 18:59:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1498219556-25179-2-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 23, 2017 at 05:35:56PM +0530, Shyam Saini wrote:
> Before the [Test] commit, nft error message was pointing to wrong
> file.
> 
> But after the commit it points to right file.
> This commit test the changes made in the [Test] commit.

Also applied, thanks.
