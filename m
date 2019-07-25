Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D67AC76194
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48269214AE
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="vUWKD0RR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfGYTKg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 15:10:36 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41160 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfGYTKg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 15:10:36 -0400
Received: by mail-qk1-f196.google.com with SMTP id v22so37273226qkj.8
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iKVapx1RqpxI4fC/IeFwmqp7E16OG+D1ofg7IIrvhQg=;
        b=vUWKD0RRiPRmwMu/QH7xCx/r3e2UNByUpx8QWn0jCjt1aud5Ui1164+ZPJfueeId+7
         Tm4oSPV5SR56aOKAUDbKg8KXkSoM11yY28/DK4nhE+ayk09JyOpuujXjBZVfHPF0fsbL
         4neSq/zNQL4gLYctF1ZtffxR9J7BAJ694o0BFnVhmBSxqDB5Q8l8U2vtE1mw7CTuxdx6
         5XSRacQ/BN7dGwYYx7y39QhGR+A5v53OqjwE2Djf8Po+Cyen+XoI055Ks89OdRCN7ooE
         izHL+pvDvuGGwu6ZLaomIYAw5kAZCfa7sHvNWDFhJxMuUthuDjL/xP262twclHOuxhjr
         QeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iKVapx1RqpxI4fC/IeFwmqp7E16OG+D1ofg7IIrvhQg=;
        b=TEJq8F4Z8JXo2dvKouQfrMDlJe2zXdRq6qVuvt5L/j8KjtTAgEZeHw4uNfQIs9tt1C
         rRyDEZbXk4z1smfEsFi76Nv8SrdcwfUzvYec2ddd28Lw8IHJqQ53V8PXFyevAtANvAVL
         2AhTPXv9SCm44n4le8RPlEDOHPYb59xz+eQBwxL6q3YEPjp/FF+oKycEoiGzEAiN8/j5
         p5AizB5W2RG9RY0Xu54tzNFP1ctdN8ZS8fxCqSACgx+UoIkt1o3aAB1Iy5IkdZ2cKBlP
         7jgFmJ78Zh6JKLmoIFrGeKudY7H+Vk2RNpGQxDvlOge9zPi4Hvy2btCaOLY9vBcMgHHw
         Hb7Q==
X-Gm-Message-State: APjAAAWNaEuAg4MC4cGlEgL6Vs9E/JxKjS80ABKQB8mfI3CUgck1xyML
        oJaQwWCxwD57c+q4dorxXtxy5ghZfOM=
X-Google-Smtp-Source: APXvYqzqFw9CSlMSLMTe/OvgGUoYAX8lbHzh+recHR3EUzWUU00tGD6X5MxRRe0L8xiWCcnrzb/YQw==
X-Received: by 2002:a37:aa04:: with SMTP id t4mr59931514qke.359.1564081835202;
        Thu, 25 Jul 2019 12:10:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm24473960qtj.46.2019.07.25.12.10.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 12:10:35 -0700 (PDT)
Date:   Thu, 25 Jul 2019 12:10:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190725121029.75f26c2d@cakuba.netronome.com>
In-Reply-To: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please provide cover letter for the patch set.

On Thu, 25 Jul 2019 17:55:31 +0800, wenxu@ucloud.cn wrote:
> +static bool rhash_table_init;
> +int flow_indr_rhashtable_init(void)
> +{
> +	int err = 0;
> +
> +	if (!rhash_table_init) {
> +		err = rhashtable_init(&indr_setup_block_ht,
> +				      &flow_indr_setup_block_ht_params);
> +
> +		if (!err)
> +			rhash_table_init = true;
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(flow_indr_rhashtable_init);

This should be written like this:

int flow_indr_rhashtable_init(void)
{
	static bool rhash_table_init;
	int err;

	if (rhash_table_init)
		return 0;

	err = rhashtable_init(&indr_setup_block_ht,
			      &flow_indr_setup_block_ht_params);
	if (err)
		return err;

	rhash_table_init = true;
	return 0;
}
EXPORT_SYMBOL_GPL(flow_indr_rhashtable_init);
