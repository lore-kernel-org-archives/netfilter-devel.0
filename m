From: "Costa Tsaousis" <costa@tsaousis.gr>
Subject: Re: [PATCH]: fix all iptables problems with '!' (hopefully)
Date: Mon, 6 Jan 2003 14:29:13 +0200 (EET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <36373.195.97.5.193.1041856153.squirrel@fs.tsaousis.gr>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr>
        <20030106020219.GC423@comet.rv-int>
        <3E193B0E.9030602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <3E193B0E.9030602@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy said:
> I did, here is the (untested) patch, hopefully i didn't miss any.
> I didn't change any of the "save"-functions, this patch just replaces
> all uses
> of optarg after check_inverse by argv[optind-1].

I didn't test it, but keep in mind that the ! in certain cases has to be
placed *before* the argument and its value.

For example:

--uid-owner ! squid

is not accepted either ("user '!' not found"). The correct is:

! --uid-owner squid

Regards

-- 
Costa Tsaousis

Author of
FireHOL (http://firehol.sf.net)
-------------------------------
An iptables stateful firewall generator,
that allows you to configure your firewall...
...the way you think of it!
