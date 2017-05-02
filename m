From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: warn users about queue
 allocation errors
Date: Tue, 2 May 2017 10:34:12 +0200
Message-ID: <CAOkSjBh47LuV_MyqmfruQ2JeY0-jqs1+fQLs+eTyRUEWL3ui+w@mail.gmail.com>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270928606.1751.8172963085482513292.stgit@nfdev2.cica.es>
 <20170425113401.GA5355@salvia> <CAOkSjBh8rV0U1FjWYsOetKBzGyzMH4dx44ir+h6CikZdrWS5Eg@mail.gmail.com>
 <20170425131653.GA1050@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:34575 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752076AbdEBIee (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2017 04:34:34 -0400
Received: by mail-it0-f44.google.com with SMTP id 131so7512908itz.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 May 2017 01:34:33 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com. [209.85.223.181])
        by smtp.gmail.com with ESMTPSA id m1sm567229iti.21.2017.05.02.01.34.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 May 2017 01:34:33 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id r16so150699501ioi.2
        for <netfilter-devel@vger.kernel.org>; Tue, 02 May 2017 01:34:33 -0700 (PDT)
In-Reply-To: <20170425131653.GA1050@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 April 2017 at 15:16, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Yes, but this is going to full the logs if ever happen.
>
> Better add stats:
>
>         /* statistics */
>         struct {
>                 uint64_t        msg_rcv_malformed;
>                 uint32_t        msg_rcv_bad_version;
>                 uint32_t        msg_rcv_bad_payload;
>                 uint32_t        msg_rcv_bad_header;
>                 uint32_t        msg_rcv_bad_type;
>                 uint32_t        msg_rcv_truncated;
>                 uint32_t        msg_rcv_bad_size;
>                 uint32_t        msg_snd_malformed;
>                 uint64_t        msg_rcv_lost;
>                 uint64_t        msg_rcv_before;
>         } error;
>
> A quick glance at the code to see how we're globaling deal with lack
> of memory would be good. There's little we can do in that situation,
> and in my experience this most likely point to a memory leak.
>
> So better follow a less agressive way than filling the logs, OK? We
> indeed have a way to report this via the existing -s options.

Ok, then I can drop this patch from the series and add later a couple
more of stats.
