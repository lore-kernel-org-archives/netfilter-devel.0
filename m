Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C460C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 15:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348107AbiF1Pox (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347958AbiF1Pol (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 11:44:41 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD58236B50
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 08:44:40 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-101d2e81bceso17669273fac.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 08:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D8Q9w7QOciFFQ5lDafFNnz3evVfZkuWJdS4yuwffOQY=;
        b=a5VVVJgYeSW6bkwpIrY4o96+rYasgaX32AFHgZewMWpD/dNr4zA7QsCSy7B+1LGzVC
         kyWldS9HDAGf8OyHjH197pVG53F3x3uNoa28l9BvdD7C2NoNpxX/HHJh1uO0fb93qWVW
         MZrY0wnKyVa0M24tdsC9bZ7DH6K0FNZyk/fBXCjna+RGuvZdKYxJ/Mlucln6QE4pzNiI
         97bVYRdEUbyLxp3gqK1o36ZYxG73SRUIA45FruvDvE4yX3beDP68mbt4sVbvnYB9lLLC
         hHpHo0fD9p4jIhLpKsrD9KLfur9+pTp1pHHqYYcqJZLDUDtC8GWZt6cntEl8vwjK/FnG
         j8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D8Q9w7QOciFFQ5lDafFNnz3evVfZkuWJdS4yuwffOQY=;
        b=dsIzzTrQBDlyk0m1cWHfPDNHZpSafduauQuFeWqDE8EkMVvI+nQmL+CWgEJOj+g3hK
         LZYXFl2o8TJMpHy7qhICdjyAol/d6ZMldNECGqz9WuDbkg70pNwpG7SWE1sw03Hje4qk
         bL3fFeAQZtLW4yPs0w6zqSaHl+0Lk4r2k99VG3KOyIXSJtdZeyQkA1vgjsUEEdCqpxOr
         HiVy94E+RPukSu2AdQXqSZIH0T0MqyLJ7v0JvKpvogQqfbTosDUTks4KIbNhns378aUh
         rftTacHkM7xeH3FMo7bqijGhuhlYWA4joQ732zeYT73oVnHZSu1UITn8XhKFjNXh5kdf
         dXZg==
X-Gm-Message-State: AJIora8oh97i49CiIHZCkvR4GfoAbeUTy/XQWdcZQiW4fPc80GqdY1RH
        7DVPL6uPGHnsbdfIeCRkQMJk9QX3xyM=
X-Google-Smtp-Source: AGRyM1tZx8nNXmgIdsJrU1ojBQL2pBpcGKLHTpZq04UiHZ95/DrWrwGpk2tBPbat8oAXt1g0lb3SGg==
X-Received: by 2002:a05:6870:fb86:b0:101:d587:cc1a with SMTP id kv6-20020a056870fb8600b00101d587cc1amr114759oab.127.1656431080062;
        Tue, 28 Jun 2022 08:44:40 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f016:166b:c3a:b4d:ea8b:92aa])
        by smtp.gmail.com with ESMTPSA id j19-20020a056808057300b0032f2ccdafc9sm7240110oig.3.2022.06.28.08.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 08:44:39 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 02E493268EC; Tue, 28 Jun 2022 12:44:38 -0300 (-03)
Date:   Tue, 28 Jun 2022 12:44:37 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] flow_table: do not try to add already offloaded
 entries
Message-ID: <Yrsh5ZN710BN4U8J@t14s.localdomain>
References: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
 <c5039f5a-5295-a457-65c5-d7016d6a5034@nvidia.com>
 <YrnjpSUKZdKT1NZO@t14s.localdomain>
 <d6b97751-019b-7b81-f4e9-076aaedbbc91@nvidia.com>
 <YrsdTrDaQh+JjSpn@t14s.localdomain>
 <3f2dc8de-b7bc-f289-07fa-8a92d8618331@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f2dc8de-b7bc-f289-07fa-8a92d8618331@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 28, 2022 at 06:34:26PM +0300, Oz Shlomo wrote:
