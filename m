Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD333CD80A0
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 10:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjJJKhx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 06:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjJJKhx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 06:37:53 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6588794
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 03:37:51 -0700 (PDT)
Received: from [78.30.34.192] (port=44560 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qqA7W-003SmL-Uf; Tue, 10 Oct 2023 12:37:49 +0200
Date:   Tue, 10 Oct 2023 12:37:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZSUpeo2ozoPapyzg@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
 <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org>
 <20231009111543.GB27648@breakpoint.cc>
 <ZSPm7SQhO/ziVMaw@calendula>
 <ZSUNswK5nSC0IUvS@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZSUNswK5nSC0IUvS@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Tue, Oct 10, 2023 at 10:39:15AM +0200, Phil Sutter wrote:
> Hi,
> 
> On Mon, Oct 09, 2023 at 01:41:33PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Oct 09, 2023 at 01:15:43PM +0200, Florian Westphal wrote:
> > > Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> > > > On 10/9/23 12:44, Pablo Neira Ayuso wrote:
> > > > > - Another possibility is to make a nftables 1.0.6.1 or 1.0.6a -stable
> > > > > release from netfilter.org. netfilter.org did not follow this procedure
> > > > > very often (a few cases in the past in iptables IIRC).
> > > > 
> > > > Given the amount of patches, this would be the preferred method from the
> > > > Debian point of view.
> > > > 
> > > > 1.0.6.1 as version should be fine.
> > 
> > Only one thing: I just wonder if this new 4 numbers scheme might
> > create confusion, as there will be release with 3 numbers and -stable
> > releases with 4 numbers.
> 
> An upcoming 1.0.9 might be a good chance to switch upstream numbering
> scheme: Depending on whether it is deemed acceptable to reorder patches
> in public git history, one could make 1.0.9 contain only the fixes since
> 1.0.8 and release a 1.1.0 containing what remains. And from then on
> collect just fixes to 1.1.0 into 1.1.N and new features into 1.2.0.
>
> Assuming that downstream does its own "stable releases" already,
> skipping a 1.0.6.1 or 0.9.8.1 should be OK. Was a 0.9.10, being
> 0.9-stable, acceptable or are there too many new features between 0.9.8
> and 0.9.9?

I made a bit of digging in the history, and we already pulled the 4
digits handle in the past for iptables.

https://www.netfilter.org/projects/iptables/files/changes-iptables-1.4.19.1.txt

As for 0.9.10, it would skip 0.9.9:

$ git log --oneline v0.9.8..v0.9.9 | wc -l
150

We can start with a few -stable branches, namely 0.9.8.y and 1.0.6.y
as it has been suggested, I am going to push patches to the branches,
I will keep you posted.
