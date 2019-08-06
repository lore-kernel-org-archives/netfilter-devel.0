Return-Path: <SRS0=eApp=WC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3669C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 18:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 935F120C01
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 18:42:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="u9nFMnrq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfHFSmB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 14:42:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33050 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfHFSly (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 14:41:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id r6so81373816qtt.0
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Aug 2019 11:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8xcfqBh6UIl/C/ekxrxUbzURhem3fjy0jnP2hgpMKys=;
        b=u9nFMnrqsQFAc/LUYvI2tdrsCE6/0sRvCSTPWJDag1JY2dGurAnhQoksDXg0oIX1SS
         k/fwbH32kunMiQ6yn2Es1k7i/h1vjevhR3m/YhgtjexhmLfUP9i1QZN50gTdiHiwhbqu
         DQAKpzzs/+q8sSog3DPjMSJjpAEskYnBAWewgkAlo3QkmrXLada3i4B43H1yp3sJI4jj
         S+WgTmBdMjFZZcPPqc7/B1VSX0gEWI2sQw7c6vT3xalJX3mlLX/jO9H5rzGnG4uytw3m
         SrVxwsq4MEYGY1/mU/YYD/yqBtWJQSnyeK89ntqjebuxHU9TUf2sLHog4leFrzUCUAdD
         5V+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8xcfqBh6UIl/C/ekxrxUbzURhem3fjy0jnP2hgpMKys=;
        b=e8hf1XjB0GpumFjI2wqGpXgkB0BIU9bjJlZ5AKAf9vLwD+g0NDmJwcLYkiON2WGV7L
         ZbrHY+I4ul9462TU2j80htwzcHzCIGj/VytXBRcIJkfpW3XqvUTNoyIUuJG8brVD8rH1
         ICIZaRK3gAf6Ei/AOo+WX2IAGWL4EmtsiKGO0nEGg3fn+RNrNZW3kGXHvOdzNRtM5pJK
         sbZUcmFM1ZC5OrYszkL6Lzp7h6X39HhY9nKUWBpjp4tLNrvKigrI9hIVkSzBleuVc3nz
         Yiy9+CB0aNf8LY79R72l2v55TgGL33ZoI7yE7wgLTkkkQDdi+BHK6zxZ94b5lNDG4sao
         ifYQ==
X-Gm-Message-State: APjAAAVgrBNsNOyj2+3CH8agCX19/dhrhP22UgDX0ECZ2UNRbc/pD1Hu
        0zEWING7Xyf7jrystkT7pBWprZ1BFNQ=
X-Google-Smtp-Source: APXvYqzruFWjL/2GwPpTKTpPfw/eE6M+ZJ8LvUD0lwb09y0REyBNCEjPnxGiA4n6O8ceHLFYUmXWjw==
X-Received: by 2002:ac8:2b01:: with SMTP id 1mr4471790qtu.177.1565116913850;
        Tue, 06 Aug 2019 11:41:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d20sm35426478qto.59.2019.08.06.11.41.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 11:41:53 -0700 (PDT)
Date:   Tue, 6 Aug 2019 11:41:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH 0/2 net,v4] flow_offload hardware priority fixes
Message-ID: <20190806114127.54d9d029@cakuba.netronome.com>
In-Reply-To: <20190806160310.6663-1-pablo@netfilter.org>
References: <20190806160310.6663-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue,  6 Aug 2019 18:03:08 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset contains two updates for the flow_offload users:
> 
> 1) Pass the major tc priority to drivers so they do not have to
>    lshift it. This is a preparation patch for the fix coming in
>    patch #2.
> 
> 2) Set the hardware priority from the netfilter basechain priority,
>    some drivers break when using the existing hardware priority
>    number that is set to zero.

Seems reasonable, thanks.
