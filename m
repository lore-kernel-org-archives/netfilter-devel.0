Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E94C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 16:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CBF82070B
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 16:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="RQ3z5dDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfCCQ4F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 11:56:05 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:37987 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfCCQ4F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 11:56:05 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Mar 2019 11:56:04 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id E65363C80109;
        Sun,  3 Mar 2019 17:50:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1551631822; x=1553446223; bh=0/PkoQwJh7
        h7R9Y/tqCDZW/K0QTC3/X09WrEN/X7xzA=; b=RQ3z5dDg8p4x1vV/sAporVu2pL
        kd7sK/BBJmWuSfqDDmpMI3GwSWh/o1oKgLjfZklhemCnG/zAYbqNd/arcZ+tb6iJ
        H+E1WSp1Qf0QgBM1b5EW9PVM2EiIHrhL+K2SnteV3kaTXnR8H8aUa1wkjq5gCBXs
        Auuw0SXLhv5oN7wZE=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun,  3 Mar 2019 17:50:22 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp1.kfki.hu (Postfix) with ESMTP id CA7C53C800FD;
        Sun,  3 Mar 2019 17:50:22 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 938FE21E44; Sun,  3 Mar 2019 17:50:22 +0100 (CET)
Date:   Sun, 3 Mar 2019 17:50:22 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: tcp: only close if RST
 matches exact sequence
In-Reply-To: <20190301132436.elh5rxs6vxwnykd4@salvia>
Message-ID: <alpine.DEB.2.20.1903031715240.18380@blackhole.kfki.hu>
References: <20190221160931.10775-1-fw@strlen.de> <20190301132436.elh5rxs6vxwnykd4@salvia>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo, Florian,

On Fri, 1 Mar 2019, Pablo Neira Ayuso wrote:

> On Thu, Feb 21, 2019 at 05:09:31PM +0100, Florian Westphal wrote:
> > TCP resets cause instant transition from established to closed state
> > provided the reset is in-window.  Endpoints that implement RFC 5961
> > require resets to match the next expected sequence number.
> > RST segments that are in-window (but that do not match RCV.NXT) are
> > ignored, and a "challenge ACK" is sent back.
> > 
> > Main problem for conntrack is that its a middlebox, i.e.  whereas an end
> > host might have ACK'd SEQ (and would thus accept an RST with this
> > sequence number), conntrack might not have seen this ACK (yet).
> > 
> > Therefore we can't simply flag RSTs with non-exact match as invalid.
> > 
> > This updates RST processing as follows:
> > 
> > 1. If the connection is in a state other than ESTABLISHED, nothing is
> >    changed, RST is subject to normal in-window check.
> > 
> > 2. If the RSTs sequence number either matches exactly RCV.NXT,
> >    connection state moves to CLOSE.
> > 
> > 3. The same applies if the RST sequence number aligns with a previous
> >    packet in the same direction.
> > 
> > In all other cases, the connection remains in ESTABLISHED state.
> > If the normal-in-window check passes, the timeout will be lowered
> > to that of CLOSE.
> > 
> > If the peer sends a challenge ack, connection timeout will be reset.
> > 
> > If the challenge ACK triggers another RST (RST was valid after all),
> > this 2nd RST will match expected sequence and conntrack state changes to
> > CLOSE.
> > 
> > If no challenge ACK is received, the connection will time out after
> > CLOSE seconds (10 seconds by default), just like without this patch.
> 
> Applied, thanks.
> 
> @Jozsef, if you could also have a look to confirm if you see any
> issue, this looks fine to me and we, of course, can revert this in
> this this tightening in RST tracking has any side issue. Thanks!

The only problem I see is this part:

> > If the peer sends a challenge ack, connection timeout will be reset.

RFC5961 does not discuss the issue of the timeout when the challenge ack 
is sent and get lost, never reaches the destination. Like in this 
case:

non RFC5961 client 	firewall	our firewall	RFC5961 server
in-window RST ->
			ct dropped	ct kept,
					CLOSED timeout
							<- challenge ack
					ct kept,
					ESTABLISHED timeout
			ack dropped

I think we should keep the CLOSED timeout when the challenge ack is 
detected, which probably needs a new flag (IP_CT_EXP_CHALLENGE_ACK is for 
SYN ACK challenges).

In my opinion it was a very bad design decision of RFC5961 that there's no 
TCP option/flag to signal to the peer that the sender speaks the RFC5961 
flavour.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
