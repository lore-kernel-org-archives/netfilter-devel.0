Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF4FC06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 11:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84A3E21473
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 11:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGBLov (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 07:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfGBLov (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 07:44:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E2F9C04BD48;
        Tue,  2 Jul 2019 11:44:50 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99765422C;
        Tue,  2 Jul 2019 11:44:43 +0000 (UTC)
Date:   Tue, 2 Jul 2019 13:44:42 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        lvs-users@linuxvirtualserver.org, netfilter-devel@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@yandex-team.ru>, brouer@redhat.com,
        Jacky Hu <hengqing.hu@gmail.com>
Subject: Re: [PATCH] ipvsadm: allow tunneling with gre encapsulation
Message-ID: <20190702134442.2c646c76@carbon>
In-Reply-To: <20190701192537.4991-1-ja@ssi.bg>
References: <20190701192537.4991-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 02 Jul 2019 11:44:51 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon,  1 Jul 2019 22:25:37 +0300
Julian Anastasov <ja@ssi.bg> wrote:

> Add support for real server tunnels with GRE encapsulation:
> --tun-type gre [--tun-nocsum|--tun-csum]
> 
> Co-developed-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
> Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  ipvsadm.8       | 19 ++++++++++++++-----
>  ipvsadm.c       | 20 +++++++++++++++++++-
>  libipvs/ip_vs.h |  1 +
>  3 files changed, 34 insertions(+), 6 deletions(-)
> 
> 	Jesper, this will follow the other patchset from 30-MAY-2019,
> "Allow tunneling with gue encapsulation".

I've applied Jacky's patches, which this patch builds on top of, to the
ipvsadm kernel.org git tree[1].

Simon already signed off on your kernel side patch, but it's not
applied to a kernel git tree yet... Do you want me to apply this, or
wait for this to hit a kernel tree?


[1] https://git.kernel.org/pub/scm/utils/kernel/ipvsadm/ipvsadm.git/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
