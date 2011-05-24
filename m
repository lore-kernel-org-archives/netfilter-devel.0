From: Patrick McHardy <kaber@trash.net>
Subject: Re: Force socket error on iptables reject with icmp semantics?
Date: Tue, 24 May 2011 09:01:47 +0200
Message-ID: <4DDB57DB.8050004@trash.net>
References: <BANLkTi=APDmR7c8eqVySKofXx_wMtgPGOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: JP Abgrall <jpa@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48722 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1EXHCU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 03:02:20 -0400
In-Reply-To: <BANLkTi=APDmR7c8eqVySKofXx_wMtgPGOw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.05.2011 01:16, JP Abgrall wrote:
> Before I go bug the kernel people, I'd like to know if this seems
> reasonable from a netfilter perspective.
> 
>>From e8b45cfd66ccc1be0bc406fc9662f0f1e7a94283 Mon Sep 17 00:00:00 2001
> From: JP Abgrall <jpa@google.com>
> Date: Thu, 19 May 2011 19:30:02 -0700
> Subject: [PATCH] netfilter: have ip*t REJECT set the sock err when an
> icmp is to be sent
> 
> Allow the REJECT --reject-with icmp*blabla to also set the matching error
> locally on the socket affected by the reject.
> This allows the process to see an error as if it received it via ICMP.
> It avoids the local process who's packet is rejected to have to wait
> for a pseudo-eternity until some timeout kicks in.

The interpretation and handling of the ICMP errors is up to the higher
layer protocols. So doing this in the REJECT target is not a good idea.
Unless there's something wrong in your setup, the ICMP message should
be received by the socket anyways.
