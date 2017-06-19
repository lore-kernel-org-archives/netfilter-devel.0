From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_hashlimit: fix uint64_t printf
 formats
Date: Mon, 19 Jun 2017 19:26:58 +0200
Message-ID: <20170619172658.GA16419@salvia>
References: <1495610038-29297-1-git-send-email-alin.nastac@technicolor.com>
 <20170529120208.GA11167@salvia>
 <CAF1oqRCxKcEBMGTKqD6PCoGBOkwxr2TRz7j9pz_h4VWQZe-9Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Alin =?utf-8?Q?N=C4=83stac?= <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751385AbdFSR1E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:27:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 130F02E7840
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:26:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06AF68F48
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:26:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 165DA20511
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:26:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAF1oqRCxKcEBMGTKqD6PCoGBOkwxr2TRz7j9pz_h4VWQZe-9Kw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 29, 2017 at 02:18:51PM +0200, Alin Năstac wrote:
> On Mon, May 29, 2017 at 2:02 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, May 24, 2017 at 09:13:58AM +0200, Alin Nastac wrote:
> >> From: Alin Nastac <alin.nastac@gmail.com>
> >>
> >> The remaining %llu formats are used for unsigned long long values.
> >
> > Hm, still problems here:
> >
> > libxt_hashlimit.c: In function ‘hashlimit_mt_print’:
> > libxt_hashlimit.c:739:3: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘__u64’ [-Wformat=]   printf(" burst %"PRIu64, cfg->burst);
> >    printf(" burst %"PRIu64, cfg->burst);
> >    ^
> > libxt_hashlimit.c: In function ‘hashlimit_mt_save’:
> > libxt_hashlimit.c:849:3: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘__u64’ [-Wformat=]
> >    printf(" --hashlimit-burst %"PRIu64, cfg->burst);
> 
> On second thought, seems that "%"PRIu64 is equivalent in your case
> with "%lu". Maybe it is better to replace all %"PRIu64" with %llu.
> After all, uint64_t is supposed to be unsigned long long on all
> architectures, isn't it so?

long unsigned int here is 64-bits. But it takes processor word size.

I'm inclined to think we should just cast the __u64 to uint64_t to
sort out this, and use PRIu64.
