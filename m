From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [nft PATCH 2/3] tests: shell: netns/0003many_0: Fix cleanup after error
Date: Wed, 22 Mar 2017 09:45:14 +0100
Message-ID: <CAOkSjBjjT9h-GZqDpoF4aQf4bkO_-X8=b7_jGo6E2XSWd_XJWw@mail.gmail.com>
References: <20170321131902.GA30047@salvia> <20170322002636.14081-1-phil@nwl.cc>
 <20170322002636.14081-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:33731 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758778AbdCVIph (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 04:45:37 -0400
Received: by mail-yw0-f177.google.com with SMTP id v76so124836342ywg.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 01:45:36 -0700 (PDT)
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com. [209.85.161.171])
        by smtp.gmail.com with ESMTPSA id w137sm243871yww.41.2017.03.22.01.45.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Mar 2017 01:45:35 -0700 (PDT)
Received: by mail-yw0-f171.google.com with SMTP id i203so10519444ywc.3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 01:45:35 -0700 (PDT)
In-Reply-To: <20170322002636.14081-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22 March 2017 at 01:26, Phil Sutter <phil@nwl.cc> wrote:
> If rule set applying failed, this would leave a stray netns in place.
>

Thanks Phil.

Acked-by: Arturo Borrero Gonzalez <arturo@debian.org>
