From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] libnetfilter_conntrack: bump version to 1.0.7
Date: Mon, 17 Jul 2017 18:28:48 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1707171808410.32562@n3.vanv.qr>
References: <20170710203350.29166-1-richard@nod.at> <20170717154014.GA32112@salvia> <2f1aae18-6706-dd67-654d-1146c035c0d5@nod.at> <20170717160316.GA573@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Richard Weinberger <richard@nod.at>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:48916 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751335AbdGQQ2u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 12:28:50 -0400
In-Reply-To: <20170717160316.GA573@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2017-07-17 18:03, Pablo Neira Ayuso wrote:
>
>IIRC, we should always bump current and version even if no changes
>happen. Rules are here:
>
>http://git.netfilter.org/libmnl/tree/Make_global.am

If I read those rules correctly -

 "If any interfaces have been added"

- then, since no interface was added, removed, or otherwise modified, no bump
is the right thing.
