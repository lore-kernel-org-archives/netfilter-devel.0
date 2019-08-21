Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535B9C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 20:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CFEA2332A
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 20:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbfHUUvB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 16:51:01 -0400
Received: from correo.us.es ([193.147.175.20]:35570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbfHUUvB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 16:51:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B45C120827
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2019 22:50:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A9EFD1929
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2019 22:50:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4FFA3D2B1E; Wed, 21 Aug 2019 22:50:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CA93DA4D0;
        Wed, 21 Aug 2019 22:50:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 21 Aug 2019 22:50:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.43.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 200734265A2F;
        Wed, 21 Aug 2019 22:50:56 +0200 (CEST)
Date:   Wed, 21 Aug 2019 22:50:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Ander Juaristi <a@juaristi.eus>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v8 2/2] meta: Introduce new conditions 'time', 'day'
 and 'hour'
Message-ID: <20190821205055.dss3wfiv4pogyhjl@salvia>
References: <20190821151802.6849-1-a@juaristi.eus>
 <20190821151802.6849-2-a@juaristi.eus>
 <20190821162341.GB20113@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821162341.GB20113@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 06:23:41PM +0200, Florian Westphal wrote:
> Ander Juaristi <a@juaristi.eus> wrote:
> > These keywords introduce new checks for a timestamp, an absolute date (which is converted to a timestamp),
> > an hour in the day (which is converted to the number of seconds since midnight) and a day of week.
> > 
> > When converting an ISO date (eg. 2019-06-06 17:00) to a timestamp,
> > we need to substract it the GMT difference in seconds, that is, the value
> > of the 'tm_gmtoff' field in the tm structure. This is because the kernel
> > doesn't know about time zones. And hence the kernel manages different timestamps
> > than those that are advertised in userspace when running, for instance, date +%s.
> > 
> > The same conversion needs to be done when converting hours (e.g 17:00) to seconds since midnight
> > as well.
> > 
> > The result needs to be computed modulo 86400 in case GMT offset (difference in seconds from UTC)
> > is negative.
> > 
> > We also introduce a new command line option (-t, --seconds) to show the actual
> > timestamps when printing the values, rather than the ISO dates, or the hour.
> 
> Pablo, please see this "-t" option -- should be just re-use -n instead?
> 
> Other than this, this patch looks good and all tests pass for me.

this should be printed numerically with -n (global switch to disable
literal printing).

Then, -t could be added for disabling literal in a more fine grain, as
Phil suggest time ago with other existing options that are similar to
this one.
