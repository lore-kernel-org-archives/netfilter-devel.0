Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA0FC28CF5
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 14:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbiAZOZm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 09:25:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242056AbiAZOZl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 09:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643207141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ce8pWwp6VNRk/3t1zVGXnKpIBTAIB7/nunPtbUVwhHk=;
        b=iDpzKm8Pq/mlrdLNYGNwY3j7PcZ45BZuYylSJx+c7bYlthZ0HCXXq87eNRA6LZa+H7NtE2
        ankmB8wkS2ot36UPwBMjvJLjamt0V81k/QntzTDs+fQARJa4aV51/O70yTtzFwzEOZc/uF
        uTrtYq5A1J9BI+tP3Bv8oL3hC/6XCVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-gqL5vpGzNWusEQNaCtnZ6Q-1; Wed, 26 Jan 2022 09:25:37 -0500
X-MC-Unique: gqL5vpGzNWusEQNaCtnZ6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A160B1091DA0;
        Wed, 26 Jan 2022 14:25:36 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56EA46F12C;
        Wed, 26 Jan 2022 14:25:36 +0000 (UTC)
Date:   Wed, 26 Jan 2022 15:25:33 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] selftests: nft_concat_range: add test for reload
 with no element add/del
Message-ID: <20220126152533.7d9b2cb7@elisabeth>
In-Reply-To: <20220126115454.31412-1-fw@strlen.de>
References: <20220126115454.31412-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 26 Jan 2022 12:54:54 +0100
Florian Westphal <fw@strlen.de> wrote:

> Add a specific test for the reload issue fixed with
> commit 23c54263efd7cb ("netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone").
> 
> Add to set, then flush set content + restore without other add/remove in
> the transaction.
> 
> On kernels before the fix, this test case fails:
>   net,mac with reload    [FAIL]
> 
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>
> [...]
>
> +test_bug_reload() {
> +	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
> +	rstart=${start}
> +
> +	range_size=1
> +	for i in $(seq "${start}" $((start + count))); do
> +		end=$((start + range_size))
> +
> +		# Avoid negative or zero-sized port ranges
> +		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
> +			start=${end}
> +			end=$((end + 1))
> +		fi
> +		srcstart=$((start + src_delta))
> +		srcend=$((end + src_delta))
> +
> +		add "$(format)" || return 1
> +		range_size=$((range_size + 1))
> +		start=$((end + range_size))
> +	done
> +
> +	# check kernel does allocate pcpu sctrach map
> +	# for reload with no elemet add/delete
> +	( echo flush set inet filter test ;
> +	  nft list set inet filter test ) | nft -f -

Nice trick :) ...thanks for adding this case!

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

