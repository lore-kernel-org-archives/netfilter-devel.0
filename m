Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC471C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C8820850
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733234AbfCANTh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:19:37 -0500
Received: from mail.us.es ([193.147.175.20]:48014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731716AbfCANTg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 08:19:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C9EC190F62
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:19:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0992ADA54D
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:19:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F2A70DA878; Fri,  1 Mar 2019 14:19:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 171A3DA84C;
        Fri,  1 Mar 2019 14:19:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 Mar 2019 14:19:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.223.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E5BF04265A2F;
        Fri,  1 Mar 2019 14:19:27 +0100 (CET)
Date:   Fri, 1 Mar 2019 14:19:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] ipvs: change some data types from int to bool
Message-ID: <20190301131926.saqadozaq65csiuc@salvia>
References: <4b4e7e88ad4b274b204c50caabc0ce1423f9e11d.1550331292.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b4e7e88ad4b274b204c50caabc0ce1423f9e11d.1550331292.git.aclaudi@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Feb 16, 2019 at 04:39:53PM +0100, Andrea Claudi wrote:
> Change the data type of the following variables from int to bool
> across ipvs code:
> 
>   - found
>   - loop
>   - need_full_dest
>   - need_full_svc
>   - payload_csum
> 
> Also change the following functions to use bool full_entry param
> instead of int:
> 
>   - ip_vs_genl_parse_dest()
>   - ip_vs_genl_parse_service()
> 
> This patch does not change any functionality but makes the source
> code slightly easier to read.

Applied, thanks.
