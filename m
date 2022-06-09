Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113E1C43334
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 20:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbiFIUmd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 16:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiFIUmb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 16:42:31 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C826C65D7
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 13:42:30 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id fu3so48251832ejc.7
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 13:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pinCqkHhOsM0rP86bVTT4Mpf5FeZH1dHs9IpUk4Nxrg=;
        b=iXB1AsniZjdLP/S67L85Jg9bdpQlnBzGSX0Km+VB1F9mkDmgL2+WMsDbUzCzySHc/t
         GaAsP/yJWurkv/3HIrLUC7TjZJ0pqCdU+vtBBVRthVDoDL0X54Dk0GyYxLmREGpMXxyo
         +B85S0AvI+9BxiUpDzZG10acpNjGIPoNO+cKOrYyT6s0kaE8UFpLyqEy7QJaPa4tPoyc
         VN0WzOW/diJSjl0QAn3BcFJXW9J49gxpKIm0uisPkPO7EYnK98kS6MlU7EZgDsVQ+zHX
         fb2DkoLpW3O4+TZVyYcYS3qkLDDhHCYLf5Y67pPhP9RoBn6WDpFl8pEf1LXBWHV0OXRf
         68tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pinCqkHhOsM0rP86bVTT4Mpf5FeZH1dHs9IpUk4Nxrg=;
        b=RFvaz+JvC6GBN79BJI04/vZH2ORXZsTMPJoEYs6cELXc8ERboSRswzZLdi9wppbRMD
         ugaYJWz4fUzef5P9XJu4VwMruV2vPESoV2PSsjk3ctlnQ0nRbbtL5/k0Iyfis2vXnipY
         Kfqm9PM0bz/SA6lCwJFIB6Z2itWjHov7sVP1aHL72NqouTx0fAWWMwqmgz2PsQXvE2Ke
         tuOHeQA71ZCavhSxHN1JKizAFVp40Yb4FZLc420whqUJlY8L2nU078DImDY4pRTNlpGq
         ciBqm6+6Q8Duxman4uOBkM1YGpbO7dQOeQ+7DJis3T2I6eevLAUfw5bn0uWypF4OdEYJ
         6FNg==
X-Gm-Message-State: AOAM533mwodlKMC/RDYM+OVCKTAqG8fhZYOmM60KjIk+jkgFCYlBug4K
        KluXgFps2sMV8cSvR8FaYZVf6N4o6JPNmw==
X-Google-Smtp-Source: ABdhPJwh3XOvlWy0qt77fNg2+oOEXyt7Ffuc0JRcslv4HlNtAhCPKOXmesH6Dm9v3uLE3amOLOB/+A==
X-Received: by 2002:a17:906:e2d2:b0:704:81fe:3152 with SMTP id gr18-20020a170906e2d200b0070481fe3152mr37592406ejb.411.1654807348870;
        Thu, 09 Jun 2022 13:42:28 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf473.dynamic.kabel-deutschland.de. [95.91.244.115])
        by smtp.gmail.com with ESMTPSA id hz14-20020a1709072cee00b00708e906faecsm10856246ejc.124.2022.06.09.13.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 13:42:28 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 0/1] Reusing modifier socket for bulk ct loads
Date:   Thu,  9 Jun 2022 22:41:41 +0200
Message-Id: <20220609204142.54700-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

Here is the updated patch to use the same mnl modifier socket
for all operation in bulk ct loads, with removed
nfct_mnl_socket.events field as we discussed.

Any further feedback/suggestions are welcome.

Regards,
Mikhail

Mikhail Sennikovsky (1):
  conntrack: use same modifier socket for bulk ops

 src/conntrack.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

-- 
2.25.1

