From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [iptables PATCH 1/2] Add iptables support for the TPROXY target
Date: Wed, 15 Oct 2008 12:30:54 +0200
Message-ID: <200810151230.55125@nessa>
References: <200810151010.15083@nessa> <200810151022.06435@nessa>
 <48F5BD40.8050305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7BIT
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:35917 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbYJOKa6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:30:58 -0400
Received: from nessa.odu ([89.132.101.55])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTPSA id <0K8R00FFJZUD7A80@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Wed, 15 Oct 2008 12:30:14 +0200 (CEST)
In-reply-to: <48F5BD40.8050305@trash.net>
Content-disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wednesday 15 October 2008, Patrick McHardy wrote:
> KOVACS Krisztian wrote:
> > On Wednesday 15 October 2008, Jan Engelhardt wrote:
> >> A bit of forward planning would not have been bad; like using a
> >> "union nf_inet_addr laddr" for a future IPv6 expansion, since those
> >> pesky structs (xt_mymodule) tend be quite fixed and when they
> >> change, they require a new revision.
> >
> > You're right. However I don't consider adding a new revision much of
> > a problem when adding IPv6 support -- that is a major new feature
> > anyway.
> >
> > But I think we're still on time: feel free to submit a patch to DaveM
> > which changes the kernel side as well as a patch to the iptables
> > modules.
>
> It would be good to avoid adding more of these ugly revisions,
> so yeah, feel free to send patches :)

Yeah, and of course don't send it to Dave, send it to Patrick. I'm a bit 
absent-minded today so don't expect meaningful mails from me...

-- 
KOVACS Krisztian
