From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] iptables: Sort table names in ip[6]tables-save
Date: Tue, 2 Jul 2013 14:08:46 -0700
Message-ID: <CAHo-Ooy44=oqK_sk1jQZ4SoGiyKnscR-Epbk2ibj3b=EwQTncQ@mail.gmail.com>
References: <20130626234202.GA31099@gmail.com>
	<CAHo-Ooy_+zw-BXRxe=nTz4C-69e54ww_GRkMuHRbWjA7247nLA@mail.gmail.com>
	<20130701140126.GA1957@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:32992 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3GBVIr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:08:47 -0400
Received: by mail-vc0-f171.google.com with SMTP id gd11so3124929vcb.2
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jul 2013 14:08:46 -0700 (PDT)
In-Reply-To: <20130701140126.GA1957@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Why?  Today the behavior is random.  If you added a NAT table rule
> before a FORWARD table rule, the NAT rules would be at the bottom
> of the iptables-save output.  You're suggesting that completely
> random behavior should be the _default_?  Isn't deterministic
> behavior a better default?

I didn't say it should be the default.
I said there should be a way to disable the sorting.
Getting a dump as close as possible to the kernels view of the
situation is potentially desirable when debugging stuff.
