From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Rebasing nf-next
Date: Mon, 8 Jan 2018 16:45:22 +0100
Message-ID: <20180108154522.ph7gfcgb3wivezr3@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932282AbeAHPp0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 10:45:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9C64C5151
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 16:45:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB5C4DA848
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 16:45:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3486DA80D
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 16:45:22 +0100 (CET)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BC7AA4265A2F
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 16:45:22 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kbuild test robot reports a compilation error in
rhashtable_walk_start() in the new net/netfilter/nf_flow_table.c,
given this has changed in net-next.

Sorry for the inconvenience.
