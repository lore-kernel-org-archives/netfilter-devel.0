Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE98ECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 09:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B19A22089C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 09:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439371AbfJQJFx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 05:05:53 -0400
Received: from correo.us.es ([193.147.175.20]:37298 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728987AbfJQJFx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 05:05:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0418E18CDCE
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 11:05:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6EFDB7FFE
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 11:05:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E64ACB7FF9; Thu, 17 Oct 2019 11:05:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DAD1FB7FF9;
        Thu, 17 Oct 2019 11:05:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 11:05:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B1E9B4251480;
        Thu, 17 Oct 2019 11:05:45 +0200 (CEST)
Date:   Thu, 17 Oct 2019 11:05:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] obj/ct_timeout: Fix NFTA_CT_TIMEOUT_DATA parser
Message-ID: <20191017090545.3cu4otencefu6wd3@salvia>
References: <20191016225818.23842-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016225818.23842-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 12:58:18AM +0200, Phil Sutter wrote:
> This is a necessary follow-up on commit 00b144bc9d093 ("obj/ct_timeout:
> Avoid array overrun in timeout_parse_attr_data()") which fixed array out
> of bounds access but missed the logic behind it:
> 
> The nested attribute type values are incremented by one when being
> transferred between kernel and userspace, the zero type value is
> reserved for "unspecified".
> 
> Kernel uses CTA_TIMEOUT_* symbols for that, libnftnl simply mangles the
> type values in nftnl_obj_ct_timeout_build().
> 
> Return path was broken as it overstepped its nlattr array but apart from
> that worked: Type values were decremented by one in
> timeout_parse_attr_data().
> 
> This patch moves the type value mangling into
> parse_timeout_attr_policy_cb() (which still overstepped nlattr array).
> Consequently, when copying values from nlattr array into ct timeout
> object in timeout_parse_attr_data(), loop is adjusted to start at index
> 0 and the type value decrement is dropped there.
> 
> Fixes: 0adceeab1597a ("src: add ct timeout support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
