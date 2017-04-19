From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: tcp: Use TCP_MAX_WSCALE instead of
 literal 14
Date: Wed, 19 Apr 2017 09:22:08 -0700
Message-ID: <1492618928.22296.2.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1492565022-110676-1-git-send-email-gfree.wind@foxmail.com>
         <20170419155822.GA8603@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: gfree.wind@foxmail.com, netfilter-devel@vger.kernel.org,
        Gao Feng <fgao@ikuai8.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33356 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965796AbdDSQWL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:22:11 -0400
Received: by mail-io0-f196.google.com with SMTP id k87so4813881ioi.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 09:22:10 -0700 (PDT)
In-Reply-To: <20170419155822.GA8603@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2017-04-19 at 17:58 +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 19, 2017 at 09:23:42AM +0800, gfree.wind@foxmail.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> > 
> > The window scale may be enlarged from 14 to 15 according to the itef
> > draft https://tools.ietf.org/html/draft-nishida-tcpm-maxwin-03.
> > 
> > Use the macro TCP_MAX_WSCALE to support it easily with TCP stack in
> > the future.
> 
> Applied, thanks.

Note that linux kernel is not ready yet for a TCP_MAX_WSCALE being
changed to 15.

Signed 32bit sk counters can already be abused with 1GB TCP windows, for
malicious peers sending SACK forcing linux to increase its memory usage
above 2GB and overflows are pretty bad.




