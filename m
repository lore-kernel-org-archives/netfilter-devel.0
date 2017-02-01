From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] conntrackd: cthelper: Don't leak
 nat_tuple
Date: Wed, 1 Feb 2017 18:04:24 +0100
Message-ID: <20170201170424.GC5052@salvia>
References: <20170127004424.16494-1-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ejcaruso@chromium.org, netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752764AbdBARE2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Feb 2017 12:04:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6154218018A
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51825DA808
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39BA9DA808
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:04:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170127004424.16494-1-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 26, 2017 at 04:44:24PM -0800, Kevin Cernekee wrote:
> nfexp_set_attr() copies |nat_tuple| rather than taking ownership, so
> it should be freed at the end of the loop.  Some of the other helpers
> (like rpc.c) do this, but it is missing here.

Also applied, thanks!
