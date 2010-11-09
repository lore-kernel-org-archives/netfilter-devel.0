From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]extensions/tos_values.c mask value not accurate in certain
 condition
Date: Tue, 09 Nov 2010 15:45:50 +0100
Message-ID: <4CD95E9E.8050909@trash.net>
References: <4CCFA111.8090001@oracle.com> <alpine.LNX.2.01.1011020845470.6543@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, Joe Jin <joe.jin@oracle.com>,
	DuanZhenzhong <zhenzhong.duan@oracle.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0KIOqA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:46:00 -0500
In-Reply-To: <alpine.LNX.2.01.1011020845470.6543@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 02.11.2010 09:20, schrieb Jan Engelhardt:
> Patrick, please grab from
> 	git://dev.medozas.de/iptables master

It seems this was based on the iptables-next branch. However I should
have applied the option precedence patch to the main branch anyways.

Pulled, thanks.
