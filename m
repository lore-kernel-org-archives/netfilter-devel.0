Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2403CC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F000020850
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbfCANYl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:41 -0500
Received: from mail.us.es ([193.147.175.20]:49650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbfCANYl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 08:24:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B83C0190F62
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:24:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6D1BDA867
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:24:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9A5D8DA7FC; Fri,  1 Mar 2019 14:24:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CEC3DA846;
        Fri,  1 Mar 2019 14:24:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 Mar 2019 14:24:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.223.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 74D444265A2F;
        Fri,  1 Mar 2019 14:24:37 +0100 (CET)
Date:   Fri, 1 Mar 2019 14:24:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf-next] netfilter: conntrack: tcp: only close if RST
 matches exact sequence
Message-ID: <20190301132436.elh5rxs6vxwnykd4@salvia>
References: <20190221160931.10775-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221160931.10775-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 21, 2019 at 05:09:31PM +0100, Florian Westphal wrote:
> TCP resets cause instant transition from established to closed state
> provided the reset is in-window.  Endpoints that implement RFC 5961
> require resets to match the next expected sequence number.
> RST segments that are in-window (but that do not match RCV.NXT) are
> ignored, and a "challenge ACK" is sent back.
> 
> Main problem for conntrack is that its a middlebox, i.e.  whereas an end
> host might have ACK'd SEQ (and would thus accept an RST with this
> sequence number), conntrack might not have seen this ACK (yet).
> 
> Therefore we can't simply flag RSTs with non-exact match as invalid.
> 
> This updates RST processing as follows:
> 
> 1. If the connection is in a state other than ESTABLISHED, nothing is
>    changed, RST is subject to normal in-window check.
> 
> 2. If the RSTs sequence number either matches exactly RCV.NXT,
>    connection state moves to CLOSE.
> 
> 3. The same applies if the RST sequence number aligns with a previous
>    packet in the same direction.
> 
> In all other cases, the connection remains in ESTABLISHED state.
> If the normal-in-window check passes, the timeout will be lowered
> to that of CLOSE.
> 
> If the peer sends a challenge ack, connection timeout will be reset.
> 
> If the challenge ACK triggers another RST (RST was valid after all),
> this 2nd RST will match expected sequence and conntrack state changes to
> CLOSE.
> 
> If no challenge ACK is received, the connection will time out after
> CLOSE seconds (10 seconds by default), just like without this patch.

Applied, thanks.

@Jozsef, if you could also have a look to confirm if you see any
issue, this looks fine to me and we, of course, can revert this in
this this tightening in RST tracking has any side issue. Thanks!
