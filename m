From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/3] tests: Add test cases for nested anonymous sets
Date: Wed, 22 Mar 2017 12:51:13 +0100
Message-ID: <20170322115113.GA14374@salvia>
References: <20170321131902.GA30047@salvia>
 <20170322002636.14081-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932606AbdCVLvS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 07:51:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C2D65114802
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:51:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B273FDA862
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:51:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9630EDA863
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:51:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170322002636.14081-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 01:26:34AM +0100, Phil Sutter wrote:
> This makes sure nesting of anonymous sets works regardless of whether
> defines are used or not. As a side-effect, it also checks that overlap
> checking when IP address prefixes are used, works.

Applied, thanks.
