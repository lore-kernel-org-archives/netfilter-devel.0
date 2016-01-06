From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [PATCH nft 2/6] tests/py: fix style
Date: Wed, 6 Jan 2016 19:55:59 +0100
Message-ID: <CAAaDf4tcOTTgV6tUZeP_W2u1-Bx_KNMQtaSQ5QnELkbUUC1-Yw@mail.gmail.com>
References: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
	<1451904236-4481-2-git-send-email-pablombg@gmail.com>
	<20160104113202.GB2045@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:34707 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbcAFS4B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jan 2016 13:56:01 -0500
Received: by mail-lb0-f196.google.com with SMTP id jk7so16335050lbc.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Jan 2016 10:56:00 -0800 (PST)
In-Reply-To: <20160104113202.GB2045@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-01-04 12:32 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Mon, Jan 04, 2016 at 11:43:52AM +0100, Pablo M. Bermudo Garay wrote:
>> - Adjust lines to 120 columns style
>
> Netfilter project coding style sticks to 80 columns. I'd rather keep
> that.

I'm sorry. I knew about that rule of project coding style, but I
skipped it since the script is not part of main program and it has a
lot of lines exceeding 100 characters. I will submit a new version of
patchset fixing it.

> BTW, I suggest next time you keep this style cleanup patches at the
> end of the patchset that you submit.

Ok, thanks.

> Apart from that, the patchset looks good and I'd like to see this
> integrated into master.
