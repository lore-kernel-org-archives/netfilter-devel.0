From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: ulogd - cpu usage statistics measurement
Date: Wed, 25 Jul 2012 15:01:21 -0700
Message-ID: <CAAJpzgbFUGQLOfZL7mXdCyVP9aLbdc6WVHr64gnA4roDKXOx_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63060 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2GYWBm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:01:42 -0400
Received: by obbuo13 with SMTP id uo13so1683692obb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Jul 2012 15:01:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to use ulogd(NFCT plugin + polling mode) in a heavy traffic
system. I would like to measure the percentage of cpu usage by ulogd
in a peak load.
In the polling mode, for each connection ulogd queries whether it is
removed from kernel using netlink library. I guess this may take
considerable cpu usage.

I have a testing plan, and can you guys suggest whether it is the
correct one, and also provide suggestions/alternatives.
Test plan : I'm going to insert 65k entries into conntrack table
through a script, with each connection is having a large timeout. In
parallel, I will measure ulogd's cpu usage.

Thanks & Regards,
