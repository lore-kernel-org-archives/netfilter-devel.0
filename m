From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_hashlimit: fix uint64_t printf
 formats
Date: Mon, 29 May 2017 14:17:55 +0200
Message-ID: <20170529121755.GA14029@salvia>
References: <1495610038-29297-1-git-send-email-alin.nastac@technicolor.com>
 <20170529120208.GA11167@salvia>
 <CAF1oqRCC+GCYh5vXWDRsen=7vRhAfN3n_vXrL3jTO1AmLMRZEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Alin =?utf-8?Q?N=C4=83stac?= <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdE2MSI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 08:18:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 961F2303D02
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:17:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C6F2FF6FE
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:17:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C57E100A41
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:17:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAF1oqRCC+GCYh5vXWDRsen=7vRhAfN3n_vXrL3jTO1AmLMRZEg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 29, 2017 at 02:11:39PM +0200, Alin Năstac wrote:
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
> That's odd, burst field of hashlimit_cfg2 struct is supposed to be an
> __u64 integer (see include/linux/netfilter/xt_hashlimit.h line 68).
> Probably you include the wrong header file.

Yes, this is strange. I'm just giving a quick compilation test on my
laptop using the git tree and I hit this. Hm.
