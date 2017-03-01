From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: Re: [PATCH nft] mnl: continue monitor if errno is ESRCH
Date: Wed, 1 Mar 2017 15:52:27 +0100
Message-ID: <20170301145227.GA10448@gmail.com>
References: <20170226163058.24754-1-alexander@alemayhu.com>
 <20170226202410.GB1827@salvia>
 <20170301112103.GA14422@salvia>
 <20170301114140.GA14753@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38561 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdCAPWr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 10:22:47 -0500
Received: by mail-wm0-f54.google.com with SMTP id u199so39094059wmd.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Mar 2017 07:22:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170301114140.GA14753@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 01, 2017 at 12:41:40PM +0100, Pablo Neira Ayuso wrote:
> 
> Actually, this patch would be better. All return values of these
> notify function are ignored, so we can turned it into void.

Monitor seems to work as expected and does not exit with this patch.
Should all of the tests pass with this? Currently seeing

I: results: [OK] 58 [FAILED] 49 [TOTAL] 107 

Thanks.

-- 
Mit freundlichen Grüßen

Alexander Alemayhu
