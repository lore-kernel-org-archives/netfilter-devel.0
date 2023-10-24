Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072CCC00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 08:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjJXImc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 04:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbjJXImZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 04:42:25 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB01710C6
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 01:42:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-27d0acd0903so2795356a91.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 01:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=todish.com; s=google; t=1698136937; x=1698741737; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fNKiZcIoZY8c2P0UkbJjN4LiVIksrwPelmeoyTR4wuw=;
        b=ESUeltQcBiKXSHGYjwFj4+VPV6RB+nJHz5HhAJpGoGpyhHE4uXKdtDUWzeiLQf3q7W
         eNuDjstyejSmIAHbBzV32OeXRq3S+LiRtUH3vFOqPYavt6TazFoNuy63tQZSYMFo1Yuh
         hdmQYtetXWYVa6kk3aZhropW6BFzOKfEDXBPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698136937; x=1698741737;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fNKiZcIoZY8c2P0UkbJjN4LiVIksrwPelmeoyTR4wuw=;
        b=xL8+OMo7FfkV+x7dJ1z/o62I+BnavOBKa9hOiRp5nNqZOScuR8whI81XYZr3nb8WAl
         KyyaLWMCUEX6aChHr5sqd5wKcEw18aHGO28hohZX2DGuzbjNNRNUjLKJgoyzlUtxjtl9
         OVEjv2A9LOhU/m1rg23tkJTIZMJ6Tn0ZQmG0ZK2nllLy3X0XPJA7cgfmcfkP1aCsutll
         snb7N1LXdqdxc6sjaTLardEyDsCNpTcU8pLPgV0qT/LB0FTTj+LBSJmtJ8NhkIJfjMBv
         GJsWqI3omvfG3OQvuuaJ3pZSABfxgprdU+Yd9FYzQ7qhy9LY40Etvat3lbI1vR5hsUKA
         tkVQ==
X-Gm-Message-State: AOJu0YxAIBmrc5NWcYCd6jv7CMzIwCiWSId0jtm/lZdltuhBiMbeAX2P
        rhnwCb4Qhj3uFrmV9WHE1IomxGN5FSl6KOSibJCppUuODghDJ1dR
X-Google-Smtp-Source: AGHT+IFAAqFlxL7PcJVSUm431y9HMrRA4KEeiww7IZf4wbcxM/uB7qJyv4WRNt6N3lqQgKPP2EmpYVyTrydNVw7zz60=
X-Received: by 2002:a17:90a:199e:b0:27e:3342:5c1f with SMTP id
 30-20020a17090a199e00b0027e33425c1fmr5117704pji.43.1698136937234; Tue, 24 Oct
 2023 01:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <11E1F64F-CDA0-4C02-A7D6-E39EED609F70@todish.com>
In-Reply-To: <11E1F64F-CDA0-4C02-A7D6-E39EED609F70@todish.com>
From:   Clint Todish <clint@todish.com>
Date:   Tue, 24 Oct 2023 03:41:40 -0500
Message-ID: <CACn0go9+VBkZogEGRh0jH=RRQOT0QJaOC7KY-Z3dgLS+a+es2A@mail.gmail.com>
Subject: Fwd: Guidance on deterministic NAT (CGNAT)
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wondering if anyone had some direction for me to look on implementing
deterministic NAT in netfilter. Example:

Internal Subnet 10.0.0.0/16, External Subnet 1.1.1.0/24 -> 10.0.0.1
gets 1.1.1.1 ports 1024-2048, 10.0.0.2 gets 1.1.1.1 ports 2049-3072,
etc.

Does anyone know if someone is working on this feature or should I
just start looking to write it myself? Any other suggestions
appreciated.

Thanks for your time.
-C
