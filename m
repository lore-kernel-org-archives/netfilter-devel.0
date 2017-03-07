From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH ulogd2] adjust ulogd.logrotate to match ulogd.conf
Date: Tue, 7 Mar 2017 14:41:05 +0100
Message-ID: <20170307134105.GA23278@salvia>
References: <a8e669c7-6f9a-405f-bac3-c7d0c33064eb@email.android.com>
 <alpine.LFD.2.20.1703061844310.6990@kanala.kunkku.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
To: Eric Leblond <eric@regit.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50590 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755307AbdCGNth (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 08:49:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1BC119D8A4
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 14:41:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9143BDA80C
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 14:41:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E1C7DA80B
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 14:41:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.20.1703061844310.6990@kanala.kunkku.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 06, 2017 at 07:06:51PM +0200, Kaarle Ritvanen wrote:
> On Sun, 12 Feb 2017, Eric Leblond wrote:
> 
> > This is not correct. All the listed files are default value for various 
> > existing output modules so we should keep them.
> 
> Sorry, I was looking at the default configuration file. Currently, the 
> default configuration file is inconsistent with the module defaults. I 
> think it would be good to harmonize all these, so I posted a couple of 
> patches:
> 
> Harmonize default log files:
> http://marc.info/?l=netfilter-devel&m=148697928328626&w=2
> 
> Add missing default log files to logrotate configuration:
> http://marc.info/?l=netfilter-devel&m=148697928528629&w=2
> 
> I wish somebody would comment these.

Eric, let me know if you have some spare cycles for this. Otherwise I
will place them in the tree.

Thanks a lot!
