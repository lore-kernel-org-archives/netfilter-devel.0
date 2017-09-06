From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Wed, 6 Sep 2017 13:58:56 +0200
Message-ID: <20170906115856.GC2399@orbyte.nwl.cc>
References: <20170906084105.10915-1-phil@nwl.cc>
 <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60002 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752666AbdIFL66 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 07:58:58 -0400
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

Thanks!

> Regarding the change, why asciidoc? why not markdown, or org-mode or
> reStructuredText?

Well, asciidoc is basicaly markdown on steroids, I fear we'll soon miss
features if we stuck to plain markdown. Also see this URL for a
comparison: [1].

I tend to ignore org-mode because I'm not an emacs user, and I guess
about 50% of (potential) nftables contributors feel the same about that.
:)

Regarding reStructuredText, did you look at how tables are written
there? If not, see here[2]. I really think that speaks for itself.

> There are many markup languages, it reminds me to xkcd #927 [0].

Well, the difference here is that I'm not inventing anything new but
search for better options amongst the existing solutions. :P

> I would prefer if we stick to groff, which seems to be the standard in Linux.

Yes, this is the very basic alternative but as said I think providing
users with an easier to use markup makes sense.

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

Well, I don't think nft.8's current size requires to split it into
smaller files at this point.

Cheers, Phil

[1] https://github.com/asciidoctor/asciidoctor.org/blob/master/docs/_includes/asciidoc-vs-markdown.adoc
[2] http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#tables
