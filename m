From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: Add test for set element leak bug
Date: Mon, 23 Jan 2017 14:39:12 +0100
Message-ID: <20170123133912.GA2082@salvia>
References: <20170119162947.GA6924@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbdAWNjb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 08:39:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B58A316838B
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 14:39:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A73141B309D
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 14:39:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85CBC1B30B6
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 14:39:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170119162947.GA6924@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 19, 2017 at 02:29:47PM -0200, Elise Lennion wrote:
> This tests for a bug where a repeated element is added and the set
> elements counter is incorrectly increased.

Applied, thanks.

It would be good to have another test to catch the 'nft flush set x y'
bug that you uncover, this requires the kernel patches I sent to cure
this problem.
