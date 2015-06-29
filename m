From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: parser conflict between tokens & symbols
Date: Mon, 29 Jun 2015 20:15:35 +0200
Message-ID: <32994930-FC4F-4B59-BD84-EDB91851E6CD@trash.net>
References: <20150626124423.GB5835@bzorp> <20150629145725.GD2324@breakpoint.cc> <20150629180929.GA22616@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Balazs Scheidler <balazs.scheidler@balabit.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38457 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbF2SPj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 14:15:39 -0400
In-Reply-To: <20150629180929.GA22616@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Am 29. Juni 2015 20:09:29 MESZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
>On Mon, Jun 29, 2015 at 04:57:25PM +0200, Florian Westphal wrote:
>> While we're at it, there are other issues, f.e.:
>> 
>> ct label saddr
>> ct label == saddr
>> 
>> won't work since saddr is considered to be the SADDR token.
>
>I don't think we're searching for such a flexibility in the grammar at
>this stage.

I know how to fix this once and for all by splitting the expression rules into non-const LHS and const RHS parts. This will unfortunately require to duplicate a lot of the productions.

I'll try to put something together during the next days.


-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
