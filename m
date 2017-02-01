From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 conntrack-tools] conntrackd: cthelper: Free pktb
 after use
Date: Wed, 1 Feb 2017 18:04:06 +0100
Message-ID: <20170201170406.GB5052@salvia>
References: <20170127203847.10785-1-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753044AbdBAREP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Feb 2017 12:04:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7C3F18018A
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7ADCDA845
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFD4EDA801
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170127203847.10785-1-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 27, 2017 at 12:38:46PM -0800, Kevin Cernekee wrote:
> According to valgrind, this currently leaks ~512B to 2kB for each
> packet sent to the userspace helper.

Applied, thanks!
