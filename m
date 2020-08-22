Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9983C433E5
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF145208E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pc0H4t2B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHVGWT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 02:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgHVGWM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 02:22:12 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC70C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id w13so3465766wrk.5
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=yuLKtXjHzaV46NB7nMP8tYCm3ow6QFkS6lis27VHHhA=;
        b=Pc0H4t2BIN+m0iKF1W0DZMirak6fACTDxzsp7jRaoDIBovQ8vaCFTXeaD6TIGuqm+j
         9bM70Qsf9jCBKXpmXzxhlIZidywdvo9REOX1t0cJYmm3StO/kG6WB5U3mOMLOY3OI8a0
         BX3PKyu2MYlZxCRUx4IvzS7HUyy1pjkq/bSWWFyfrA/K22/+G0R14iwfZg0JhE9RcYXP
         PxJ2KLi8SuWayQxNhOQPyZ7RGdwmLXJQc2zqS/MANK4NSU5QjrFoOfpzdRbQgOpiJyOm
         BL+yL0qx0Y0D0qVMhaz2t0mRpw/8whs7TU5ipfreTinPq7zMuhrYzAvu01EWY7tU19bx
         MXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=yuLKtXjHzaV46NB7nMP8tYCm3ow6QFkS6lis27VHHhA=;
        b=pXbEvOyyaucJl6twlk3osKEeTVFd0EPBrWwHqdYHV6X8nQBoT6AFFRPwVisJ88svn8
         bYqzv3LdwQ+BoacLayxA9BZZrCwJydIRS+upyY7FfFAQkA+gUgzmgWrYDTBJN185MtiX
         8lbzyydGyNXafYO6uSISCnzQXGvr63mQblPxYHu3dYtmTiQsXpTUXuJzrWWR2D1RQwR0
         qNfK6crWfcbEkYbczZTonrAfXosQIs1AwUZkQk+s7672h/6bSTPbNUWCrmu8uCSo7ib8
         NB9hIKmPSo8J81UrlRDhX4Z+xQnW4Si2fkt06b0Ll/mPiWSfry+1fbS2NqA7TS9A08G7
         qnWQ==
X-Gm-Message-State: AOAM531H1wFXSe0N3lmN8PFeqAlmzunKFk6MoOqKEniwpWxRIP+hpWHM
        FEF/jigirKjXHwFy6QwRWnmujTSNIAqf2A==
X-Google-Smtp-Source: ABdhPJwPAYhT7ncaMuct2n3F2TrnILECtZckkTzW75OUEB/ACC97ysIo67im0otGd0tMbpNXiBWptw==
X-Received: by 2002:a5d:66c7:: with SMTP id k7mr5648399wrw.290.1598077327142;
        Fri, 21 Aug 2020 23:22:07 -0700 (PDT)
Received: from localhost.localdomain (BC2467A7.dsl.pool.telekom.hu. [188.36.103.167])
        by smtp.gmail.com with ESMTPSA id h5sm7016321wrt.31.2020.08.21.23.22.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 23:22:06 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 0/4] socket: add support for "wildcard" key
Date:   Sat, 22 Aug 2020 08:21:59 +0200
Message-Id: <20200822062203.3617-1-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NOTE: this depends on a kernel patch, so please merge that before this can
be merged.  Also, apart from build testing and running the binaries on an
unpatched kernel (and confirming the netlink payload is formatted as it
should be) this is untested.

This series adds the nftables side of "socket wildcard" a new expression
that extracts whether the associated socket is bound to the ANY address or
not.

iptables originally had this behavior by default when using "-m socket
--transparent", but this was missing from nftables.


Also, the last patch in the series allows one to override the "nft"
executable used by the tests.


