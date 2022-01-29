Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAA2C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 13:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbiA2NVn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 08:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiA2NVm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 08:21:42 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EE5C061714
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 05:21:41 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id m9so17642992oia.12
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 05:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=I05s+gybb1DCf9oSqDsSFaesP9uEmCDqhiwAx+tBGgA=;
        b=Dt2ZFMGkfETsLokiG8hOaLrv5dEpudSAic29duuN5AZO9JS2Jm1U13aaYa/IVtDuLl
         LTebZt2FUDUzEvl3ra1sZPnzLGo0fvlzgCuPKZebpZ/peAU+9znZGEjO0momWfIjNWil
         Kz8zVMDoMSD8LDGeH5Pk2h3a0hYMDrle54jGl6qPPqmpDuiMsaJTpWWjXMGl971h1isq
         NoqmU1IF+fCLw+8zKbhAxG0E+lqToOkYggltkbeuBaMfFW87L8kw6gckP4M82Vt5usc9
         S2QQRsmnwjPzK23RBdiZuGljA1v7q5LrBoZb8G4MGqlVZg6cuDaSkvsGaXBjjQd9+wvz
         ZU4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=I05s+gybb1DCf9oSqDsSFaesP9uEmCDqhiwAx+tBGgA=;
        b=LbzCtyxpEw9OAT+uDlAh8mmmAZlLf1LbLD+G/iO+AVoaHIyEfELfbsPq3bAzPdSExc
         Q59mEzlHSkuj0bWIQkaxPrZ723+BcYhADjJl/3ztuHdNIOvtsEnzbXd1X/J5PxZIcv4A
         fVbTGilCMwQPp1z3Y3u5ksmoz/9KbW9Lqv0uqVbzW4XjyaQRsADZ4MzFCtYqNoKqRcNy
         LU65iYqzcMcc1gDHhL3E1fQQ5EgGaIV1kcWdZcw3B+RugS4AHL8OvprtO/xsOmU/c9aH
         iEV8rhmEwtbyhbru5BLwJR7oRyn9owDdbRRWaGoB29ItW5Ty4yqM2LqClW925l4p/+tB
         siow==
X-Gm-Message-State: AOAM531fch+jiGjQxZupkq7MAJrpz4wmXb4+TCTK/eU0KXOFEq9B4Moi
        +ojPGR8KWe87R00gauQLk+wyxd3JF5mvFxTzB/JG2maGh8U=
X-Google-Smtp-Source: ABdhPJyNDd8GdbW4zKiAsGhxgjtfD98rBXIr/zhZd5iVGo8kEWeINN0llejsw9joRAXNoIJHebeWqjOHzJs5nh1nvsc=
X-Received: by 2002:aca:4286:: with SMTP id p128mr7944278oia.220.1643462501073;
 Sat, 29 Jan 2022 05:21:41 -0800 (PST)
MIME-Version: 1.0
Sender: pedretti.fabio@gmail.com
X-Google-Sender-Delegation: pedretti.fabio@gmail.com
From:   First Mate Rummey <fmrummey@gmail.com>
Date:   Sat, 29 Jan 2022 14:21:30 +0100
X-Google-Sender-Auth: oKH8VfkxmqSfmvS_RNAwY32Jg4c
Message-ID: <CAOK7j=3fT2YbWP8iUV+gmadUqGX-+JhoPPCsEOSN32ZUqQwGDw@mail.gmail.com>
Subject: new iptables release?
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, iptables 1.8.7 was released over one year ago, can you consider
pushing a new release?
Thanks
