From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [nftables PATCH v2] src: Add support for adding TOS symbols
Date: Fri, 23 May 2014 22:03:32 -0700
Message-ID: <CAHo-OoyrbTfrrfoamQSHjD6sWck2YCW1D=NsPKo1prW2RjEdfQ@mail.gmail.com>
References: <1400868602-23142-1-git-send-email-alvaroneay@gmail.com>
	<1400872513-25062-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:33483 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXFDd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 May 2014 01:03:33 -0400
Received: by mail-qg0-f50.google.com with SMTP id z60so9230095qgd.37
        for <netfilter-devel@vger.kernel.org>; Fri, 23 May 2014 22:03:32 -0700 (PDT)
In-Reply-To: <1400872513-25062-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

What for?

http://tools.ietf.org/html/rfc1349 (TOS) is obsoleted by
http://tools.ietf.org/html/rfc2474 (DSCP)

Furthermore minimize cost conflicts with current uses (ECN).

Does anyone even use those old definitions?

- Maciej
