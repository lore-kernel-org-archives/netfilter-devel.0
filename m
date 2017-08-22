From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] tests: json: Add test cases for json format
Date: Tue, 22 Aug 2017 11:13:47 +0200
Message-ID: <CAOkSjBgo0AWBMdmfh7hEvAcNZepS5m_p9pXK5jp-L+ZVn5UjRQ@mail.gmail.com>
References: <1503348904-16654-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:33292 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbdHVJOJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 05:14:09 -0400
Received: by mail-wr0-f178.google.com with SMTP id a47so5412818wra.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 02:14:09 -0700 (PDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id c32sm316682edb.28.2017.08.22.02.14.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Aug 2017 02:14:08 -0700 (PDT)
Received: by mail-wr0-f182.google.com with SMTP id a47so5412470wra.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 02:14:08 -0700 (PDT)
In-Reply-To: <1503348904-16654-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 August 2017 at 22:55, Shyam Saini <mayhs11saini@gmail.com> wrote:
> These cases can be used to test upcoming "import json" command.
>
> Here is the short description of the files:
> all_ruleset_list   ->    contains list of all the individual rules
> rules_ipv4*        ->    ip  table
> rules_ipv6*        ->    ip6 table
> rules_arp*         ->    arp table
> rules_bridge*      ->    bridge table
>
> At this point of time some tests may fails.
> For example:
>  dup to 172.20.0.2
>  ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop
>

Hi Shyam,

thanks for your work!

A question: How are we supposed to run these tests? At least, any hint
would be welcome in the commit message.
