Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F1CEB64D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jun 2023 13:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjFRNui (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jun 2023 09:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjFRNuh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2023 09:50:37 -0400
X-Greylist: delayed 380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Jun 2023 06:50:35 PDT
Received: from mail.sunbirdgrove.com (mail.sunbirdgrove.com [2.59.135.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB18D1B9
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2023 06:50:35 -0700 (PDT)
Message-ID: <aeb73b1d-4c9b-5be1-2eca-87a925836c4e@qmail.sunbirdgrove.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qmail.sunbirdgrove.com;
        s=dkim; t=1687095853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WzP82bDtYgC1sRWxdyA1BUZhyGRLrnuUc1X1KTeuffg=;
        b=vrH58VfWbMuPRUgrGfXcN28FDiGSVEBNiqdPp9D5PotC3SdyvBkR6dOrVdNwHDrh9sgEMG
        u7AsoHgIKWNIneAvgq31cFYoy4M7HQqSINQ+eCWe9BSsYggfZ1hwZeKIKZe6Xk2g2Bo6Uk
        exttPbz4GtUOw2VyD3ZTF/KKruDzBnA=
Authentication-Results: mail.sunbirdgrove.com;
        auth=pass smtp.mailfrom=nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com
Date:   Sun, 18 Jun 2023 15:44:12 +0200
MIME-Version: 1.0
Subject: Re: nft list sets changed behavior
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
References: <60e59333-3d37-5b66-e0ed-8e7d4c01d956@qmail.sunbirdgrove.com>
 <20230618122216.3bdd0e34776293adb0655516@plushkava.net>
 <962b1e4f-63e2-bc3b-bf27-5569c6402c0f@qmail.sunbirdgrove.com>
 <20230618133509.GA869@breakpoint.cc>
Content-Language: en-US
From:   nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com
In-Reply-To: <20230618133509.GA869@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Bar: /
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 > No need, consider the bug filed.

Thank you!

 > Thoughts? I'd go with 3

If you care for input on -devel, I'd also go with 3, that's intuitive 
like the rest. (nft -t list set inet filter foo, nft -t list ruleset)

I already switched to looping over it, but when you need all data 
anyway, it's a few less calls.
