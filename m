Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CD3C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Feb 2022 22:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiBEWes (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Feb 2022 17:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiBEWes (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Feb 2022 17:34:48 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A523DC061348
        for <netfilter-devel@vger.kernel.org>; Sat,  5 Feb 2022 14:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KKAAUEqydp2WGxrqsL3H6WogXMDZ7cSnORMorqipxdc=; b=dwwI8yGWBMCrfayz48iOFQ7UKF
        lc854opEk6C8fuVyuyuYfLSPWp8NV74szv4q9i4Ba3Is3xOKbdWwO5T3nTTr69QWBpqB+J+fxOn8W
        Bm0z7w08hQ2o/ODbkma/S4HxgkoPlf6fl+wsG5sjiq/t+q1gWURchnNMrFdtyVqplMbBkMoOidsDl
        ZBHsQntEJUFaHEelirPywk419BGty4IO3YuhvqK5hWBC79LsqL57sn4wkbimPCV/EIICuO9MWxAZe
        7Is9TKVAIGmNPb9Lkf9WQcl2SRWOzX67FxzztaIrm4L93TELD3VeYg4rtijbZFNKKz/IjmzGbPR4h
        BoKto2ew==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nGTdi-00CW1P-G2
        for netfilter-devel@vger.kernel.org; Sat, 05 Feb 2022 22:34:42 +0000
Date:   Sat, 5 Feb 2022 22:34:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Time for a libnetfilter_conntrack release?
Message-ID: <Yf77gYmezLTLrC+/@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's been nearly two years since the last libnetfilter_conntrack release
and there are a couple of dozen unreleased commits.  Time for 1.0.9?

J.
