From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH nft] tests: shell: add test case for inserting element
 into verdict map
Date: Wed, 9 Nov 2016 11:50:36 +0100
Message-ID: <CAOkSjBjWMRpN9R2QAJ=REAbfMBnAtd0VX9mwXZpxcxGTHrBpsg@mail.gmail.com>
References: <1478617597-13459-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34768 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbcKIKu7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 05:50:59 -0500
Received: by mail-lf0-f66.google.com with SMTP id o141so11735144lff.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Nov 2016 02:50:58 -0800 (PST)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com. [209.85.215.46])
        by smtp.gmail.com with ESMTPSA id h143sm7048562lfh.38.2016.11.09.02.50.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Nov 2016 02:50:57 -0800 (PST)
Received: by mail-lf0-f46.google.com with SMTP id b14so160916452lfg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Nov 2016 02:50:57 -0800 (PST)
In-Reply-To: <1478617597-13459-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 November 2016 at 16:06, Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
>
> "dalegaard@gmail.com" reports that when inserting an element into a
> verdict map, kernel crash will happen. Now add this test case so we
> can avoid future regressions fail.
>
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> ---
>  .../shell/testcases/sets/0008create_verdict_map_0  | 25 ++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100755 tests/shell/testcases/sets/0008create_verdict_map_0
>

Acked-by: Arturo Borrero Gonzalez <arturo@debian.org>
