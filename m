From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 13:43:40 +0100
Message-ID: <47C55AFC.7090705@trash.net>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net> <20080227123122.GA22353@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?ISO-8859-15?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep32-int.chello.at ([62.179.121.50]:44237 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbYB0Mnj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:43:39 -0500
In-Reply-To: <20080227123122.GA22353@rere.qmqm.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please don't trim CC lists.

Micha=B3 Miros=B3aw wrote:
> On Wed, Feb 27, 2008 at 12:52:52PM +0100, Patrick McHardy wrote:
>> Stephen Hemminger wrote:
>>> Is there any strong reason why checking the status of iptables is=20
>>> restricted?
>>>
>>> Vyatta makes a distribution for routers. In our case, we use a non-=
root=20
>>> account
>>> for operator commands, and some of the commands are about querying=20
>>> iptables status.
>>> It seems to be less risky to just fix the kernel to allow non-root =
user to=20
>>> query rules
>>> than the current script that uses sudo. Another alternative would b=
e=20
>>> building a special
>>> restricted command that could be setuid root, but just changing the=
 kernel=20
>>> seems easiest.
>> I always thought of it as a privacy thing, similar to restricting
>> /proc/net/nf_conntrack. But since iptables rules usually don't
>> allow you to determine active connections just from the packet
>> counters that might be overkill. So I don't see any real harm
>> in allowing users to list the ruleset.
>=20
> At least for iptables, reading of iptables status can be done by maki=
ng
> iptables-save setuid-root. So I think no kernel patching is necessary=
=2E


Thats true, but I wouldn't do that since iptables is not the
most trustworthy code.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
