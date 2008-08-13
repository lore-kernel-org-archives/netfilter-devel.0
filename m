From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Update pom-ng docs for new iptables snapshots
Date: Wed, 13 Aug 2008 14:50:10 +0200
Message-ID: <48A2D882.20908@trash.net>
References: <20080802234156.GA26595@linuxace.com> <alpine.LNX.1.10.0808022011460.21001@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41468 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYHMMuM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:50:12 -0400
In-Reply-To: <alpine.LNX.1.10.0808022011460.21001@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2008-08-02 19:41, Phil Oester wrote:
> 
>> Attempting to run pom-ng's runme against an iptables snapshot
>> which has not yet had release.sh run in it will fail.  Update
>> docs to reflect this.
>>
>> This closes bugzilla #538.
> 
> I'd rather address it by stating its seemingly obsoletedness that
> has been discussed in previous threads.
> In other words, `svn rm * && svn commit`, and keep the repository
> for history.

We can do that, but for now I would prefer this patch since I don't
have the time for checking whether we still want anything.

The patch doesn't apply cleanly though:

patching file README
Hunk #1 FAILED at 2.
1 out of 1 hunk FAILED -- saving rejects to file README.rej

Not sure what the problem is ...
