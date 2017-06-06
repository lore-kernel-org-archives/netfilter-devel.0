From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next RFC 0/5] netfilter: add net namespace support for
 cthelper
Date: Tue, 6 Jun 2017 02:04:48 +0200
Message-ID: <20170606000448.GA2608@salvia>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
 <20170604160753.GA843@breakpoint.cc>
 <CAML_gOf3dW1kVpyObPZoHWSb44DX3w6vhsWXq11xwFU2pFnvFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45352 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbdFFAE6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 20:04:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 677EB8D0509
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 02:04:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 453DC102180
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 02:04:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D36AFFF6F5
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 02:04:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOf3dW1kVpyObPZoHWSb44DX3w6vhsWXq11xwFU2pFnvFA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 05, 2017 at 01:11:19PM +0800, Liping Zhang wrote:
> Hi Florian & Pablo,
> 
> 2017-06-05 0:07 GMT+08:00 Florian Westphal <fw@strlen.de>:
> > Liping Zhang <zlpnobody@163.com> wrote:
> >> This patch set aims to add net namespace support for the ct helper,
> >> it is a little large, but I try my best to split them to a relative
> >> smaller patches, which will help to review. Comments are welcome.
> >
> > Why?  Could you explain what kind of functionality is added here, or
> > what problem is fixed?
> >
> > Why do we need per netns complexity for helpers?
> 
> I remembered Pablo told me that the ct helpers "is probably one of
> the remaining subsystems not having netns support", when I sent
> patches to fix other issues.
>
> So I try to accomplish the netns support for ct helpers.
> (see https://patchwork.ozlabs.org/patch/740692/).

I was referring to cthelper infrastructure, right? So you add
possible_net to struct nfnl_cthelper?
