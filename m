Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09ED3C77B7C
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 May 2023 06:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjEMGUY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 May 2023 02:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjEMGUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 May 2023 02:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488652716;
        Fri, 12 May 2023 23:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF18660DCA;
        Sat, 13 May 2023 06:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56755C433EF;
        Sat, 13 May 2023 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1683958822;
        bh=iT0MaSXRb+zDFy6uzl9kxZcsX3p0vH67BFbUX/ez/BA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BcGsKgjgCvxjMV67YJyRZJgMzlD0k3sUXPW2HqD5nLbpuGDB/JaI0HuefV0fDSJid
         anKhUp3Q4Ufu1PEZVALebow8KXQFfMGKSlMAMIZ4pf6Mmh5HGTvztX3nE0MbLnCFCO
         7K73+0aArzFYp21tdd2lyXNLR24wVRF9/4WDDbAM=
Date:   Sat, 13 May 2023 15:20:13 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "luwei (O)" <luwei32@huawei.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH netfilter -stable,4.14 0/6] stable fixes for 4.14
Message-ID: <2023051319-collected-blatantly-8d66@gregkh>
References: <20230511154143.52469-1-pablo@netfilter.org>
 <0626ced5-75f3-57cf-c797-e84a808e8cd7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0626ced5-75f3-57cf-c797-e84a808e8cd7@huawei.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 13, 2023 at 11:25:33AM +0800, luwei (O) wrote:
> Hi, Pablo, I followed up this CVE for several days but I can't figure out
> which commit caused this CVE, It seems the
> 
> kernel is affected from 4.0 version according:
> https://www.suse.com/security/cve/CVE-2023-32233.html.
> 
> So is there any fix patches for the lower versions ?

There are no more supported "lower versions" of the kernel at the moment
by the community.  So if you are stuck on a older one, please work with
the vendor that is providing you that support as they are the only ones
that can provide that _and_ you are already paying for that support.

thanks,

greg k-h
