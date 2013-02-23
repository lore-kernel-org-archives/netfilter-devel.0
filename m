From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: iptables nfacct match question
Date: Sat, 23 Feb 2013 20:57:37 +0000
Message-ID: <51292D41.8000703@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47811 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab3BWU6I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Feb 2013 15:58:08 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so1367298lbb.13
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Feb 2013 12:58:07 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As part of my daily job, I am currently trying to expand the functionality of the 4 netfilter components dealing with accounting: nfacct (executable), nfnetlink_acct (userspace library), nfacct (kernel part) and iptables match (kernel+userspace).

I need to be able to pre-select the number formatting of "bytes" and "packets" for each registered nfacct name using additional option in the nfacct iptables match (called --nfacct-fmt). Each registered nfacct name would have different formatting depending on the amount of traffic and also other factors. This formatting is going to be used mainly by invoking nfacct (executable) as plain text (in other words as "nfacct list").

What I currently implemented is add an additional property to nfacct struct (uint16_t fmt), storing the format to be used for "bytes" and "packets" for each registered name. The higher 8 bits of that number contain the format to be used for "packets", the lower 8 bits - for "bytes".

I was able to successfully modify the kernel part (nfacct), nfacct (the executable) and libnfnetlink_act userspace library to accommodate the above change, but I am currently struggling with modifying the nfacct match in iptables.

The problem arises when new nfacct match is used against old version of the nfacct iptables match in the kernel. It all stems from "struct xt_nfacct_match_info", which I need to expand in order to include the new option, but since this struct is part of kernel-headers, I am unable to do that, so I thought to ask for a bit of advice on this list!

One possible solution for me is to add a new pair of parse and print functions, as well as add another element to the nfacct_match array defined in libxt_nfacct.c to accommodate this new functionality and then use these newly-defined functions to possibly communicate with the kernel part to propagate/retrieve the new uint16_t fmt property value via nfnetlink. 

This approach seems to me a bit overly complex so I thought to ask - is this the "usual" way of dealing with such scenarios or is there another, simpler (or better) alternative? Thank you!


MZ
