From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] tests: Add test for flush command selectiveness
 on sets
Date: Fri, 24 Mar 2017 19:29:51 +0100
Message-ID: <20170324182951.GB1611@salvia>
References: <20170324153131.GA6454@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932826AbdCXSaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 14:30:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7100A1EC2C5
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:30:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63B64A6C1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:30:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FFACDA729
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:29:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170324153131.GA6454@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 24, 2017 at 12:31:31PM -0300, Elise Lennion wrote:
> This tests the selectiveness of flush command on structures that use the
> generic set infrastructure (sets, maps and flow tables).

Also applied, thanks.
