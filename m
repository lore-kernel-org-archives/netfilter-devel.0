From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Update pom-ng docs for new iptables snapshots
Date: Fri, 15 Aug 2008 14:13:42 +0200
Message-ID: <48A572F6.80901@netfilter.org>
References: <20080802234156.GA26595@linuxace.com> <alpine.LNX.1.10.0808022011460.21001@fbirervta.pbzchgretzou.qr> <48A2D882.20908@trash.net> <20080815115934.GA22307@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41254 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752944AbYHONJK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:09:10 -0400
In-Reply-To: <20080815115934.GA22307@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Wed, Aug 13, 2008 at 02:50:10PM +0200, Patrick McHardy wrote:
>> We can do that, but for now I would prefer this patch since I don't
>> have the time for checking whether we still want anything.
>>
>> The patch doesn't apply cleanly though:
>>
>> patching file README
>> Hunk #1 FAILED at 2.
>> 1 out of 1 hunk FAILED -- saving rejects to file README.rej
>>
>> Not sure what the problem is ...
> 
> Neither am I, as I just verified it applies cleanly against
> patch-o-matic-ng-20080814 snapshot.  Snapshot not reflecting SVN or
> git reality?  Attached again to be sure.

Applied. Thanks Phil. Please, please sign-off-by your patches (even if
they are for the userspace tools, we're doing so since we switched to git).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
