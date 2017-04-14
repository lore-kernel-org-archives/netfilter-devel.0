From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue][PATCH 2/2] Declare the define visivility
 attribute together
Date: Fri, 14 Apr 2017 03:30:44 +0200
Message-ID: <20170414013044.GA30760@salvia>
References: <20170410195804.18238-1-raj.khem@gmail.com>
 <20170410195804.18238-2-raj.khem@gmail.com>
 <20170413233719.GB8577@salvia>
 <20170413234911.GA9656@salvia>
 <7d497c66-5e61-8ba0-667b-1f1f3fed2460@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Khem Raj <raj.khem@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbdDNBay (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 21:30:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 523CFE0443
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:30:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44444FB45F
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:30:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 874D3FB463
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:30:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <7d497c66-5e61-8ba0-667b-1f1f3fed2460@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 13, 2017 at 06:22:54PM -0700, Khem Raj wrote:
> > It would be good if you send me a patch for libnetfilter_queue that
> > applies on top of you previous patch, or I can simply revert.
> 
> I will send a patch which uses EXPORT_FUNCTION instead and declare it
> before definition like libmnl
> 
> I am fine with revert or patch on top, I can do both just let me know

I have reverted it. Please follow up with a new patch. Thanks!
