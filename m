Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B26C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 21:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2362F206ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 21:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLBVZd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:25:33 -0500
Received: from correo.us.es ([193.147.175.20]:36276 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbfLBVZc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 16:25:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 896F1C2306
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 22:25:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B9E0DA712
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 22:25:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 70CA8DA70B; Mon,  2 Dec 2019 22:25:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 639A8DA703;
        Mon,  2 Dec 2019 22:25:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 22:25:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3BEE04265A5A;
        Mon,  2 Dec 2019 22:25:27 +0100 (CET)
Date:   Mon, 2 Dec 2019 22:25:28 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] ebtables 2.0.11 release
Message-ID: <20191202212528.q4bqd5dlbt7vix5b@salvia>
References: <20191202153356.xowrrxn26jlm5v4f@salvia>
 <nycvar.YFH.7.76.1912022027520.18991@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1912022027520.18991@n3.vanv.qr>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 08:30:25PM +0100, Jan Engelhardt wrote:
> On Monday 2019-12-02 16:33, Pablo Neira Ayuso wrote:
> 
> >You can download it from:
> >
> >ftp://ftp.netfilter.org/pub/ebtables/
> 
> There is a file called ebtables-2.0.11.tar.bz2 in there, but this is 
> actually a gz encoded object. (This confuses rpmbuild, which tries 
> to `bzip2 -d` it.)

Just fixed this, thanks for reporting.

> (Isn't it time to do xz or zstd anyway?)

For the sake of saving bits over the wire, yes. Next time.
