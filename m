From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 1/2] main: Validate the number of numeric options
Date: Sun, 5 Feb 2017 21:42:17 +0100
Message-ID: <20170205204217.GA6584@salvia>
References: <20170202122553.GA17853@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43486 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdBEUma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Feb 2017 15:42:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE2B9131CAD
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:42:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1155DA7FA
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:42:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A7F9DA729
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:42:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170202122553.GA17853@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 02, 2017 at 10:25:53AM -0200, Elise Lennion wrote:
> The number of numeric options influences the behavior and the user
> should be warned if a invalid number is used.

Applied, thanks Elise.
