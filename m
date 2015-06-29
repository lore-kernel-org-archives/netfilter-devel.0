From: Juergen Brendel <juergen@brendel.com>
Subject: Extending nftables user-space utility for custom filters
Date: Tue, 30 Jun 2015 11:43:24 +1200
Message-ID: <1435621404.3480.16.camel@backpack>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.via.net ([209.81.9.19]:61574 "EHLO smtp1.via.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbbF2Xz1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 19:55:27 -0400
Received: from mail.via.net (mail.via.net [209.81.9.12])
	by smtp1.via.net (8.14.1/8.14.1-VIANET) with ESMTP id t5TNhbhK023506
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2015 16:43:37 -0700 (PDT)
Received: from [10.1.1.20] (ip-118-90-35-0.xdsl.xnet.co.nz [118.90.35.0])
	(authenticated bits=0)
	by mail.via.net (8.14.1/8.14.1-VIANET) with ESMTP id t5TNhYVC012338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2015 16:43:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello!

I'm still very new to nftables, so hopefully my question isn't too
silly.

>From what I understand so far, one of the neat features of nftables is
that a small VM in the kernel interprets the byte code, which was sent
down to it by the nftables user-space utility.

So it seems to me that if I would like to add some fancy, specialized
type of packet filtering/processing then all I would have to do is to
extend the nftables user-space utility to create new byte code: No
updated kernel or kernel modules required.

Is my understanding correct? And if so, I have these questions:

     1. Have the features and capabilities of the in-kernel VM been
        documented somewhere? So that I know what is even possible for
        the kernel code?
     2. Is there any documentation (a howto or getting-started guide),
        which explains how to extend the user-space utility so that it
        understands new commands and can construct new byte code?

Thank you very much!

Juergen


