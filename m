From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Fri, 6 Nov 2009 20:51:14 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911062050580.25631@obet.zrqbmnf.qr>
References: <4AF1D08C.2030907@pandora.be> <4AF2E21B.4050801@trash.net> <4AF32544.2060709@pandora.be> <4AF448C8.80701@trash.net> <4AF45DFB.3070606@pandora.be> <4AF45E91.9050203@trash.net> <4AF460F2.30300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39741 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbZKFTvK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:51:10 -0500
In-Reply-To: <4AF460F2.30300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-11-06 18:46, Patrick McHardy wrote:
>> 
>> I'm not sure I understand what you're getting at. The above
>> line of code would do exactly that, attach the nf_bridge
>> data from the original packet to the newly created one.
>> But for this to work we need to make sure its valid in all
>> hooks, hence my suggestion to save it in PREROUTING instead
>> of POSTROUTING.
>
>This patch demonstrates the idea. Its not compile tested
>and incomplete, just to make more clear what I'm suggesting.
>

[patch in non-inlined form]

For a final one you also want to modify ip6t_REJECT.
