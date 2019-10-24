Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8EDCA9EBC
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A83820684
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408868AbfJXJfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 05:35:11 -0400
Received: from correo.us.es ([193.147.175.20]:36444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732686AbfJXJfK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 05:35:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1751611773C
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2019 11:35:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 083136DA2B
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2019 11:35:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F1EDEDA840; Thu, 24 Oct 2019 11:35:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F39A3B7FF2;
        Thu, 24 Oct 2019 11:35:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 24 Oct 2019 11:35:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CE4DA42EE39A;
        Thu, 24 Oct 2019 11:35:03 +0200 (CEST)
Date:   Thu, 24 Oct 2019 11:35:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/4] py: add missing output flags.
Message-ID: <20191024093505.pup5mktqrdbriwpz@salvia>
References: <20191022205855.22507-1-jeremy@azazel.net>
 <20191022205855.22507-3-jeremy@azazel.net>
 <20191023203833.aidczbpuxokywu6i@salvia>
 <20191024092052.GP26123@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024092052.GP26123@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 24, 2019 at 11:20:52AM +0200, Phil Sutter wrote:
> Hi,
> 
> On Wed, Oct 23, 2019 at 10:38:33PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 22, 2019 at 09:58:53PM +0100, Jeremy Sowden wrote:
> > > `terse` and `numeric_time` are missing from the `output_flags` dict.
> > > Add them and getters and setters for them.
> > 
> > LGTM.
> > 
> > @Phil, is this fine with you? I let you decide on this.
> 
> I just pushed it. Could you please update Patchwork? I'm not allowed to.
> 
> > BTW, would it make sense at some point to remove all the getter/setter
> > per option and use the setter/getter flags approach as in libnftables?
> 
> Well, from a compat standpoint we can't remove them. The benefit of
> those setter/getter methods is the clean interface (user's don't have to
> memorize flag names) and the semantics of returning the old value. The
> latter comes in handy when changing flags temporarily.

Probably some transitioning? ie. add the generic set/get flag
interface. Update clients of this (Eric's code) to use. Leave the old
interfaces for a while there to make sure people have time to migrate.
Then remove them.

Anyway, I'm fine if you prefer this more verbose interface for python,
no issue.

> One could change the private __{g,s}et_output_flag() methods though and
> make them similar to {g,s}et_debug() methods which probably resemble the
> syntax you're looking for.

Hm, not sure what you mean.
