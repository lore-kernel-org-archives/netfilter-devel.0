From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next 1/1] netfilter: xt_multiport: Fix wrong unmatch
 result with multiple ports
Date: Thu, 24 Nov 2016 20:11:55 -0800
Message-ID: <1480047115.8455.531.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1480046337-9521-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33844 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbcKYFOa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2016 00:14:30 -0500
Received: by mail-pg0-f45.google.com with SMTP id x23so25686947pgx.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 21:14:30 -0800 (PST)
In-Reply-To: <1480046337-9521-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-11-25 at 11:58 +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> I lost one test case in the commit for xt_multiport.
> For example, the rule is "-m multiport --dports 22,80,443".
> When first port is unmatched and the second is matched, the curent codes
> could not return the right result.
> It would return false directly when the first port is unmatched.
> 
> Fixes: dd2602d00f80 ("netfilter: xt_multiport: Use switch case instead
> of multiple condition checks")
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>

Note that the Fixes: tag should immediately precede your
'Signed-off-by:'   

No empty new line between the two tags.

Thanks.


