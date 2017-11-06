From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests/monitor: Print error "this requires root" and exit
Date: Mon, 6 Nov 2017 16:42:57 +0100
Message-ID: <20171106154257.GA15781@salvia>
References: <20171106153405.6294-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753470AbdKFPnH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:43:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 758501BFAA2
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:43:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 654F2DA812
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:43:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171106153405.6294-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 06, 2017 at 09:04:05PM +0530, Harsha Sharma wrote:
> If executed without root privileges, print error "this requires root!"
> and exit.

Applied, thanks Harsha.
