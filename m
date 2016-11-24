From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: "random" syn packets dropped
Date: Thu, 24 Nov 2016 14:56:06 +0100
Message-ID: <20161124135606.GA990@salvia>
References: <CAJO99TnMCZdROCNV9-3xcURbGZVw7X-wKwf-vkUc5Lc3R_QT9A@mail.gmail.com>
 <20161108140857.GE24908@breakpoint.cc>
 <CAJO99Tmx03GrL4MUY-PW=V5ZhpfWwndFJSkeomO34Ldfq_1DCg@mail.gmail.com>
 <CAJO99T=MK=kPe9NVXPtaHBcurtc6KYnat=YCOtBRsTH-uh-ZLQ@mail.gmail.com>
 <CAJO99TmfVSALaXqfCvZaoB7i_=KxCh1KaBgRcXSYWEL6Gj+qiQ@mail.gmail.com>
 <20161121103919.GA22120@breakpoint.cc>
 <CAJO99TkDRo-M_PpGEwbK1r7cxr_ZLdF7yBXZ95+SJXoj0732HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36634 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964862AbcKXN4L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 08:56:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A3746DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:56:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93932DA853
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:56:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DA96DA853
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:56:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAJO99TkDRo-M_PpGEwbK1r7cxr_ZLdF7yBXZ95+SJXoj0732HA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 24, 2016 at 02:37:30PM +0100, Bjørnar Ness wrote:
> Hello, Florian
> 
> I applied the patches to net-next, but unfortunately this did fix the
> bug I am seeing,
> in addition, now the bug seems to appear immediately (also with
> previous kernel),
> not after ~10 days as I have seen before.

If you revert this, do you still hit problems?

commit 870190a9ec9075205c0fa795a09fa931694a3ff1
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Jul 5 12:07:24 2016 +0200

    netfilter: nat: convert nat bysrc hash to rhashtable

It would be good to bisect to make sure this is related to the
rhashtable conversion.

Let us know,
Thanks Bjørnar.
