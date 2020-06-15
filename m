Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFED8C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 14:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794EB20679
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 14:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F71n2lCx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgFOOgd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 10:36:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43061 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730397AbgFOOgc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 10:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592231791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QdVYl8C/VsZQcWATjdE02Rrux1zXHaj1EK9Mzw/jj40=;
        b=F71n2lCxmmOo76hbNZa4i4M8YYT5+IQoMkv3IiVMqKhw61ae8yz2CiSMB1zERCHrBaBfMz
        MwAD96FNptmtszdxB6IKs/VOsucViAxkY8kLjGqNuQthyvbHt/+HS9dPNuKhTI2pEPwHty
        Hd5LnsaLXUICY82QrdheUxRd8Yrs/ac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-2tnd4R4XM86oAm1p-u8clw-1; Mon, 15 Jun 2020 10:36:29 -0400
X-MC-Unique: 2tnd4R4XM86oAm1p-u8clw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4348710AB644;
        Mon, 15 Jun 2020 14:36:28 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E0255DA36;
        Mon, 15 Jun 2020 14:36:25 +0000 (UTC)
Date:   Mon, 15 Jun 2020 16:36:18 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Laura =?UTF-8?B?R2FyY8OtYSBMacOpYmFuYQ==?= <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Drop redefinition of DIFF variable
Message-ID: <20200615163618.77b209d5@elisabeth>
In-Reply-To: <20200615132134.GK23632@orbyte.nwl.cc>
References: <bdced35aa00b7933e8b67a52b37754d0b6f86f59.1592170402.git.sbrivio@redhat.com>
        <20200615090044.GH23632@orbyte.nwl.cc>
        <20200615121811.08c347e2@redhat.com>
        <20200615115424.GJ23632@orbyte.nwl.cc>
        <20200615144055.31bbfd66@redhat.com>
        <20200615132134.GK23632@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 15 Jun 2020 15:21:34 +0200
Phil Sutter <phil@nwl.cc> wrote:

> On Mon, Jun 15, 2020 at 02:40:55PM +0200, Stefano Brivio wrote:
> > 
> > [...]
> > 
> > Commit 7d93e2c2fbc7 (which makes it "configurable") is from March 2018.  
> 
> I think you're misinterpreting that commit regarding an attempt at
> making diff binary configurable.
> 
> [...]
>
> > [...]
> >
> > # grep DIFF=\" nftables/tests/shell/run-tests.sh
> > DIFF="diff -y"  
> 
> This is no guaranteed functionality. There's no comment or anything
> stating you could change the DIFF definition atop the script to
> customize diff behaviour.

But...

 # Configuration
 TESTDIR="./$(dirname $0)/"
 RETURNCODE_SEPARATOR="_"
 SRC_NFT="$(dirname $0)/../../src/nft"
+POSITIVE_RET=0
+DIFF=$(which diff)

:) well, now that you tell me, I can guess that "# Configuration" only
applied to the original parts, and the rest was added there simply
because there were no other "sections".

> [...]
> 
> As said, the quotes are there to cover the expected 'which' output, no
> more and no less. Supporting user-defined diff-command (or custom
> options) is new functionality IMO. I'm totally fine with that and merely
> want to point out we're not talking about fixing a bug here.

Okay, I see. I'll try to get back to that soon.

Pablo, I think you can drop this patch.

-- 
Stefano

