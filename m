From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] tests: json: Add test cases for json format
Date: Wed, 23 Aug 2017 12:02:38 +0200
Message-ID: <CAOkSjBge_Zk4L3b5CDxthHz6v+Vrx6tMtqfBxrcMLv5unZCGWw@mail.gmail.com>
References: <1503348904-16654-1-git-send-email-mayhs11saini@gmail.com>
 <CAOkSjBgo0AWBMdmfh7hEvAcNZepS5m_p9pXK5jp-L+ZVn5UjRQ@mail.gmail.com> <CAOfkYf7B09Z+nHf8EMJ2qQ6W-1u2-j_UmiwzSXgF+Mdk7Gc5dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36716 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753939AbdHWKDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 06:03:01 -0400
Received: by mail-wm0-f50.google.com with SMTP id z132so11895943wmg.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 03:03:00 -0700 (PDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com. [74.125.82.52])
        by smtp.gmail.com with ESMTPSA id w31sm559462edd.57.2017.08.23.03.02.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Aug 2017 03:02:59 -0700 (PDT)
Received: by mail-wm0-f52.google.com with SMTP id z132so11895619wmg.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 03:02:59 -0700 (PDT)
In-Reply-To: <CAOfkYf7B09Z+nHf8EMJ2qQ6W-1u2-j_UmiwzSXgF+Mdk7Gc5dQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22 August 2017 at 11:30, Shyam Saini <mayhs11saini@gmail.com> wrote:
>
> Should I send the version 2 of this patch with this script?
>

Yes,

my suggestion is:

* create a new testcase in nftables: tests/shell/testcases/import/yourscript_0
* put all the json files in: tests/shell/testcases/import/json and
read them from yourscript_0

in the script use the $NFT environment variable to call nft.

This way we avoid adding a new testsuite just for this and reuse existing code.
