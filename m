From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: Re: [PATCH nft] mnl: continue monitor if errno is ESRCH
Date: Wed, 1 Mar 2017 19:27:50 +0100
Message-ID: <20170301182750.GA4642@gmail.com>
References: <20170226163058.24754-1-alexander@alemayhu.com>
 <20170226202410.GB1827@salvia>
 <20170301112103.GA14422@salvia>
 <20170301114140.GA14753@salvia>
 <20170301145227.GA10448@gmail.com>
 <20170301151800.GA1044@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:32784 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbdCBCA4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 21:00:56 -0500
Received: by mail-lf0-f45.google.com with SMTP id a6so27407030lfa.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Mar 2017 18:00:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170301151800.GA1044@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 01, 2017 at 04:18:00PM +0100, Pablo Neira Ayuso wrote:
> Hm, I'm hitting this here:
> 
> I: results: [OK] 107 [FAILED] 0 [TOTAL] 107
> 
> Running nft git HEAD and nf.git kernel.
>
See no failures with HEAD. Suspect I misconfigured earlier, sorry for the noise.

-- 
Mit freundlichen Grüßen

Alexander Alemayhu
