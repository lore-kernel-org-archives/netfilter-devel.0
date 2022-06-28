Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4603FC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 15:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347227AbiF1PZK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346653AbiF1PZH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 11:25:07 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279E627FFB
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 08:25:06 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-101ec2d6087so17513540fac.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 08:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GuGb2yt7rCyX4KKkKaTrRe+8GxMsmsSqmq8lJ5iszGc=;
        b=JEd8VeKTZT9LpkQkjLLhvVn47AMSxbiwW3DA6L5gnDSRydrAE69cnAdQ9G1q+1Ud1A
         YowILRykHklHWUftl4s0Gvb/L/KrY/Kn+CYRcoV5Kwpwfx0nGK8aahQe3lYcncXv27/q
         FTlxgYjFxKZw++2ZS7qt35w9sBuuXz4sxG1NvnMAo5QIno1GDlsGFySrdrO8sZmDZe+b
         yol7XVwWfJrBWMQ7BFupoL3xKtt8u3f0fYjRC06tNCZFv/JlWyymZFwaqE6xrKIbZeBd
         xsEUZNPqEz9ojhhydHiQ+v8FwueowNpdGT3ZVAS3xODv3CpCcg21Gci5E9YiU6nZ22Sz
         wCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GuGb2yt7rCyX4KKkKaTrRe+8GxMsmsSqmq8lJ5iszGc=;
        b=I8Qdhtt4PBrOsTfyvElF1tB6q7xJQkXXrBfz2CxVax7XXBmceKudTSnIiEC0NT9qEV
         +H6QKRX001WXnocItIvqVN/IuQNngEdOWlD6hmwBFcTUYHxMQe0Cc44S50tf5QHr6xms
         mKi1KxJp8Qo16PVTMWrfF3zaxxP7+Ty8bCVsxPNssoCuBislgzDKi5xhyWiqy7op6SFf
         csf7vGcIkjwFmBbUMaut6oT627PrITuZhwsD9rnXra7E/EPOpgTLzl7BW3Zz35tI5Lkp
         DVnLWmZB7Q2jLDd5Rt8404caJbnAzZKyGO2uN/JOBK1mFs/tWf9IMZZe/QfrH921/blo
         dE0Q==
X-Gm-Message-State: AJIora9p9T5bFH53N5kOmJ+g0sCDTEDmzh+QHyoRyXJCD/g5alPS57vr
        vovUcxFFFX3Bs3YUptflF/MbeU0SD74=
X-Google-Smtp-Source: AGRyM1tzdcPear5z1hs4tPhTRbwGvdQBi2UzI0phG4JlNHjS4OG2/zDrp1vNsE8bo0dUrTbyah5R+Q==
X-Received: by 2002:a05:6870:5b91:b0:108:374a:96b0 with SMTP id em17-20020a0568705b9100b00108374a96b0mr91710oab.126.1656429905323;
        Tue, 28 Jun 2022 08:25:05 -0700 (PDT)
Received: from t14s.localdomain ([177.220.172.69])
        by smtp.gmail.com with ESMTPSA id s204-20020acadbd5000000b003356a9079d2sm3455717oig.9.2022.06.28.08.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 08:25:05 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 3513832682A; Tue, 28 Jun 2022 12:25:02 -0300 (-03)
Date:   Tue, 28 Jun 2022 12:25:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] flow_table: do not try to add already offloaded
 entries
Message-ID: <YrsdTrDaQh+JjSpn@t14s.localdomain>
References: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
 <c5039f5a-5295-a457-65c5-d7016d6a5034@nvidia.com>
 <YrnjpSUKZdKT1NZO@t14s.localdomain>
 <d6b97751-019b-7b81-f4e9-076aaedbbc91@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6b97751-019b-7b81-f4e9-076aaedbbc91@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 28, 2022 at 04:13:05PM +0300, Oz Shlomo wrote:
