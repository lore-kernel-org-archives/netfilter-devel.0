From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re: [PATCH 0/6] [RFC] ctnetlink updates for net-next
Date: Thu, 9 Feb 2012 21:03:13 +0100 (CET)
Message-ID: <p6nkos9.2562f571dfbf33f925ac0f747688acb2@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:45567 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2BIUDR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:03:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
>Hi,
>
>The following are six patches for ctnetlink, four of them to finish
>the expectation support (this is required by conntrackd, next version
>will support expectation synchronization).
>
>Two of them allows you to filter dumpings by mark. So we save cycles
>on building and parsing messages. One for netlink itself, to allow
>passing the filtering data (or whatever any other data you want to
>pass to the ->dump and ->done callbacks).
>

Great !
just what I'm was looking for.
We really need this, fishing "by marks" when you have > 250 000 connections take some time :-)

Thanks
Hans


