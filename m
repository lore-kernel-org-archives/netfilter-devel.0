From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: [RFC PATCH nft 0/6] flow statement
Date: Tue, 10 Nov 2015 18:59:52 +0100
Message-ID: <CAJO99TnH43njpQ-5wO7Ar6jytmqzF4Y2wCr+DNhTWr7_MgtR8g@mail.gmail.com>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
	<20151110165156.GA3227@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36014 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbbKJR7y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 12:59:54 -0500
Received: by lbblt2 with SMTP id lt2so2787147lbb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 09:59:53 -0800 (PST)
In-Reply-To: <20151110165156.GA3227@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

System hangs here if I do the following:

add a flow table

list flowtable, cant make nft list flow table work, so do nft list set
filter test

flush rules and change flowtable concat, for example adding . ip saddr

everything seemingly fine this far, but if I now list set filter test,
system becomes
unresponsive, and a boot seems needed.

Kernel is 4.3.0 and latest libnftnl/nftables git with the 1-6
flowtable patches applied.