> Hi Marcelo,
> 
> 
> On 6/27/2022 8:06 PM, Marcelo Ricardo Leitner wrote:
> > Hi Oz,
> > 
> > On Mon, Jun 27, 2022 at 06:19:54PM +0300, Oz Shlomo wrote:
> > > Hi Marcelo,
> > > 
> > > On 6/27/2022 5:38 PM, Marcelo Ricardo Leitner wrote:
> > > > Currently, whenever act_ct tries to match a packet against the flow
> > > > table, it will also try to refresh the offload. That is, at the end
> > > > of tcf_ct_flow_table_lookup() it will call flow_offload_refresh().
> > > > 
> > > > The problem is that flow_offload_refresh() will try to offload entries
> > > > that are actually already offloaded, leading to expensive and useless
> > > > work. Before this patch, with a simple iperf3 test on OVS + TC
> > > 
> > > Packets of offloaded connections are expected to process in hardware.
> > > As such, it is not expected to receive packets in software from offloaded
> > > connections.
> > > 
> > > However, hardware offload may fail due to various reasons (e.g. size limits,
> > > insertion rate throttling etc.).
> > > The "refresh" mechanism is the enabler for offload retries.
> > 
> > Thanks for the quick review.
> > 
> > Right. I don't mean to break this mechanism. Act_ct can also be used
> > in semi/pure sw datapath, and then the premise of packets being
> > expected to be handled in hw is not valid anymore. I can provide a
> > more detailed use case if you need.
> 
> It is clear that the refresh design introduces some overhead when act_ct is
> used in a pure sw datapath.

Cool.

> 
> > 
> > > 
> > > 
> > > > (hw_offload=true) + CT test entirely in sw, it looks like:
> > > > 
> > > > - 39,81% tcf_classify
> > > >      - fl_classify
> > > >         - 37,09% tcf_action_exec
> > > >            + 33,18% tcf_mirred_act
> > > >            - 2,69% tcf_ct_act
> > > >               - 2,39% tcf_ct_flow_table_lookup
> > > >                  - 1,67% queue_work_on
> > > >                     - 1,52% __queue_work
> > > >                          1,20% try_to_wake_up
> > > >            + 0,80% tcf_pedit_act
> > > >         + 2,28% fl_mask_lookup
> > > > 
> > > > The patch here aborts the add operation if the entry is already present
> > > > in hw. With this patch, then:
> > > > 
> > > > - 43,94% tcf_classify
> > > >      - fl_classify
> > > >         - 39,64% tcf_action_exec
> > > >            + 38,00% tcf_mirred_act
> > > >            - 1,04% tcf_ct_act
> > > >                 0,63% tcf_ct_flow_table_lookup
> > > >         + 3,19% fl_mask_lookup
> > > > 
> > > > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > > ---
> > > >    net/netfilter/nf_flow_table_offload.c | 3 +++
> > > >    1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > > > index 11b6e19420920bc8efda9877af0dab5311c8a096..9a8fc61581400b4e13aa356972d366892bb71b9b 100644
> > > > --- a/net/netfilter/nf_flow_table_offload.c
> > > > +++ b/net/netfilter/nf_flow_table_offload.c
> > > > @@ -1026,6 +1026,9 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
> > > >    {
> > > >    	struct flow_offload_work *offload;
> > > > +	if (test_bit(NF_FLOW_HW, &flow->flags))
> > > > +		return;
> > > > +
> > > 
> > > This change will make the refresh call obsolete as the NF_FLOW_HW bit is set
> > > on the first flow offload attempt.
> > 
> > Oh oh.. I was quite sure it was getting cleared when the entry was
> > removed from HW, but not.
> > 
> > So instead of the if() above, what about:
> > +       if (test_and_set_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status))
> 
> I think this will set the IPS_HW_OFFLOAD_BIT prematurely.
> Currently this bit is set only when the the flow has been successfully
> offloaded.

Indeed. It was my cat that typed _and_set in there. ;-] (joking) sorry.

> 
> > 
> > AFAICT it will keep trying while the entry is not present in the flow
> > table, and stop while it is there. Once the entry is aged from HW, it
> > is also removed from the flow table, so this part should be okay.
> > But if the offload failed for some reason like you said above, and the
> > entry is left on the flow table, it won't retry until it ages out from
> > the flow table.
> 
> But then we will never have the chance to re-install it in hardware while
> the connection is still active.

Unless it goes idle, yes.

> 
> > 
> > If you expect that this situation can be easily triggered, we may need
> > to add a rate limit instead then. Even for these connections that
> > failed to offload, this "busy retrying" is expensive and may backfire
> > in such situation.
> 
> Perhaps we can refresh only if the flow_block callbacks list is not empty.

It may not be empty even for sw datapath. If you have packets coming
from the wire towards a veth/virtio, for example. It will likely
having a matching act_ct with the same zone number on both directions.
And/or if a zone is shared, as the the flow table then is also shared.

> 
> 
> > 
> > > 
> > > >    	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
> > > >    	if (!offload)
> > > >    		return;
