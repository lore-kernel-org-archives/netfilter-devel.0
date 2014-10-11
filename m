From: =?UTF-8?B?c3TDqXBoYW5lIGJyeWFudA==?= <stephane.ml.bryant@gmail.com>
Subject: queuing to userspace for the bridge family, using nftables
Date: Sat, 11 Oct 2014 09:00:44 +0200
Message-ID: <5438D59C.1030706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: kaber@trash.net, pablo@netfilter.org, marc@petit-huguenin.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38792 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJKHAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2014 03:00:53 -0400
Received: by mail-wi0-f174.google.com with SMTP id cc10so3807161wib.1
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2014 00:00:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

We are currently working on a project which may need the use of nftables
to queue AF_BRIDGE packets to the userspace and back. Apparently this is
already supported in the nftables code itself, but not in the bridge
netfilter code (the corresponding nf_afinfo is missing, at least).

I would like to know if there are plans to support this? If yes, in what
timeframe? If no, would you be interested if we were to submit a patch
to that effect?
Also, a. what should be included in the payload send to userspace?
(starting from the 802.3 LLC/protocol header, or also including up to
the MAC addresses ?) b. alternatively, shouldn't the dest MAC address be
added to the netlink attributes sent to userspace?

regards
stephane bryant
