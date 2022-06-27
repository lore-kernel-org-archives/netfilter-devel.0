Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A94FC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 17:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbiF0RGt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 13:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiF0RGt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 13:06:49 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DF418E02
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 10:06:48 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 93-20020a9d02e6000000b0060c252ee7a4so7804655otl.13
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 10:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XHjlB0mCOXO/leeTIF6/HHtkgvoJuX8r/J5l1BU2Ro4=;
        b=oDI2a385758rzL7a7DRHzL1iZQRhwnvDuTAa1veZC2kS1nNUCCJeMcbhp7O9kdXfFX
         FNgo57Eops3vneGNg2OJ4bsG6X8sOU7/TgoVl6T1Yuz8vDn3CGpiQsLW+0XVlAtKS97A
         3AgGvVqEY7LHJo65e6Sy+pWRqTuYJwyenUTHYSbut0F+1nElexqKXWrzHgAyaFR9Q8lF
         6Kg3hI1kjVK5/FNzrX0pPCearkhQ5PNFOFXw33E9hQ4gOSB6PLgSCpFgP/GipkhNjTbm
         cyaMWcw6UadXxPljVu51KTZHpr1Sq1SQXDAxMnphjrutAbgw1v3YYP67EX3AebMqEv4Y
         xPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XHjlB0mCOXO/leeTIF6/HHtkgvoJuX8r/J5l1BU2Ro4=;
        b=UMi3xyQ7OtDOhW9HvbM7ZuczsUbVHeCCIXl1IpS+2uy7ob8pMViawfaoncnCioonya
         NTyX0Zi2yq6yK00rMY721HcPkle6l+CZH46s7aqq0Du5QB9JLJP6n2NA/cuuSB1tetEf
         VpMcW+tu1IV8lMifVyfnQ0OgihNEVRzXWbQ22X1UG2gQOxsm8IFJdhdapKrNT1p92NF2
         iyqxkxX68IIG0Ot5eRJEyaQl5Xaw415+1hRodavRG2QiPIKIReXE/YEh1aVwn+s8upPm
         ebibF7KXPCelcjKZZiJg8pPYxr3wiqes7VS0CONQcqRmieMwUz6Pwsdtpee+U3v4mrkD
         Y2IQ==
X-Gm-Message-State: AJIora/zni7rwvieV8U3tN6QH5Lrwrwnrrit31lIL2bincS5kH37uJlA
        iz8RpwYLojNp7FD+FAubAvlMpOMWf4U=
X-Google-Smtp-Source: AGRyM1tCWFpB6kNVt9vwAUC/MviT3QVO+NzeC3sIej9sR4JPfF2BRziIGMnUnEILnh9/nbxtKHuMpg==
X-Received: by 2002:a9d:1784:0:b0:60b:f7a8:7cc9 with SMTP id j4-20020a9d1784000000b0060bf7a87cc9mr6431110otj.96.1656349607585;
        Mon, 27 Jun 2022 10:06:47 -0700 (PDT)
Received: from t14s.localdomain ([177.220.172.69])
        by smtp.gmail.com with ESMTPSA id c26-20020a4ae25a000000b0042575b730dbsm6110843oot.45.2022.06.27.10.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 10:06:47 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 4C3AB3231F9; Mon, 27 Jun 2022 14:06:45 -0300 (-03)
Date:   Mon, 27 Jun 2022 14:06:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] flow_table: do not try to add already offloaded
 entries
Message-ID: <YrnjpSUKZdKT1NZO@t14s.localdomain>
References: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
 <c5039f5a-5295-a457-65c5-d7016d6a5034@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5039f5a-5295-a457-65c5-d7016d6a5034@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Oz,

On Mon, Jun 27, 2022 at 06:19:54PM +0300, Oz Shlomo wrote:
> Hi Marcelo,
> 
> On 6/27/2022 5:38 PM, Marcelo Ricardo Leitner wrote:
> > Currently, whenever act_ct tries to match a packet against the flow
> > table, it will also try to refresh the offload. That is, at the end
> > of tcf_ct_flow_table_lookup() it will call flow_offload_refresh().
> > 
> > The problem is that flow_offload_refresh() will try to offload entries
> > that are actually already offloaded, leading to expensive and useless
> > work. Before this patch, with a simple iperf3 test on OVS + TC
> 
> Packets of offloaded connections are expected to process in hardware.
> As such, it is not expected to receive packets in software from offloaded
> connections.
> 
> However, hardware offload may fail due to various reasons (e.g. size limits,
> insertion rate throttling etc.).
> The "refresh" mechanism is the enabler for offload retries.

Thanks for the quick review.

Right. I don't mean to break this mechanism. Act_ct can also be used
in semi/pure sw datapath, and then the premise of packets being
expected to be handled in hw is not valid anymore. I can provide a
more detailed use case if you need.

> 
> 
> > (hw_offload=true) + CT test entirely in sw, it looks like:
> > 
> > - 39,81% tcf_classify
> >     - fl_classify
> >        - 37,09% tcf_action_exec
> >           + 33,18% tcf_mirred_act
> >           - 2,69% tcf_ct_act
> >              - 2,39% tcf_ct_flow_table_lookup
> >                 - 1,67% queue_work_on
> >                    - 1,52% __queue_work
> >                         1,20% try_to_wake_up
> >           + 0,80% tcf_pedit_act
> >        + 2,28% fl_mask_lookup
> > 
> > The patch here aborts the add operation if the entry is already present
> > in hw. With this patch, then:
> > 
> > - 43,94% tcf_classify
> >     - fl_classify
> >        - 39,64% tcf_action_exec
> >           + 38,00% tcf_mirred_act
> >           - 1,04% tcf_ct_act
> >                0,63% tcf_ct_flow_table_lookup
> >        + 3,19% fl_mask_lookup
> > 
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > ---
> >   net/netfilter/nf_flow_table_offload.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 11b6e19420920bc8efda9877af0dab5311c8a096..9a8fc61581400b4e13aa356972d366892bb71b9b 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -1026,6 +1026,9 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
> >   {
> >   	struct flow_offload_work *offload;
> > +	if (test_bit(NF_FLOW_HW, &flow->flags))
> > +		return;
> > +
> 
> This change will make the refresh call obsolete as the NF_FLOW_HW bit is set
> on the first flow offload attempt.

Oh oh.. I was quite sure it was getting cleared when the entry was
removed from HW, but not.

So instead of the if() above, what about:
+       if (test_and_set_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status))

AFAICT it will keep trying while the entry is not present in the flow
table, and stop while it is there. Once the entry is aged from HW, it
is also removed from the flow table, so this part should be okay. 
But if the offload failed for some reason like you said above, and the
entry is left on the flow table, it won't retry until it ages out from
the flow table.

If you expect that this situation can be easily triggered, we may need
to add a rate limit instead then. Even for these connections that
failed to offload, this "busy retrying" is expensive and may backfire
in such situation.

> 
> >   	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
> >   	if (!offload)
> >   		return;
