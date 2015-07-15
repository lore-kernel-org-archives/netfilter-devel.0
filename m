From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Wed, 15 Jul 2015 19:10:29 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507151907560.1320@nerf40.vanv.qr>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de> <1436964819-28109-3-git-send-email-jengelh@inai.de> <20150715162442.GA22476@salvia> <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr> <20150715165515.GA4177@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37508 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbbGORKa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 13:10:30 -0400
In-Reply-To: <20150715165515.GA4177@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-07-15 18:55, Pablo Neira Ayuso wrote:
>> >> +-p esp -m esp;-p esp -m esp --espspi 0;FAIL
>> >>  -p esp -m esp;=;OK
>> >
>
>Given that this is changing the behaviour again, I would suggest that
>-p esp -m esp displays -p -m esp --espspi 0:4294967295 via
>iptables-save.

The printing via iptables -S was not the problem.
The patch is about that no AH/ESP packets were matched when using
just "-m esp" because of the implied --espspi 0:0.
