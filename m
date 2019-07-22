Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219F5C76190
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 17:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3CE2218BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 17:53:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tayTu5qb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbfGVRxV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 13:53:21 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:43035 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730452AbfGVRxT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 13:53:19 -0400
Received: by mail-qt1-f173.google.com with SMTP id w17so39302704qto.10
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 10:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xzoPZ+gTUnZKrBhHE68HlnmLCGayPYDmxUlFCZR3UOU=;
        b=tayTu5qbQ7ACr3g787XKWfwU/ACo7d0YLVx80QW2oCk+In6sGP5Tsjam14iwGaVoeV
         xPrDkq50uZoQOLf9dfkgavRSvjRiA0X6L2kSDeoVPIwdaSEaQKAX8fzy9j0u6DLP5J+C
         hVIuJ1po697a1ojdYM3ymxIM/o1EzEKksKq6HUuwLIVsAaQ1y2h6dJvxrYiP+i8Yq/IW
         4VQwhrUFq58otUKi2lP01Y/0AyfS02zgZ6efelkXbQ2th3Zxg6xIrmK6T39bgTl4+m6R
         mMXhbY0HZ51IthONwnuqgGg6Fk4ZoO3M9Q0K7GSj5sxZ3w63E4v5FOT3PitDJ6AGjkcQ
         Zq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xzoPZ+gTUnZKrBhHE68HlnmLCGayPYDmxUlFCZR3UOU=;
        b=lYw6zKToDOnfhVWD8u4/noZeU0pPXS1jNlnQ6T6Jn9+RVcRlyToTf4D1m0/3Y9fmlq
         T02BQSMfpTOwEXEuJh7A9CxWaJT6fv+9BNAWTJ9D81tx4CHqacbK2QYOfzeiO4hjR1RD
         lMFergkflyA9PmodQu0eaKXI4o+tEKfI7/NOI3Ut08m1n0+ILGX+se+wztmemCTutiN+
         W6QDsjeUjDAOeACZBkmEObPGngPNbG0FD3QwzvlyBF1ZXQG4nXsHPyFjUTIpEb5Wla9L
         3lpYOXxPmifXfxsF+3eNn7qTj06bBz8YSakGOG/ofgJrO8qZU7QvNPQZlMyX/TnwjZkW
         0YVw==
X-Gm-Message-State: APjAAAXSciXlxOf5Tlzp7hGnfhOBsQhrXL0bKc1gvBPYhZ+KC6FWXcfY
        4eLhlZYhrj/O2CUACEm0WJCSMEJ1OTUynrHPeY0J06yUQxI=
X-Google-Smtp-Source: APXvYqzJ/epjsIkHM0d5hbU7cryZFCOjUMU+gGW1CbaDKQ2eutNRgiDqWessyOFd9RZF6UDmLx7ddP2KjbKApx7MtY0=
X-Received: by 2002:a0c:aede:: with SMTP id n30mr51535530qvd.152.1563817997929;
 Mon, 22 Jul 2019 10:53:17 -0700 (PDT)
MIME-Version: 1.0
From:   Fran Fitzpatrick <francis.x.fitzpatrick@gmail.com>
Date:   Mon, 22 Jul 2019 12:53:06 -0500
Message-ID: <CALOK-OeZcoZZCbuCBzp+1c5iXoqVx33UW_+G3_5aUjw=iRMxHw@mail.gmail.com>
Subject: nftables feature request: modify set element timeout
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This morning I was using the `timeout` feature of nftables, but came
across an apparent limitation where I was not able to update an
element in a set's timeout value unless I removed the element from the
set.

Can it be possible to handle the element timeout value without needed
to remove it from a set?

[root@fedora29 vagrant]# nft add element inet filter myset {10.0.0.1
timeout 1m }
[root@fedora29 vagrant]# nft add element inet filter myset {10.0.0.1
timeout 10m }
[root@fedora29 vagrant]# nft list ruleset
table inet filter {
        set myset {
                type ipv4_addr
                flags timeout
                elements = { 10.0.0.1 timeout 1m expires 59s542ms }
        }
}
