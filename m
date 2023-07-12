Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F64EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jul 2023 06:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjGLGGk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 02:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjGLGGj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 02:06:39 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A52A1;
        Tue, 11 Jul 2023 23:06:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-98dfb3f9af6so840184366b.2;
        Tue, 11 Jul 2023 23:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689141994; x=1691733994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GzDlVHFtWng8mcmSi0ZdKyMrcr+HySjd81l4eJAURew=;
        b=jk7xdo09NZmRSv7Wwrus1PLVrTJwd9BSERb3/+VuhKlQ0P8BoPWSvOsZH8S4qvHEE/
         pD3FHd5LlqKqpQJK7Lj+HgVwxGmCvW6xQp+6AUlh5hc8naDwursg8BRp8dnsf2Zn9Bvn
         8awZ+m/Mvvms8g00CggY4daHNQ2fUX2hU6usgOJom72PsCqfwcxETZgG+wcZALOjF0T5
         u3qLwDJpQgP5/NldpApXI3YWWeyJIItRlN26Hhw5vhWXsXL2qgVx7LYaem5uPsampDcy
         /LJSG7tXMqBZPUD156C+Q20TPp1J3KagZN075GUQs1yYZriIENGm0da7/EpqmKV3CRhG
         BuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689141994; x=1691733994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GzDlVHFtWng8mcmSi0ZdKyMrcr+HySjd81l4eJAURew=;
        b=iphJlJNxk1SLGeNU8FEG5q1CsUS529R15xzRGfgdEt6KLO6bhTaqLwDkxWhZ9U3Gq/
         BTufRYIv5TLtwUKYbQWiBLTH1vNbRb/S8bFWfz0GKU8vyg2xReaMbJcPdjPTcDkp5jzQ
         6n6r6P0qCQtJcHisbt2o2TvyD62MzbkJc8nPK3oVrGbWLjbb4+vxh+TuZ2VERR0ZrN0k
         FlV+ky3eCr6q4Tzn4REiRHiAsUOO6GL91FLh0Y9ZLId/DPlCeCkpHOIeomhiP9heC7bX
         p/rMg1vupN6ebh3JPfMPYZ7nZWnQJfEKVqlS46XGeoTZ4HqN3LDazECB/8yQTVp1PHxQ
         Upgg==
X-Gm-Message-State: ABy/qLaLtE2hY6p/rE/LrMU9B3PFcFIPhHV21YqP3qh36bKnbMvHYcWp
        9I37WyhqZmFibvUfFiPdG+s=
X-Google-Smtp-Source: APBJJlEqlyUo5p9DCmi9jShPBOKjyGjq3Cj8mGxAk1JO3vJ6oM5hHA7c4ew1OZL24xD+f+YYdJMoYQ==
X-Received: by 2002:a17:906:2c9:b0:96a:3f29:40d9 with SMTP id 9-20020a17090602c900b0096a3f2940d9mr16314810ejk.25.1689141993935;
        Tue, 11 Jul 2023 23:06:33 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id d20-20020a170906371400b0098e2eaec395sm2073666ejc.130.2023.07.11.23.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 23:06:32 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 0E4FABE2DE0; Wed, 12 Jul 2023 08:06:32 +0200 (CEST)
Date:   Wed, 12 Jul 2023 08:06:32 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.10,v2 01/11] netfilter: nf_tables: use
 net_generic infra for transaction data
Message-ID: <ZK5C6EL6Fz0o3w2D@eldamar.lan>
References: <20230705150011.59408-1-pablo@netfilter.org>
 <20230705150011.59408-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705150011.59408-2-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Jul 05, 2023 at 05:00:01PM +0200, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> [ 0854db2aaef3fcdd3498a9d299c60adea2aa3dc6 ]

For all patches in this series, that should be either

[ Upstream commit 0854db2aaef3fcdd3498a9d299c60adea2aa3dc6 ]

or

commit 0854db2aaef3fcdd3498a9d299c60adea2aa3dc6 upstream.

to keep current used formats?

Regards,
Salvatore
