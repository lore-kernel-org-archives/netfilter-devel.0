Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83EFD47
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 09:18:07 -0800 (PST)
Received: from [78.30.43.141] (port=50702 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAvXA-0042D2-0Q; Wed, 06 Dec 2023 18:18:06 +0100
Date: Wed, 6 Dec 2023 18:18:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Haller <thaller@redhat.com>
Cc: NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/5] add infrastructure for unit tests
Message-ID: <ZXCsyxTa2+sORXbC@calendula>
References: <20231105150955.349966-1-thaller@redhat.com>
 <792015e09808892af632b8297195dd6bc449b1ae.camel@redhat.com>
 <ZVykozlfXpddm7V2@calendula>
 <66b156090ff987567645b9e84aa2d1469823fc2b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <66b156090ff987567645b9e84aa2d1469823fc2b.camel@redhat.com>
X-Spam-Score: -1.8 (-)

On Wed, Dec 06, 2023 at 08:53:23AM +0100, Thomas Haller wrote:
> On Tue, 2023-11-21 at 13:37 +0100, Pablo Neira Ayuso wrote:
> > On Tue, Nov 21, 2023 at 01:34:54PM +0100, Thomas Haller wrote:
> > > Hi Pablo,
> > > 
> > > any concerns about this? Could it be merged?
> > 
> > Sorry. JSON support is not working, I had to locally revert those
> > patches to run tests on -stable 5.4 here.
> > 
> > Let's agree on some basic rule from now on: One series at a time
> > only,
> > anything else coming after will be marked as deferred in patchwork.
> > 
> > Thanks.
> > 
> 
> 
> Hi,
> 
> Could this be considered?
> 
> This provides the basis for unit tests (and the possibility to even add
> any such tests).

We are still discussing the json integration into tests/shell. I
suggest, let dust settle on each front before making more changes.

> It also hooks up tests to `make check`. Which would be desirable to
> build upon. `make check` currently does nothing. For example, Florian's
> afl++ patches could hook into `make check` (or `make check-more`), if
> this basis was there.

I still doubt `make check` provides any benefit to the release
process, which will exercise this path because of `make distcheck'
which I might have to relax it to `make dist' to skip this to ensure
release process is reliable.

I think all these tests should continously and provide reports to us,
but not necessarily integrate them into `make check'.
