From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: warn users about queue
 allocation errors
Date: Tue, 2 May 2017 12:03:32 +0200
Message-ID: <20170502100332.GE2321@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270928606.1751.8172963085482513292.stgit@nfdev2.cica.es>
 <20170425113401.GA5355@salvia>
 <CAOkSjBh8rV0U1FjWYsOetKBzGyzMH4dx44ir+h6CikZdrWS5Eg@mail.gmail.com>
 <20170425131653.GA1050@salvia>
 <CAOkSjBh47LuV_MyqmfruQ2JeY0-jqs1+fQLs+eTyRUEWL3ui+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750792AbdEBKDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2017 06:03:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F0CF2EFEA2
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2017 12:03:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00820FF2D0
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2017 12:03:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E476BFF124
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2017 12:03:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBh47LuV_MyqmfruQ2JeY0-jqs1+fQLs+eTyRUEWL3ui+w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 02, 2017 at 10:34:12AM +0200, Arturo Borrero Gonzalez wrote:
> On 25 April 2017 at 15:16, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Yes, but this is going to full the logs if ever happen.
> >
> > Better add stats:
> >
> >         /* statistics */
> >         struct {
> >                 uint64_t        msg_rcv_malformed;
> >                 uint32_t        msg_rcv_bad_version;
> >                 uint32_t        msg_rcv_bad_payload;
> >                 uint32_t        msg_rcv_bad_header;
> >                 uint32_t        msg_rcv_bad_type;
> >                 uint32_t        msg_rcv_truncated;
> >                 uint32_t        msg_rcv_bad_size;
> >                 uint32_t        msg_snd_malformed;
> >                 uint64_t        msg_rcv_lost;
> >                 uint64_t        msg_rcv_before;
> >         } error;
> >
> > A quick glance at the code to see how we're globaling deal with lack
> > of memory would be good. There's little we can do in that situation,
> > and in my experience this most likely point to a memory leak.
> >
> > So better follow a less agressive way than filling the logs, OK? We
> > indeed have a way to report this via the existing -s options.
> 
> Ok, then I can drop this patch from the series and add later a couple
> more of stats.

Great. Thanks Arturo.
