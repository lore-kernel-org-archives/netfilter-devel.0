From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 2/3] set SEEN_REPLY before destroying conntrack on TCP
 RST
Date: Tue, 27 May 2008 15:33:01 +0100
Message-ID: <483C1B9D.5060705@gmx.ch>
References: <1211447601.6878.38.camel@pumper.lan.luxnet.ch> <1211826305.19222.8.camel@pumper.lan.luxnet.ch> <483B93C2.1000905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43931 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755140AbYE0OdE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 10:33:04 -0400
In-Reply-To: <483B93C2.1000905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Fabian Hugelshofer wrote:
>> On Thu, 2008-05-22 at 10:13 +0100, Fabian Hugelshofer wrote:
>>> =EF=BB=BFIf a connection fails with a TCP reset, the conntrack is d=
estroyed=20
>>> immediately. This patch sets the SEEN_REPLY bit before destroying t=
he=20
>>> conntrack.
>>
>> This updated version also increments the accounting counters.
>=20
> Thanks, but this needs to be changed slightly.
[...]
> I think a better way is to encapsulate the del_timer/timeout.function
> calls in a nf_ct_kill() function and perform accounting there.
> Since all manual invocations of timeout.function are/should be
> performed only while handling packets (that are usually not
> accounted), this seems like the right way.

Ok, I see. But for accounting ctinfo and skbuf are required. I'll=20
include them in the argument list of nf_ct_kill() and update the=20
function invocations, ok? Or should I introduce an nf_ct_kill_acct()?

I just did another test where my SEEN_REPLY patch was not applied.=20
Surprisingly the SEEN_REPLY bit was set in the destroy events. I am=20
afraid, but I have to assume, that I did not evaluate the bahavior=20
carefully enough. Probably I confused the accounting, no status and no=20
related packets issues.

Unless a race condition might be thinkable, we should leave the=20
SEEN_REPLY patch. If it is possible, that the timeout function=20
immediately triggers the destroy event to be exported over netlink, the=
n=20
the patch is still necessary. I don't see things detailed enough to=20
judge this. If it is necessary, should it be included in nf_ct_kill()?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
