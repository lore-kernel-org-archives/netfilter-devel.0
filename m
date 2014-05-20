From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: function for getting the source ip defined in the routing table
Date: Tue, 20 May 2014 08:38:07 -0700
Message-ID: <CAHo-OozhUDnEJX3AZFTdWAx+trKhT9m=hKjj0Kr32aZm+Q_u=g@mail.gmail.com>
References: <20140520124634.GM10939@kvmbude>
	<alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
	<20140520141828.GO10939@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@inai.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51851 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaETPiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2014 11:38:08 -0400
Received: by mail-qc0-f180.google.com with SMTP id i17so1031486qcy.11
        for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2014 08:38:07 -0700 (PDT)
In-Reply-To: <20140520141828.GO10939@kvmbude>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Guessing that after ip_route_output_key(net, &fl4) fl4.saddr will have
what you want.
