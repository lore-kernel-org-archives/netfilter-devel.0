From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Tue, 16 Jan 2018 02:23:34 +0100
Message-ID: <20180116012334.2g4o3dmpux7fbapc@salvia>
References: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
 <20171228105236.hmii7xbk5jtctmpr@salvia>
 <20171230225110.GA10178@dimstar.local.net>
 <20171230231630.qvfkstglqwhrpsff@salvia>
 <20180102224746.GB3309@dimstar.local.net>
 <20180115014532.GA13839@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750798AbeAPBXr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 20:23:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E01FA53AA26
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 02:23:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3282DA84D
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 02:23:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180115014532.GA13839@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 15, 2018 at 12:45:32PM +1100, Duncan Roe wrote:
> On Wed, Jan 03, 2018 at 09:47:46AM +1100, Duncan Roe wrote:
> > On Sun, Dec 31, 2017 at 12:16:30AM +0100, Pablo Neira Ayuso wrote:
> ...
> > > > > @Duncan: I think you can update the wiki again after this, given that
> > > > > now those values should not be printed.
> > > >
> The examples now work as intended, so I updated the wiki. (INPUT is now being
> translated to input btw).
> 
> It is still the case that if the iptables command specifies default burst or
> timeout then nothing is output for these, including the yetch case of specifying
> a limit (with or w/out a burst) and getting no timeout.

I think we should always print the timeout. This timeout depends on
umult which depends on the specified rate, inconditionally.

Burst, I think it's fine if we just provide a shorter translation
default value is specified.

Well, now the translation is correct as we don't print burst twice.

Anyway, if the translation is semantically correct and it works fine,
then this is fair good enough.

We're just provide a quick translation to ease migration, users will
have to look into specific nftables details sooner or later I guess.

Thanks.
