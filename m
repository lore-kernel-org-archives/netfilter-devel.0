From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: static libnftables by now?
Date: Fri, 24 Nov 2017 15:02:46 +0100
Message-ID: <20171124140246.GA6881@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55196 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753757AbdKXOCv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Nov 2017 09:02:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5CDB8392E04
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:02:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4DE7ADA875
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:02:50 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

Until the library API is stable, before 0.9.0 release, I think it
would be good if we make it static by now.

This would also allow me to make more frequent 0.8.x releases
including fixes and such.

What do you think? Would you have a look into it?

Thanks.
