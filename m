Return-Path: <SRS0=572t=CR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A56C433E2
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 19:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791FE207DE
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 19:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbgIHTlW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:41:22 -0400
Received: from correo.us.es ([193.147.175.20]:48688 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbgIHPyh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Sep 2020 11:54:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE88B190C84
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2020 16:36:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E05B7DA791
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2020 16:36:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D6055DA78F; Tue,  8 Sep 2020 16:36:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C79BADA78C;
        Tue,  8 Sep 2020 16:36:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 16:36:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AA7CB4301DE0;
        Tue,  8 Sep 2020 16:36:36 +0200 (CEST)
Date:   Tue, 8 Sep 2020 16:36:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/3, v2] netfilter: nf_tables: add userdata
 support for nft_object
Message-ID: <20200908143636.GA8366@salvia>
References: <20200908104225.GA14876@salvia>
 <20200908110141.44921-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200908110141.44921-1-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 08, 2020 at 01:01:41PM +0200, Jose M. Guisado Gomez wrote:
> Enables storing userdata for nft_object. Initially this will store an
> optional comment but can be extended in the future as needed.
> 
> Adds new attribute NFTA_OBJ_USERDATA to nft_object.

Applied, thanks.
