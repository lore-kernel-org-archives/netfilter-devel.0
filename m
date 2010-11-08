From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 8 Nov 2010 11:34:39 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011081134210.3660@obet.zrqbmnf.qr>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com> <AANLkTinFKxOb2quNxV8HKz3Bgp9CwO_uzqE+7hBd+WxW@mail.gmail.com> <166541289209552@web79.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39490 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab0KHKek (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:34:40 -0500
In-Reply-To: <166541289209552@web79.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-11-08 10:45, "Oleg A. Arkhangelsky" wrote:
>08.11.2010, 09:34, "Changli Gao":
>
>> When conntrack is enabled, we can cache dst_entry into the
>> corresponding conntrack to eliminate the subsequence
>> ip_route_input_noref() calls for the same connection. The current
>
>Any performance gains? How much?

"Numbers or it didn't happen."
