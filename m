From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: reject statement - "crazy" parse error?
Date: Wed, 26 Oct 2016 09:00:24 +0200
Message-ID: <CAOkSjBjd6CwTcMv_G1p1KmWnQukHUn6f4oCoaeZHmXEyJDiW4g@mail.gmail.com>
References: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: james@nurealm.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:39613 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753572AbcJZHAr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 03:00:47 -0400
Received: by mail-lf0-f47.google.com with SMTP id t133so1253772lff.6
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Oct 2016 00:00:46 -0700 (PDT)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com. [209.85.215.42])
        by smtp.gmail.com with ESMTPSA id r20sm122173lfr.19.2016.10.26.00.00.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Oct 2016 00:00:45 -0700 (PDT)
Received: by mail-lf0-f42.google.com with SMTP id m193so1265903lfm.4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Oct 2016 00:00:45 -0700 (PDT)
In-Reply-To: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 October 2016 at 03:30, James Feeney <james@nurealm.net> wrote:
>
> I'm guessing that that error message is wildly off-base.
>
> Or is "reject" not a proper "terminal statement"?
>
> Or is there something wrong with the syntax?

I can't reproduce the issue here.

% nft -f test.nft
% nft list ruleset
table ip private {
   chain postroute {
      type filter hook postrouting priority 0; policy accept;
      oifname "enp3s0" ip daddr 192.168.0.0/16 reject
   }
}
