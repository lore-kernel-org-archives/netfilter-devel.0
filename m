Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72501C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FAA2070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pc7Qh9WE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbfFRJqt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:46:49 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:36783 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbfFRJqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 05:46:48 -0400
Received: by mail-ed1-f49.google.com with SMTP id k21so20774991edq.3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 02:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=qM1XgpG+KcqvehwEbabnC6fhDkTgTXaew/DjqZUh34A=;
        b=Pc7Qh9WEGjLEE+I3XfNFDzWQGM81GIVS6bR2JNaiQ3bGYi2ySjoy+4cbU18DsDGT8X
         MW7JuashEuEd/tVuNWeOddfvc6v+WKB7jwoGgWb6FpkrBdbBjJnYxBMZg8LixF2CWycf
         togRy9FklugInlwkgPD5MgJ+OMWZmvCSWRpviLm9Nod7lgG4SVlk41TmhxHm89gaQXyJ
         ieIjWu69c8StoNySq/eBC+VAiLpEy2UJemyNoAg2/R2wKQNko+TQeq3hPQzpKGnY/xUw
         qhULbV1bNkOBwfoOx0Yna7EUFnXcy1xhcUWmigsVxBYiDxOGzRsQsrZ13LwdnIfRIOhI
         uvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=qM1XgpG+KcqvehwEbabnC6fhDkTgTXaew/DjqZUh34A=;
        b=I9DFN1Hhp4GMAI0jLJTjwwCPwLYyI8KpPgGpzCWfQdh9ORDVvLRYn6hH6uZG6mx59p
         nCll9Ac462Fsw3cuFNw+EH0fMxNdb9u3y5tqfR7Wa3D2psyBWrFiDpujwm+0KKB1Q/EI
         nUaUZqNTfjVihobg/pRASlUnbAcdGcSX00zhMmZfv1mfNcV2QZzD9n6OjcA8CMs4o3PL
         dUlswjuFjWWTG14T5XlCmjxKLBmA0AorbtRtGIGOQnBOgeBL61hXxe8h219FWC63jEG+
         LYRQKxXeWvizOhWVNItl3zInMiDQ26CsTG6cAaL9/8fuL6319zSKobyiQTJnBC5GAcs6
         xrdA==
X-Gm-Message-State: APjAAAVa9R1E+KMf82HQYtCDPH265UX+gegGrv+sSTR2a5/lW5FEVpOg
        9ApQ4qMa5wMSQFSAgoL3HBoPdXucrNeR9gf3sdbuWuwm
X-Google-Smtp-Source: APXvYqyP3i27oGSBTOZoAeeWwxg+9fNeV7jpWOAZGtRsZ5ALrilLtn9P3NVhBfjt8dD0LE/NXMWxmsMHfQreztS8i+U=
X-Received: by 2002:a17:906:553:: with SMTP id k19mr46546801eja.73.1560851207035;
 Tue, 18 Jun 2019 02:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
In-Reply-To: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
From:   Mojtaba <mespio@gmail.com>
Date:   Tue, 18 Jun 2019 14:16:35 +0430
Message-ID: <CABVi_Exnp5vKSJOWwRhvKAPj3sYausMcR9=9AJEODksYvzHKPQ@mail.gmail.com>
Subject: Re: working with libnetfilter_queue and linbetfilter_contrack
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Everyone,
Any idea?

On Mon, Jun 17, 2019 at 2:12 PM Mojtaba <mespio@gmail.com> wrote:
>
> Hello Everyone,
> I am working for a while on two projects (libnetfilter_queue and
> linbetfilter_contrack) to get the decision of destined of packets that
> arrived in our project. It greats to get the control of all packets.
> But I confused a little.
> In my solution i just want to forward all packets that are in the same
> conditions (for example: all packets are received from specific
> IP:PORT address) to another destination. I could add simply add new
> rule in llinbetfilter_contrack list (like the samples that are exist
> in linbetfilter_contrack/utility project).
> But actually i want to use NFQUEUE to get all packets in my user-space
> and then add new rule in linbetfilter_contrack list. In other words,
> the verdict in my sulotions is not ACCEPT or DROP the packet, it
> should add new rule in linbetfilter_contrack list if it is not exist.
> Is it possible?
> I am thinking about this, But  I am not sure it is correct or not?
> For example:
>
> static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
>          struct nfq_data *nfa, void *data)
> {
>    uint32_t id = print_pkt(nfa);
>    printf("entering callback\n");
> if (not exist in list){
> ct = nfct_new();
>    if (ct == NULL) {
>        perror("nfct_new");
>    return 0;
>   }
> Add_to_list();
> }
> return;
> }
>
>
>
> --
> --Mojtaba Esfandiari.S



-- 
--Mojtaba Esfandiari.S
