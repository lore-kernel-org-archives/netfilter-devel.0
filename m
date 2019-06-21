Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38676C48BE0
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 118C120675
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 16:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="NnDQCSBp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfFUQRs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 12:17:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37420 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFUQRs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 12:17:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so7189072wme.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0WhGkVvXAmBoYoHlHOUW5I79x+b+d+ygHBfaP4wj7UI=;
        b=NnDQCSBp5dskskWoplKReGI/YNp+762rMHkEdQ9aY2+2xQhAhUax04usUMR5R4kfgm
         z/c7sNf7YlUKOSZ6IZMW46XTD7HiVceDwIXadPQ8Q2U9MUvIJDNqnC8SG9L4ABUKO/s7
         708n7timHqRHoVhyfRbq8nNPvqm/IGpq3lGJJDLbnBgA/FdX6oUhgboM02uetku/Wbdk
         g3VG1d8QsbYbhIJXXvoT9xmqGWx/Q4WcSaOJdB3MkrUj15WjigJGm/FnGt6SFPXtzFPT
         DHtbIOw2SBO058iPhxSSefyVRSWxZhXdtE1LNFQpL7S1w3hIlqiCSrLik4VA9yyiZiPj
         hhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0WhGkVvXAmBoYoHlHOUW5I79x+b+d+ygHBfaP4wj7UI=;
        b=m6KOjvg4em0IZS0AMHjzcrG9UV4GNy0tbwRC94NorAcyrwraWyAYmw7CivT0tiPD0j
         XKfNRRLN5Or36BAT0GduYMRENChkTyaFQ2Ojv7iQnP4ixIALEoxvYaR6paMaSYc6oX9r
         FvF1buB/unBs/rF1/tF31ehu6yl8o+YLHPmjC4g63ENMoftOsnieb5x6bYrzK6ckHFhI
         OAPD/So6McRWUiI1ceqHs4W0tjH3tL6kuuW10nbLngg17Qvmt/f/44lgWIXT2itkKwD9
         0q45znR0rzWD2CyUSMmzwjJP5OVX3mXmeYGpbUs85sqjHujgSp7eTxCkZ2wIbG9S7xQj
         4U5w==
X-Gm-Message-State: APjAAAWLxDI/yeqd8h7OHJsTqQiGm2NJmX+80ftDZKwW+OD9+Qg527z4
        mcnQHc2TrjEivFATd+JQpJVeSQ==
X-Google-Smtp-Source: APXvYqyoaENggUaApEIFyy6YSKvFS4yfgT6HccBOLLnp4Rm1TBDYFbVlGaihV+v4zRDahyz/jxnVig==
X-Received: by 2002:a1c:bbc1:: with SMTP id l184mr4580579wmf.111.1561133866028;
        Fri, 21 Jun 2019 09:17:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d4sm6321052wra.38.2019.06.21.09.17.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 09:17:45 -0700 (PDT)
Date:   Fri, 21 Jun 2019 18:17:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 08/12] net: cls_api: do not expose tcf_block to
 drivers
Message-ID: <20190621161745.GD2414@nanopsycho.orion>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-9-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-9-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thu, Jun 20, 2019 at 09:49:13PM CEST, pablo@netfilter.org wrote:
>Expose the block index which is sufficient to look up for the
>tcf_block_cb object.

This patch is not exposing block index. I guess this is a leftover.