> 
> 
> On 6/28/2022 6:25 PM, Marcelo Ricardo Leitner wrote:
> > On Tue, Jun 28, 2022 at 04:13:05PM +0300, Oz Shlomo wrote:
> > > Hi Marcelo,
> > > 
> > > 
> > > On 6/27/2022 8:06 PM, Marcelo Ricardo Leitner wrote:
> > > > Hi Oz,
> > > > 
> > > > On Mon, Jun 27, 2022 at 06:19:54PM +0300, Oz Shlomo wrote:
> > > > > Hi Marcelo,
> > > > > 
> > > > > On 6/27/2022 5:38 PM, Marcelo Ricardo Leitner wrote:
> > > > > > Currently, whenever act_ct tries to match a packet against the flow
> > > > > > table, it will also try to refresh the offload. That is, at the end
> > > > > > of tcf_ct_flow_table_lookup() it will call flow_offload_refresh().
> > > > > > 
> > > > > > The problem is that flow_offload_refresh() will try to offload entries
> > > > > > that are actually already offloaded, leading to expensive and useless
> > > > > > work. Before this patch, with a simple iperf3 test on OVS + TC
> > > > > 
> > > > > Packets of offloaded connections are expected to process in hardware.
> > > > > As such, it is not expected to receive packets in software from offloaded
> > > > > connections.
> > > > > 
> > > > > However, hardware offload may fail due to various reasons (e.g. size limits,
> > > > > insertion rate throttling etc.).
> > > > > The "refresh" mechanism is the enabler for offload retries.
> > > > 
> > > > Thanks for the quick review.
> > > > 
> > > > Right. I don't mean to break this mechanism. Act_ct can also be used
> > > > in semi/pure sw datapath, and then the premise of packets being
> > > > expected to be handled in hw is not valid anymore. I can provide a
> > > > more detailed use case if you need.
> > > 
> > > It is clear that the refresh design introduces some overhead when act_ct is
> > > used in a pure sw datapath.
> > 
> > Cool.
> > 
> > > 
> > > > 
> > > > > 
> > > > > 
> > > > > > (hw_offload=true) + CT test entirely in sw, it looks like:
> > > > > > 
> > > > > > - 39,81% tcf_classify
> > > > > >       - fl_classify
> > > > > >          - 37,09% tcf_action_exec
> > > > > >             + 33,18% tcf_mirred_act
> > > > > >             - 2,69% tcf_ct_act
> > > > > >                - 2,39% tcf_ct_flow_table_lookup
> > > > > >                   - 1,67% queue_work_on
> > > > > >                      - 1,52% __queue_work
> > > > > >                           1,20% try_to_wake_up
> > > > > >             + 0,80% tcf_pedit_act
> > > > > >          + 2,28% fl_mask_lookup
> > > > > > 
> > > > > > The patch here aborts the add operation if the entry is already present
> > > > > > in hw. With this patch, then:
> > > > > > 
> > > > > > - 43,94% tcf_classify
> > > > > >       - fl_classify
> > > > > >          - 39,64% tcf_action_exec
> > > > > >             + 38,00% tcf_mirred_act
> > > > > >             - 1,04% tcf_ct_act
> > > > > >                  0,63% tcf_ct_flow_table_lookup
> > > > > >          + 3,19% fl_mask_lookup
> > > > > > 
> > > > > > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > > > > ---
> > > > > >     net/netfilter/nf_flow_table_offload.c | 3 +++
> > > > > >     1 file changed, 3 insertions(+)
> > > > > > 
> > > > > > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > > > > > index 11b6e19420920bc8efda9877af0dab5311c8a096..9a8fc61581400b4e13aa356972d366892bb71b9b 100644
> > > > > > --- a/net/netfilter/nf_flow_table_offload.c
> > > > > > +++ b/net/netfilter/nf_flow_table_offload.c
> > > > > > @@ -1026,6 +1026,9 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
> > > > > >     {
> > > > > >     	struct flow_offload_work *offload;
> > > > > > +	if (test_bit(NF_FLOW_HW, &flow->flags))
> > > > > > +		return;
> > > > > > +
> > > > > 
> > > > > This change will make the refresh call obsolete as the NF_FLOW_HW bit is set
> > > > > on the first flow offload attempt.
> > > > 
> > > > Oh oh.. I was quite sure it was getting cleared when the entry was
> > > > removed from HW, but not.
> > > > 
> > > > So instead of the if() above, what about:
> > > > +       if (test_and_set_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status))
> > > 
> > > I think this will set the IPS_HW_OFFLOAD_BIT prematurely.
> > > Currently this bit is set only when the the flow has been successfully
> > > offloaded.
> > 
> > Indeed. It was my cat that typed _and_set in there. ;-] (joking) sorry.
> > 
> > > 
> > > > 
> > > > AFAICT it will keep trying while the entry is not present in the flow
> > > > table, and stop while it is there. Once the entry is aged from HW, it
> > > > is also removed from the flow table, so this part should be okay.
> > > > But if the offload failed for some reason like you said above, and the
> > > > entry is left on the flow table, it won't retry until it ages out from
> > > > the flow table.
> > > 
> > > But then we will never have the chance to re-install it in hardware while
> > > the connection is still active.
> > 
> > Unless it goes idle, yes.
> > 
> > > 
> > > > 
> > > > If you expect that this situation can be easily triggered, we may need
> > > > to add a rate limit instead then. Even for these connections that
> > > > failed to offload, this "busy retrying" is expensive and may backfire
> > > > in such situation.
> > > 
> > > Perhaps we can refresh only if the flow_block callbacks list is not empty.
> > 
> > It may not be empty even for sw datapath. If you have packets coming
> > from the wire towards a veth/virtio, for example. It will likely
> > having a matching act_ct with the same zone number on both directions.
> > And/or if a zone is shared, as the the flow table then is also shared.
> 
> Hmm, I was thinking that you are targeting the use case of deployments with
> no ct offload supporting hardware.

Ahh.

> 
> CT action is usually proceeded by a goto action. So, a filter with ct and
> goto action list will offload even if the last chain forwards to a
> veth/virtio device.

Right, but there's the outbound traffic. Traffic coming from a
container that is using veth, and going out to the wire.
And also traffic from one container to another in the same host, that
can also trigger this, if at least one of them is not annotated to use
the offloading.
These will be using ingress tc filters on veth interfaces, which won't
offload.

> 
> > 
> > > 
> > > 
> > > > 
> > > > > 
> > > > > >     	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
> > > > > >     	if (!offload)
> > > > > >     		return;
