From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Wed, 6 Sep 2017 13:34:02 +0200
Message-ID: <20170906113402.GA19026@salvia>
References: <20170906084105.10915-1-phil@nwl.cc>
 <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37288 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752409AbdIFLe2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 07:34:28 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Wed, Sep 06, 2017 at 11:56:37AM +0200, Arturo Borrero Gonzalez wrote:
> On 6 September 2017 at 10:41, Phil Sutter <phil@nwl.cc> wrote:
> > Beware: The conversion is incomplete and merely serves as base for
> > discussion.
> >
> > This patch converts nft.xml into asciidoc markup, top down until (and
> > including) stateful objects description. I stopped there because it's
> > the first chance of demonstrating my idea of splitting the documentation
> > into smaller pieces for convenience and maintainability.
> >
> > Regarding package dependencies, this "just" exchanges docbook with
> > asciidoc - dblatex is still required for PDF creation.
> >
> 
> Hi Phil,
> 
> thanks for your initiative and hard work, it's really appreciated :-)
> 
> Regarding the change, why asciidoc? why not markdown, or org-mode or
> reStructuredText?
> There are many markup languages, it reminds me to xkcd #927 [0].
> I would prefer if we stick to groff, which seems to be the standard in Linux.

Not willing to create a large thread debating what markup language
choice is better here, but I think asciidoc is a reasonable option.

> Regarding the separation of text in different includes, why not
> creating different manpages?
> Netfilter did this in the past with iptables(8) and iptables-extensions(8).
> 
> Brainstorming:
> * nft(8) <-- main document, general info
> * nft-ct(8) <-- concrete info for ct objects
> * nft-counter(8) <-- concrete info for counter objets
> * nft-flowtables(8) <-- about flow tables
> * nft-quota(8) <--- concrete info for quotas
> * nft-performance(8) <--- concrete info about nftables sets, maps,
> dicts, concatenations, etc.
> * nft-ha(8) <--- for HA environments, loadbalancing etc

Splitting manpage is a sensible option if we consider it's getting too
large, we can do this in incremental steps after the conversion.

Cheers.
