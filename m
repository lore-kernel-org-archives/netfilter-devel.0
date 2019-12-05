Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E25EC43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 11:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3F32464E
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 11:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uc8fP9nq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfLELe6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 06:34:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39824 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729017AbfLELe6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 06:34:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575545697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MKtp+WpNbuhLdMOTzJSR1yYLCXWsbks7EQnS7Btik7w=;
        b=Uc8fP9nqzDDzX4PPoHcP433zo+CfPP2U4jeres1/Lwo6BYeTD5J5dLSTtYSeyzf3ha7xwJ
        ZLciMSdyMw11nD8tB2F6v00uRBELECI2FcTpgKMstWd6rYas7YxCyHfDrsH4S8pjKiF8x4
        DBBZmjLrV/AA8woAPjqtculdsF6tHdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-xbE10sRQP4q31QuuOc3OMw-1; Thu, 05 Dec 2019 06:34:54 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55601107ACC4;
        Thu,  5 Dec 2019 11:34:51 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94F2B1D1;
        Thu,  5 Dec 2019 11:34:45 +0000 (UTC)
Date:   Thu, 5 Dec 2019 12:34:43 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        lvs-users@linuxvirtualserver.org, netfilter-devel@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@yandex-team.ru>,
        Jacky Hu <hengqing.hu@gmail.com>, brouer@redhat.com,
        Quentin Armitage <quentin@armitage.org.uk>
Subject: Re: [PATCH] ipvsadm: allow tunneling with gre encapsulation
Message-ID: <20191205123443.75eeb03c@carbon>
In-Reply-To: <alpine.LFD.2.21.1907022210200.4236@ja.home.ssi.bg>
References: <20190701192537.4991-1-ja@ssi.bg>
        <20190702134442.2c646c76@carbon>
        <alpine.LFD.2.21.1907022210200.4236@ja.home.ssi.bg>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: xbE10sRQP4q31QuuOc3OMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2 Jul 2019 22:21:01 +0300 (EEST)
Julian Anastasov <ja@ssi.bg> wrote:

> 	Hello,
> 
> On Tue, 2 Jul 2019, Jesper Dangaard Brouer wrote:
> 
> > On Mon,  1 Jul 2019 22:25:37 +0300
> > Julian Anastasov <ja@ssi.bg> wrote:
> >   
> > > Add support for real server tunnels with GRE encapsulation:
> > > --tun-type gre [--tun-nocsum|--tun-csum]
> > > 
> > > Co-developed-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
> > > Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
> > > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> > > ---
> > >  ipvsadm.8       | 19 ++++++++++++++-----
> > >  ipvsadm.c       | 20 +++++++++++++++++++-
> > >  libipvs/ip_vs.h |  1 +
> > >  3 files changed, 34 insertions(+), 6 deletions(-)
> > > 
> > > 	Jesper, this will follow the other patchset from 30-MAY-2019,
> > > "Allow tunneling with gue encapsulation".  
> > 
> > I've applied Jacky's patches, which this patch builds on top of, to the
> > ipvsadm kernel.org git tree[1].
> > 
> > Simon already signed off on your kernel side patch, but it's not
> > applied to a kernel git tree yet... Do you want me to apply this, or
> > wait for this to hit a kernel tree?  
> 
> 	The both GRE patches are already part of nf-next, so
> it is fine to apply this ipvsadm patch for GRE now. It would be
> better in case one wants to test the new features...

I noticed that I had applied this patch, but forgot to push the ipvsadm
git tree[1] on kernel.org.  I've now pushed this...

https://git.kernel.org/pub/scm/utils/kernel/ipvsadm/ipvsadm.git/commit/?id=4a72198e7a3f9f275ff5752

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[1] https://git.kernel.org/pub/scm/utils/kernel/ipvsadm/ipvsadm.git/

