From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] conntrackd: cthelper: Add new mdns helper
Date: Fri, 9 Sep 2016 00:22:00 +0200
Message-ID: <20160908222200.GA29658@salvia>
References: <1473043144-37380-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753046AbcIHWWF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 18:22:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9AA04231675
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:22:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8ADA7114D63
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:22:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88424FC61D
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:22:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473043144-37380-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 04, 2016 at 07:39:04PM -0700, Kevin Cernekee wrote:
> This allows unicast replies to multicast DNS (mDNS / RFC6762) queries.
> These queries are often used when a full-featured mDNS service (such as
> avahi-daemon) is not running, or if an mDNS client does not have
> permission to bind to port 5353.

Applied, thanks Kevin.
