From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] iptables: Sort table names in ip[6]tables-save
Date: Mon, 1 Jul 2013 10:01:26 -0400
Message-ID: <20130701140126.GA1957@gmail.com>
References: <20130626234202.GA31099@gmail.com>
 <CAHo-Ooy_+zw-BXRxe=nTz4C-69e54ww_GRkMuHRbWjA7247nLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52192 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab3GBErs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:47:48 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so5849778pad.37
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2013 21:47:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAHo-Ooy_+zw-BXRxe=nTz4C-69e54ww_GRkMuHRbWjA7247nLA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:43:19PM -0700, Maciej =C5=BBenczykowski wrot=
e:
> I haven't looked at the patch, but I'm guessing there should be a way
> to disable this.

Why?  Today the behavior is random.  If you added a NAT table rule
before a FORWARD table rule, the NAT rules would be at the bottom
of the iptables-save output.  You're suggesting that completely
random behavior should be the _default_?  Isn't deterministic
behavior a better default?

Phil
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
