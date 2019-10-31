Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617FACA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 323FF2087E
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfJaOEa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 10:04:30 -0400
Received: from correo.us.es ([193.147.175.20]:44226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727579AbfJaOE3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 10:04:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 682BF117735
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 15:04:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A012B8001
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 15:04:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4FA36B7FFE; Thu, 31 Oct 2019 15:04:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B997DA72F;
        Thu, 31 Oct 2019 15:04:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 31 Oct 2019 15:04:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5786B42EE38F;
        Thu, 31 Oct 2019 15:04:23 +0100 (CET)
Date:   Thu, 31 Oct 2019 15:04:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 07/12] nft: Introduce NFT_CL_SETS cache level
Message-ID: <20191031140425.rtvrbisf2az3gmks@salvia>
References: <20191030172701.5892-1-phil@nwl.cc>
 <20191030172701.5892-8-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030172701.5892-8-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 30, 2019 at 06:26:56PM +0100, Phil Sutter wrote:
> +static int set_fetch_elem_cb(struct nftnl_set *s, void *data)
> +{
> +        char buf[MNL_SOCKET_BUFFER_SIZE];
> +	struct nft_handle *h = data;
> +        struct nlmsghdr *nlh;
> +
> +	if (set_has_elements(s))
> +		return 0;
> +
> +	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, h->family,
> +				    NLM_F_DUMP, h->seq);
> +        nftnl_set_elems_nlmsg_build_payload(nlh, s);
> +
> +	return mnl_talk(h, nlh, set_elem_cb, s);
> +}

Please, mind coding style, irregular indentation.
