From: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Subject: Re: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 08 Nov 2010 12:45:52 +0300
Message-ID: <166541289209552@web79.yandex.ru>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com> <AANLkTinFKxOb2quNxV8HKz3Bgp9CwO_uzqE+7hBd+WxW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward4.mail.yandex.net ([77.88.46.9]:49078 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0KHJpy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:45:54 -0500
In-Reply-To: <AANLkTinFKxOb2quNxV8HKz3Bgp9CwO_uzqE+7hBd+WxW@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



08.11.2010, 09:34, "Changli Gao" <xiaosuo@gmail.com>:

> When conntrack is enabled, we can cache dst_entry into the
> corresponding conntrack to eliminate the subsequence
> ip_route_input_noref() calls for the same connection. The current

Any performance gains? How much?

-- 
wbr, Oleg.
