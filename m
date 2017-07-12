From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [nft PATCH 2/4] list: Introduce list_last_entry
Date: Wed, 12 Jul 2017 17:41:32 +0200
Message-ID: <CAOkSjBgy1e_L8a8Epo8XbYWH8_GTdBX=KeWZLC_nqeOYtU8jdg@mail.gmail.com>
References: <20170712123658.25363-1-phil@nwl.cc> <20170712123658.25363-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36598 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752919AbdGLPly (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 11:41:54 -0400
Received: by mail-io0-f182.google.com with SMTP id z62so14772043ioi.3
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 08:41:54 -0700 (PDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id y69sm1422627itb.20.2017.07.12.08.41.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2017 08:41:53 -0700 (PDT)
Received: by mail-io0-f175.google.com with SMTP id h134so14809717iof.2
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 08:41:53 -0700 (PDT)
In-Reply-To: <20170712123658.25363-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 July 2017 at 14:36, Phil Sutter <phil@nwl.cc> wrote:
> Similar to list_first_entry, this macro allows to retrieve the list's
> last entry.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/list.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Phil,

I think you can safely merge this patch into 1/4.

Better to introduce new functions at the same time of the callers, the
same patch.
