Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F95CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4512070B
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfJZLyf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:54:35 -0400
Received: from correo.us.es ([193.147.175.20]:48134 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfJZLye (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:54:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7138A8C3C45
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:54:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63C1DCA0F1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:54:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 596DFDA72F; Sat, 26 Oct 2019 13:54:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E388BAACC
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:54:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:54:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 59A2142EE393
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:54:28 +0200 (CEST)
Date:   Sat, 26 Oct 2019 13:54:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191026115430.34nqmavkjvvbo64i@salvia>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
 <20191023153142.GB5848@dimstar.local.net>
 <20191023204836.ws4rv55f2dczhq2q@salvia>
 <20191026074000.GA17706@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026074000.GA17706@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 26, 2019 at 06:40:00PM +1100, Duncan Roe wrote:
> On Wed, Oct 23, 2019 at 10:48:36PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 24, 2019 at 02:31:42AM +1100, Duncan Roe wrote:
> > > BTW, ldd of my app shows libnfnetlink.so although it doesn't use any deprecated
> > > functions. Is that expected?
> > 
> > Yes, there is still code in the libraries that refer to libnfnetlink.
> > Replacing some of that code should be feasible via libmnl, it is a
> > task that has been in my TODO list for long time. There's always
> > something with more priority in the queue.
> 
> Using *nm -D* (dynamic symbols) I see
>  - libmnl.so: no U (undefined) symbols satisfied by libnfnetlink.so
>  - nfq (my app): no U symbols satisfied by libnfnetlink.so
>  - libnetfilter_queue.so: many U symbols satisfied by libnfnetlink.so
> Only way to tell whether the libnfnetlink.so references in libnetfilter_queue.so
> are confined to the deprecated functions would be to do a build without them.
> If that eliminates libnfnetlink references, then maybe we could think about a
> configure option to not build them (also excluding them from the doco).

Apparently, there are many people using this old libnetfilter_queue
API, we cannot get rid of it. We could though explore using libmnl
instead of libnfnetlink from the old libnetfilter_queue API
implementation.

> But that's for another day - I'll get back to libnetfilter_queue doco for now.

Agreed.
