From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix oops when inserting an
 element into a verdict map
Date: Mon, 7 Nov 2016 11:58:22 +0100
Message-ID: <CAOkSjBgfQTVMPJxiiNEL+J15EWT_3u+0HP_7KHTYHu8KhS8Sug@mail.gmail.com>
References: <1478414401-21488-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, dalegaard@gmail.com,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35404 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbcKGK6q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2016 05:58:46 -0500
Received: by mail-lf0-f66.google.com with SMTP id p100so8919261lfg.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Nov 2016 02:58:45 -0800 (PST)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com. [209.85.215.54])
        by smtp.gmail.com with ESMTPSA id 141sm4901712ljf.27.2016.11.07.02.58.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Nov 2016 02:58:43 -0800 (PST)
Received: by mail-lf0-f54.google.com with SMTP id c13so110037807lfg.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Nov 2016 02:58:43 -0800 (PST)
In-Reply-To: <1478414401-21488-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 November 2016 at 07:40, Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
>
> Dalegaard says:
>  The following ruleset, when loaded with 'nft -f bad.txt'
>  ----snip----
>  flush ruleset
>  table ip inlinenat {
>    map sourcemap {
>      type ipv4_addr : verdict;
>    }
>
>    chain postrouting {
>      ip saddr vmap @sourcemap accept
>    }
>  }
>  add chain inlinenat test
>  add element inlinenat sourcemap { 100.123.10.2 : jump test }
>  ----snip----

Perhaps it would be good to have this simple testcase in the nft shell
testsuite so we avoid future regressions.
