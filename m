Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97098C43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 20:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DE3E20637
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 20:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLIUoj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 15:44:39 -0500
Received: from correo.us.es ([193.147.175.20]:39420 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfLIUoj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 15:44:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3FC42EFEAE
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 21:44:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D635CDA70E
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 21:44:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CBE21DA70D; Mon,  9 Dec 2019 21:44:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD132DA709;
        Mon,  9 Dec 2019 21:44:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 21:44:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A70704265A5A;
        Mon,  9 Dec 2019 21:44:33 +0100 (CET)
Date:   Mon, 9 Dec 2019 21:44:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH,nf-next RFC 1/2] netfilter: nf_tables: add
 nft_setelem_parse_key()
Message-ID: <20191209204434.yxepsop2vpbgnj4h@salvia>
References: <20191202131407.500999-1-pablo@netfilter.org>
 <20191202131407.500999-2-pablo@netfilter.org>
 <20191205234350.3dd81c1c@elisabeth>
 <20191206194517.gg6e34uekje647sn@salvia>
 <20191207235138.393d306c@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207235138.393d306c@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 07, 2019 at 11:51:38PM +0100, Stefano Brivio wrote:
> On Fri, 6 Dec 2019 20:45:17 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > On Thu, Dec 05, 2019 at 11:43:50PM +0100, Stefano Brivio wrote:
[...]
> > > If the type is not NFT_DATA_VALUE, I guess we shouldn't pass
> > > NFT_DATA_VALUE to nft_data_release() here.  
> > 
> > The new nft_setelem_parse_key() function makes sure that the key is
> > NFT_DATA_VALUE, otherwise bails out and calls nft_data_release() with
> > desc.type.
> > 
> > Then, moving forward in nft_add_set_elem() after the
> > nft_setelem_parse_key(), if an error occurs, nft_data_release() can be
> > called with NFT_DATA_VALUE, because that was already validated by
> > nft_setelem_parse_key().
> > 
> > > Maybe nft_setelem_parse_key() could clean up after itself on error.  
> > 
> > It's doing so already, right? See err2: label.
> 
> Right you are, my bad, I mixed up err2: and err1: in nft_set_delelem()
> and then forgot about err2: in nft_setelem_parse_key().
> 
> Well, on the other hand, 'return err;" and 'goto fail_elem;" would have
> been easier to follow, but maybe it's just my taste. :)

Feel free to update this patch to use the goto tags you are
suggesting.

Thanks.
