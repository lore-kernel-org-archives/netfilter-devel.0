Return-Path: <SRS0=5oex=B4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCB7C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Aug 2020 00:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30012078E
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Aug 2020 00:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QUPnIGXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgHRAjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Aug 2020 20:39:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20832 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726749AbgHRAju (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Aug 2020 20:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597711189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6Zt/23/e2PVCilko2df88KdBjhS8HKOQy/EwEXaMdY=;
        b=QUPnIGXtMP7XOcvSd780pJ0Tsgv5oG2O9VH1njC4KI20KbPs804sGqHrKYspMRPN/gg6Pa
        2q7HY03TDtsjqGCv0AC5oriULZkdkqchZLQAPwlSMs3y+qHrgLGcb76sUD+AGBFfrByfzP
        dNwICIUS6ET2twV2GOA0ks+xUxsd12c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-rNCtf7k1NN2c_kzqWI6GBQ-1; Mon, 17 Aug 2020 20:39:44 -0400
X-MC-Unique: rNCtf7k1NN2c_kzqWI6GBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CA53185E528;
        Tue, 18 Aug 2020 00:39:43 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2355D5C3E0;
        Tue, 18 Aug 2020 00:39:39 +0000 (UTC)
Date:   Tue, 18 Aug 2020 02:39:35 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 nf] selftests: netfilter: exit on invalid parameters
Message-ID: <20200818023935.3bee52fc@elisabeth>
In-Reply-To: <20200814185544.8732-1-fabf@skynet.be>
References: <20200814185544.8732-1-fabf@skynet.be>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fabian,

On Fri, 14 Aug 2020 20:55:44 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> exit script with comments when parameters are wrong during address
> addition. No need for a message when trying to change MTU with lower
> values: output is self-explanatory
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  tools/testing/selftests/netfilter/nft_flowtable.sh | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
> index 28e32fddf9b2c..c3617d0037f2e 100755
> --- a/tools/testing/selftests/netfilter/nft_flowtable.sh
> +++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
> @@ -97,9 +97,17 @@ do
>  done
>  
>  ip -net nsr1 link set veth0 mtu $omtu
> +if [ $? -ne 0 ]; then
> +	exit 1
> +fi
> +

As some of your recent patches are also clean-ups, perhaps you get some
assistance from 'shellcheck' (https://www.shellcheck.net/). For
example, this could be written as:

  ip -net nsr1 link set veth0 mtu $omtu || exit 1

or, I'm not sure it's doable, you could get all those checks for free
by setting the -e flag for the entire script. You would then need to
take care explicitly of commands that can legitimately fail.

-- 
Stefano

