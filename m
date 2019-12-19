Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C682C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 12:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FE1206D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 12:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YpdOnAJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfLSMrb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 07:47:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38117 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfLSMra (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 07:47:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so5872341wrh.5
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 04:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6wZq5nnbOfk11Id/MzBoP0SxCOrgHDjvq1n4q4zQSpw=;
        b=YpdOnAJr3a/hAgd3afg2pDkAsOejHFWtwVg3EOWrMO5yhuG7nqarVdcEsu2zwE3KP2
         khdLn6mwK2+8JYnkQd8aku4W3uUNX/c1XRAC//P+OcjetwuJ0IVFUdHG/9OiI5xLaLPs
         fs/tQ6tcYDheic8099o5CVCAY7M7FvJcJ2pQqBLsFDypklhFpEUzaYel64RKaHAq8wFT
         u94GEMxIQDR2CQI9z3meWYHPLl/4/gNgATWuTjw7F2zZxZa1S712y44DfKmoQMagR0ac
         SjEee0tgniA8YwCLojmA+OlaMuEz7utaAowBvHeG4URQm5wZunHx0NmI9k2iToI8SqSW
         21+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6wZq5nnbOfk11Id/MzBoP0SxCOrgHDjvq1n4q4zQSpw=;
        b=Xt2YI6UGl+FJItLgBAfDAKKotllchia8ES5AtNZKv171PWqAFO5lt/x+jFsQlTz4Hg
         nCXM2MxxTQN9+0CUYDMpNeoQGa07JYQn2kA6WX9wyuApS/60uKmlw7WwZiBsSTukPLCS
         CnRyV78THn6nHvQqljguqFOE4fpQgicLLe9u2fE82jJ9kTv/VNUwqvCnXfiYIyFE9/6h
         wsI14ncIbF5O02f1BxZGNn871vYfbbok+u8FMMLWMt+hFdRZ7FpYBaKscRrvkNjNtThO
         K74lUNe/7jwthUaWd9jvGakhPt1RUhFTX590E0bmz9htVOe058H9vt6XknRDw7+fQ1Sk
         gsbw==
X-Gm-Message-State: APjAAAUnS6RujZWo1djvzhfAAmj3HIepP2L1gOjfKQizdVMpqmVBCWms
        vU3KpLG+Iocr54fCAPjN0Tw=
X-Google-Smtp-Source: APXvYqzkRSIHPekhXxLR03KpJR/V7nzCEPE+GjB3kFC2/QRPzUIONvjKQyN8xWe1E52rGg55LyaSFA==
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr9697737wrs.276.1576759648568;
        Thu, 19 Dec 2019 04:47:28 -0800 (PST)
Received: from sch.bme.hu ([193.205.210.82])
        by smtp.gmail.com with ESMTPSA id o129sm6302062wmb.1.2019.12.19.04.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 04:47:28 -0800 (PST)
Date:   Thu, 19 Dec 2019 13:47:26 +0100
From:   =?utf-8?B?TcOhdMOp?= Eckl <ecklm94@gmail.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nft_tproxy: Fix port selector on Big Endian
Message-ID: <20191219124726.ez4kfrn4ny56q4o4@sch.bme.hu>
References: <20191217235929.32555-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191217235929.32555-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 18, 2019 at 12:59:29AM +0100, Phil Sutter wrote:
> On Big Endian architectures, u16 port value was extracted from the wrong
> parts of u32 sreg_port, just like commit 10596608c4d62 ("netfilter:
> nf_tables: fix mismatch in big-endian system") describes.
> 
> Fixes: 4ed8eb6570a49 ("netfilter: nf_tables: Add native tproxy support")
> Cc: Máté Eckl <ecklm94@gmail.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---

Acked-by: Máté Eckl <ecklm94@gmail.com>

Thanks for the fix! This was out of my sight.
