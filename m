Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D831CC433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 00:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D30120B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 00:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="uFJjTGHG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbfHBAUe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 20:20:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34812 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732077AbfHBAUc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 20:20:32 -0400
Received: by mail-qk1-f193.google.com with SMTP id t8so53509831qkt.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Aug 2019 17:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YrAx0zX7auo9QDlbkVDwIncGhtx6wpbCngP7FcTQWIE=;
        b=uFJjTGHGaA/2S8Tg0aI9XTPUgW5bMOgxhC4Mo4QBDPRxI4eILwRSICN6t626DW3MQy
         UT5mXBV84unrcIg7Zvq53rJZZYyS6nuWkTyvNme7sW9fQGtGq5TxKoQaMJ08dYZ1tjz0
         vSK+NSQIs8Y0e8zE3Yu0Ohx8X+Xo4mh4jgSC4tqmRBHTOrETIFvACWXyI+Xof/Gufq2H
         H5livpB85Uj/W75oLHm1FyAcjf4MhOKSRuG7+P8KWEv7ioUcHMWBl7BEnR0ZLIq8tB9N
         vPNrSA0f7lGBfKwR7hdvcCgWpLM919DRjG6q6MuU6lIQB0aDu98AGYr14lqVAlGBL1UV
         c8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YrAx0zX7auo9QDlbkVDwIncGhtx6wpbCngP7FcTQWIE=;
        b=ZzxBgD5gYESjeX1vwC1nQ+yCp1b7TX4Tfv2pclrGX0NjzlEzbARVZe6IN20aOchvFH
         f1CrI2r6pEXe/wwj3TMxYtoBIfGOWgikgH7KSWXZ2zy13KexGWix5/Ody7byJJ3HV77r
         N+W5AIE8MHODOVhQpPwu0fjV0+Bhw5POP/k/pIzGabhHzdm3tbEQwoXxeXU7fkkn/roL
         6JL+XRV7ypPyT3luqbEr9kqzf60oBzndATehvDHHsXgz2bGNE3H7APORG6jdYAz8x6GD
         PpHFvS21zxkV+ezPOClIfO4ABKHtHK8sFUrfOVibjc1rz0tP+WbPGyf+Ljpe5/bIK9Wp
         B5uQ==
X-Gm-Message-State: APjAAAXtZf9hz3u9YhGuYwQLgpqRmH0A3K35bPz0H702cmOb9tCOsgjb
        m0EERTYKXqdwmzEtFhYHY/3b0ffFDcw=
X-Google-Smtp-Source: APXvYqwMbYD3LNl4MXicH/fDkdzKCw1hudlErHNhB9gDh523ZTphg4Ka3FPSXvESVk2M2ey+T/YIow==
X-Received: by 2002:ae9:e707:: with SMTP id m7mr89292148qka.50.1564705231787;
        Thu, 01 Aug 2019 17:20:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e8sm30484586qkn.95.2019.08.01.17.20.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 17:20:31 -0700 (PDT)
Date:   Thu, 1 Aug 2019 17:20:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190801172014.314a9d01@cakuba.netronome.com>
In-Reply-To: <20190801112817.24976-1-pablo@netfilter.org>
References: <20190801112817.24976-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu,  1 Aug 2019 13:28:15 +0200, Pablo Neira Ayuso wrote:
> Please, apply, thank you.

I'm still waiting for a reply. 

Perhaps since Pablo doesn't want to talk to me someone else can explain
to me why we want to seemingly diverge from the software model?
