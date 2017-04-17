From: Matthias Kaehlcke <mka@chromium.org>
Subject: Doubt about CTA_EXPECT_* values passed to ctnetlink_parse_tuple()
Date: Mon, 17 Apr 2017 15:37:30 -0700
Message-ID: <20170417223730.GR28657@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:35839 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754971AbdDQWhc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Apr 2017 18:37:32 -0400
Received: by mail-pg0-f48.google.com with SMTP id 72so69679750pge.2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Apr 2017 15:37:32 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

While working on clang support for kernel builds I came across at what
at first sight looks like an enum mismatch in the netfilter conntrack
code:

In multiple occasions CTA_EXPECT_* values (of type enum ctattr_expect)
are passed to ctnetlink_parse_tuple(), which expects an 'enum
ctattr_type' as type argument.

In other cases unintentional use of a wrong enum type maybe be
obvious, in this case however it isn't clear to me which 'enum
ctattr_type' should be passed instead, so I wonder if the use of the
different type is intended.

Could someone please briefly clarify? My background on netfilter
internals is zero, so please forgive my probably naive question.

Thanks

Matthias
