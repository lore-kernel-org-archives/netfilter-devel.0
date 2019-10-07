Return-Path: <SRS0=Ckc6=YA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F028C47404
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Oct 2019 22:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AE21206C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Oct 2019 22:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfJGWAN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:00:13 -0400
Received: from correo.us.es ([193.147.175.20]:41802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbfJGWAM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 18:00:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B7B512C000
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2019 00:00:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C578FB362
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2019 00:00:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 01AADD1929; Tue,  8 Oct 2019 00:00:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADB0CDA4CA;
        Tue,  8 Oct 2019 00:00:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Oct 2019 00:00:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 86E81426CCBC;
        Tue,  8 Oct 2019 00:00:05 +0200 (CEST)
Date:   Tue, 8 Oct 2019 00:00:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/7] ipset: remove static inline functions
Message-ID: <20191007220007.esbqdf3fj2zzcjln@salvia>
References: <20191003195607.13180-1-jeremy@azazel.net>
 <alpine.DEB.2.20.1910072206070.16051@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.20.1910072206070.16051@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 07, 2019 at 10:08:28PM +0200, Kadlecsik József wrote:
> Hi Jeremy, Pablo,
> 
> On Thu, 3 Oct 2019, Jeremy Sowden wrote:
> 
> > In his feedback on an earlier patch series [0], Pablo suggested reducing
> > the number of ipset static inline functions.
> > 
> > 0 - https://lore.kernel.org/netfilter-devel/20190808112355.w3ax3twuf6b7pwc7@salvia/
> > 
> > This series:
> > 
> >   * removes inline from static functions in .c files;
> >   * moves some static functions out of headers and removes inline from
> >     them if they are only called from one .c file,
> >   * moves some static functions out of headers, removes inline from them
> >     and makes them extern if they are too big.
> > 
> > The changes reduced the size of the ipset modules by c. 13kB, when
> > compiled with GCC 9 on x86-64.
> 
> I have reviewed all of the patches and they are all right. Pablo, could 
> you queue them for nf-next? I applied the patches in the ipset git tree.

Sure.

> Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Applied, thanks a lot Jozsef.
