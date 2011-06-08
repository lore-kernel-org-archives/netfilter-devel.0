From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC] ecn match ported to ipv6
Date: Wed, 08 Jun 2011 17:01:52 +0200
Message-ID: <1307545312.3057.49.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, Dave Taht <dave.taht@gmail.com>
To: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1FHPB7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:01:59 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so423374wya.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 08:01:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dave Taht mentioned in bloat list that netfilter ecn match was ipv4
only.

Is there any plan to make the switch from net/ipv4/netfilter/ipt_ecn.c
to net/netfilter/xt_ecn.c ?

I can probably do it but not before ~ten days, so if someone is
interested, this will please Dave ;)

Thanks


