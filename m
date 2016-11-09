From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH nft] segtree: keep element comments in set intervals
Date: Wed, 9 Nov 2016 10:20:47 +0100
Message-ID: <CAOkSjBhP4o78P92_py5pxGMg3J-sdQ5KFCY1HbyhuivrSf9hvQ@mail.gmail.com>
References: <1478647185-25289-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, netfilter@d9c.eu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35053 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752504AbcKIJVK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 04:21:10 -0500
Received: by mail-lf0-f67.google.com with SMTP id p100so12836207lfg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Nov 2016 01:21:09 -0800 (PST)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com. [209.85.215.53])
        by smtp.gmail.com with ESMTPSA id e133sm1435851lfg.32.2016.11.09.01.21.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Nov 2016 01:21:08 -0800 (PST)
Received: by mail-lf0-f53.google.com with SMTP id c13so159325995lfg.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Nov 2016 01:21:08 -0800 (PST)
In-Reply-To: <1478647185-25289-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 November 2016 at 00:19, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The conversion from the set element range representation to element
> intervals doesn't keep the comment information around.
>
> Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1090
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/segtree.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>

Hi,

just tested this patch before/after, and it really works.

Tested-by: Arturo Borrero Gonzalez <arturo@debian.org>

I think we can add some testcase to catch possible regressions. Will
send a patch.
