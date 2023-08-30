Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D5AC83F01
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 21:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjH3VSV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 17:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbjH3VSV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 17:18:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4512DCE9
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 14:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693430139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uhQFPkY4niwhyy99TReN+yqVgvLp9Sf5dfLbQ4g67IM=;
        b=CeIpOKYppIYg93Ff3GGTv80alAt6RkFchE58mwbM+fbENBP7QxbmcfKWnSPbcpWwlkP2lB
        4nYInTL6ejWaOm49ane1/nQtTLNF+mdff+U4LXaPFITj+UBsi4QrkOOO01Gt3mkJmgpmvc
        XJjy7C/oQxo/5IrUE1bNtagU9zkiy/A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-ZHRmKRPdPy68WQLFYk7NRw-1; Wed, 30 Aug 2023 16:54:09 -0400
X-MC-Unique: ZHRmKRPdPy68WQLFYk7NRw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D35A5805F5B;
        Wed, 30 Aug 2023 20:54:08 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.22.48.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 119369A;
        Wed, 30 Aug 2023 20:54:07 +0000 (UTC)
Date:   Wed, 30 Aug 2023 16:54:05 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [nf PATCH 1/2] netfilter: nf_tables: Audit log setelem reset
Message-ID: <ZO+sbVTuNOZ4hfOe@madcap2.tricolour.ca>
References: <20230829175158.20202-1-phil@nwl.cc>
 <ZO9kberk3iNZv2qj@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO9kberk3iNZv2qj@calendula>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2023-08-30 17:46, Pablo Neira Ayuso wrote:
> On Tue, Aug 29, 2023 at 07:51:57PM +0200, Phil Sutter wrote:
> > Since set element reset is not integrated into nf_tables' transaction
> > logic, an explicit log call is needed, similar to NFT_MSG_GETOBJ_RESET
> > handling.
> > 
> > For the sake of simplicity, catchall element reset will always generate
> > a dedicated log entry. This relieves nf_tables_dump_set() from having to
> > adjust the logged element count depending on whether a catchall element
> > was found or not.
> 
> Applied, thanks Phil

Thanks Phil, Pablo.  If it isn't too late, please add my
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
Upstream IRC: SunRaycer
Voice: +1.613.860 2354 SMS: +1.613.518.6570

