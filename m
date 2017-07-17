From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: bump version to 1.0.7
Date: Mon, 17 Jul 2017 18:03:16 +0200
Message-ID: <20170717160316.GA573@salvia>
References: <20170710203350.29166-1-richard@nod.at>
 <20170717154014.GA32112@salvia>
 <2f1aae18-6706-dd67-654d-1146c035c0d5@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44780 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751314AbdGQQDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 12:03:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0694F2492E
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:03:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EAB65D1CCC
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:03:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99C90A7F26
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:03:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <2f1aae18-6706-dd67-654d-1146c035c0d5@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 17, 2017 at 05:57:58PM +0200, Richard Weinberger wrote:
> Pablo,
> 
> Am 17.07.2017 um 17:40 schrieb Pablo Neira Ayuso:
> > On Mon, Jul 10, 2017 at 10:33:50PM +0200, Richard Weinberger wrote:
> >> This is a maintenance release, so the version is just bumped to 1.0.7.
> > 
> > Applied, thanks.
> > 
> > P.S: I have also updated libversion, so I have mangled this patch.
> 
> I thought about this but didn't since the version change to 1.0.5 also
> didn't not and AFAICT the interface didn't change.
>
> In order to avoid future overhead for you, what are the rules regarding
> libversion updates?

IIRC, we should always bump current and version even if no changes
happen. Rules are here:

http://git.netfilter.org/libmnl/tree/Make_global.am

P.S: If I did not do it for 1.0.5, that was my fault, sorry.
