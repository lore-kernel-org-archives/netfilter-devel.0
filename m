From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: function for getting the source ip defined in the routing table
Date: Wed, 21 May 2014 10:07:27 -0700
Message-ID: <CAHo-OozPGMby_mt7GK-s6efs6vgctJiRSoZL2_hs_WmswsYwtg@mail.gmail.com>
References: <20140520124634.GM10939@kvmbude>
	<alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
	<20140520141828.GO10939@kvmbude>
	<CAHo-OozhUDnEJX3AZFTdWAx+trKhT9m=hKjj0Kr32aZm+Q_u=g@mail.gmail.com>
	<20140521083643.GU10939@kvmbude>
	<CAHo-Oozp=_ss7NG=yBQwD2qxjpvKRUwcMa4fJ+gbkMyYuJM6Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@inai.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:58592 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaEURH2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2014 13:07:28 -0400
Received: by mail-qc0-f173.google.com with SMTP id i8so3684849qcq.18
        for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2014 10:07:27 -0700 (PDT)
In-Reply-To: <CAHo-Oozp=_ss7NG=yBQwD2qxjpvKRUwcMa4fJ+gbkMyYuJM6Jw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Obviously you could call ip_route_output_key twice, once with
saddr=0, second time with whatever it returned or you wanted to use]
