Return-Path: <SRS0=irZF=R4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8ADFC10F03
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84B4B20879
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sysclose.org header.i=fbl@sysclose.org header.b="QJcGnqyM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfCYOjK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:39:10 -0400
Received: from sender-of-o51.zoho.com ([135.84.80.216]:21144 "EHLO
        sender-of-o51.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfCYOjK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:39:10 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1553524742; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=ga2z1wlUGey/MdCxKlYB0d+OREpvx8uIlFinYDNcAWJOCV683y2Q/FKuSzOoV7GfRt44U/Cf/mxA5NYDtaGUEXB8FDJiUuYR4SxHIYAw0J0sLqRjpxm+gBaFNKTydtT8CxSvh8YbP2X6KDgopP0GAJQy09Qm7pRgwqUGxJiLHko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1553524742; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=CvZ40L+BUtgbeSNj/bs7PAxnfE80iSDoJLwBGkTpsoM=; 
        b=Ewo/uhOv7Z98VZR9B5HC1z5q20OZxbtvvaVZbvS8wXuBkKj5Le4WibrdpTYDHyuFxIf5aY113RFTO3LBfB9jeBjyXWNNsyr8gaKXK1tj6SGT1YrTs8wnVKc1bea812A23B+df4vf9/SkfiqAwP2MacVHKaghPrWTTUikdrt7X7g=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=sysclose.org;
        spf=pass  smtp.mailfrom=fbl@sysclose.org;
        dmarc=pass header.from=<fbl@sysclose.org> header.from=<fbl@sysclose.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1553524742;
        s=zoho; d=sysclose.org; i=fbl@sysclose.org;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=1578; bh=CvZ40L+BUtgbeSNj/bs7PAxnfE80iSDoJLwBGkTpsoM=;
        b=QJcGnqyMs7kXPJzZxxbILQEBe7cSyw0aYOOHgXeqBjSA2+jBPPasmrHWlU3GUUIR
        zgVxGSp7iGlE+Ra7VfinkFiSglldga+M5cZE0Wwx6XJIubaxla2Vsq3XIfo24ngg7IS
        2Yl5Z+yVIlii1nyexkmHnXu+kzdxntMY3yxLBvL0=
Received: from localhost (177.183.215.126 [177.183.215.126]) by mx.zohomail.com
        with SMTPS id 155352473507040.58492287840795; Mon, 25 Mar 2019 07:38:55 -0700 (PDT)
Date:   Mon, 25 Mar 2019 11:38:51 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@ovn.org>, ovs dev <dev@openvswitch.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] openvswitch: add seqadj extension when NAT is
 used.
Message-ID: <20190325143851.GA5037@p50>
References: <20190321165224.24118-1-fbl@sysclose.org>
 <CAOrHB_CActmZPWipq6chM0SXAkTsODuHFyVMTdL8idCjB-Vecw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_CActmZPWipq6chM0SXAkTsODuHFyVMTdL8idCjB-Vecw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-ZohoMailClient: External
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 23, 2019 at 12:32:37PM -0700, Pravin Shelar wrote:
> On Thu, Mar 21, 2019 at 9:52 AM Flavio Leitner <fbl@sysclose.org> wrote:
> >
> > When the conntrack is initialized, there is no helper attached
> > yet so the nat info initialization (nf_nat_setup_info) skips
> > adding the seqadj ext.
> >
> > A helper is attached later when the conntrack is not confirmed
> > but is going to be committed. In this case, if NAT is needed then
> > adds the seqadj ext as well.
> >
> > Fixes: 16ec3d4fbb96 ("openvswitch: Fix cached ct with helper.")
> > Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> > ---
> >  net/openvswitch/conntrack.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> I am not able to apply this patch.

This is for Davem net-next. I got the patch from ML and it worked for
me.


> > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > index 1b6896896fff..a7664515c943 100644
> > --- a/net/openvswitch/conntrack.c
> > +++ b/net/openvswitch/conntrack.c
> > @@ -990,6 +990,11 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
> >                                                             GFP_ATOMIC);
> >                         if (err)
> >                                 return err;
> > +
> > +                       if (info->nat && nfct_help(ct) && !nfct_seqadj(ct)) {
> Given helper is just assigned, is nfct_help() check required here?

I tried to be very clear, but you're right that it's not required.
I will post a v2 removing that.
Thanks
fbl

> 
> > +                               if (!nfct_seqadj_ext_add(ct))
> > +                                       return -EINVAL;
> > +                       }
> >                 }
> >
> >                 /* Call the helper only if:
> > --
> > 2.20.1
> >
> >
> >

