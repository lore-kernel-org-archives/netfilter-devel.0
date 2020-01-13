Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD344C33CA9
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 23:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A38207FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 23:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgAMXBE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 18:01:04 -0500
Received: from correo.us.es ([193.147.175.20]:33608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbgAMXBE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 18:01:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 905D5EBAC5
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2020 00:01:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7713FDA711
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2020 00:01:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60B76DA721; Tue, 14 Jan 2020 00:01:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C9E0DA711;
        Tue, 14 Jan 2020 00:00:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 14 Jan 2020 00:00:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5EBC642EF532;
        Tue, 14 Jan 2020 00:00:59 +0100 (CET)
Date:   Tue, 14 Jan 2020 00:00:58 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Romain Bellan <romain.bellan@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: add kernel side filtering
 for dump
Message-ID: <20200113230058.g4ul2a6hyarirsko@salvia>
References: <20191219103638.20454-1-romain.bellan@wifirst.fr>
 <20191230121253.laf2ttcfpjgbfowt@salvia>
 <20200107091026.GH15271@wiboss>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107091026.GH15271@wiboss>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 07, 2020 at 10:10:26AM +0100, Romain Bellan wrote:
> Hi Pablo,
> 
> > I did not yet have a look at this in detail, will do asap.
> > 
> > However, I would like to know if you would plan to submit userspace
> > patches for libnetfilter_conntrack for this. Main problem here is
> > backward compatibility (old conntrack tool and new kernel).
> 
> Currently I wrote a patch for the pyroute2 python library (to
> control netlink using Python) whith checks of kernel version for
> using filtering in kernel or userspace.
> 
> I would like to submit a patch for the libnetfilter_conntrack if you
> think that it is useful, but i didn't have a look on it yet.

Please have a look and make an API proposal. Use the
libnetfilter_conntrack libmnl API for this.

> About compatibility, currently the only way is to check with the
> kernel version, but I can add something like NLM_F_DUMP_FILTERED in
> the netlink reply. What would be the best way for you?

Yes, dump filtered is fine to signal userspace.

I was thinking on how conntrack could use this. Problem is that this
depends on the kernel version. Unless there is a way to do some
probing to see if the filtering is in place, the userspace conntrack
utility cannot use this. Could you also have a look into that?

Thanks.
