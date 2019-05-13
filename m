Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC44C04AB1
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 08:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7C2920879
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 08:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfEMIks (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 04:40:48 -0400
Received: from mail.us.es ([193.147.175.20]:55260 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727371AbfEMIks (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 04:40:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87B29E2D85
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 10:40:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9273DA4DB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 10:40:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EFEDFEBAE5; Mon, 13 May 2019 10:37:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76AE3D2CAA;
        Mon, 13 May 2019 10:37:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 10:37:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4838F4265A31;
        Mon, 13 May 2019 10:37:23 +0200 (CEST)
Date:   Mon, 13 May 2019 10:37:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_ct: add ct expectations support
Message-ID: <20190513083722.c45swifrfdlaptbc@salvia>
References: <20190505154016.3505-1-sveyret@gmail.com>
 <20190505225114.pwpwckz2oauskkrf@salvia>
 <CAFs+hh4Cq3kbJPVtn080KknAP5d3w8V5zcx9AGV800EN8d9G=w@mail.gmail.com>
 <20190512175651.uiatuot33dtzhglw@salvia>
 <CAFs+hh6emDCoyuE_KpxX_2U5kFT=q3CwUUp_dB887Grq8Lcf5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFs+hh6emDCoyuE_KpxX_2U5kFT=q3CwUUp_dB887Grq8Lcf5g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 13, 2019 at 08:00:53AM +0200, Stéphane Veyret wrote:
> Le dim. 12 mai 2019 à 19:56, Pablo Neira Ayuso <pablo@netfilter.org> a écrit :
> >
> > > But I actually saw today that these values are used in the « nftables
> > > » project. There is a copy of nf_tables.h there. Not sure it is a good
> > > idea to keep the variables in « nftables » and not in kernel.
> >
> > I have just updated the cached copy of nf_tables.h in
> > git.netfilter.org:
> 
> So now nftables does not compile anymore, does it? What do you think
> we should do, then? Add a new variable, out of nf_tables.h, in
> nftables project?

Please, do not add a new enumeration definition to nf_tables.h for
something we do not need in UAPI.

Thanks.
