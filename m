From: wzt wzt <wzt.wzt@gmail.com>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
Date: Tue, 23 Mar 2010 09:34:09 +0800
Message-ID: <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
References: <20100320143240.GB2942@localhost.localdomain>
	 <4BA7A3CF.8070503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57393 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0CWBeK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:34:10 -0400
In-Reply-To: <4BA7A3CF.8070503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I can see that the size might cause an overflow in the addition with
> sizeof(struct ipt_get_entries)
That's the integer overflow i pointed.
get.size is copy from the user space,  it can be set as 0x7fffffff,
addition with sizeof(struct ipt_get_entries) can be overflow.

        if (*len != sizeof(struct ipt_get_entries) + get.size) {
                duprintf("get_entries: %u != %zu\n",
                         *len, sizeof(get) + get.size);
                return -EINVAL;
        }

so, check get.size max value before addition with sizeof(struct
ipt_get_entries) to prevent the integer overflow.
