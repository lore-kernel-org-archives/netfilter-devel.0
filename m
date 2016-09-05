From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] conntrackd: cthelper: ftp: Fix debug print
Date: Mon, 5 Sep 2016 19:46:49 +0200
Message-ID: <20160905174649.GB29988@salvia>
References: <1472704075-38007-1-git-send-email-cernekee@chromium.org>
 <1472704075-38007-2-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ashley.hughes@blueyonder.co.uk, netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934509AbcIERrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 13:47:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9AACC231667
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:46:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B941DA7E9
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:46:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 902666DB3B
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:46:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472704075-38007-2-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 31, 2016 at 09:27:54PM -0700, Kevin Cernekee wrote:
> matchoff is relative to dataoff, i.e. matchoff=0 (as utilized by
> nfq_tcp_mangle_ipv4()) points to the first byte of the TCP payload.

Also applied, thanks.
