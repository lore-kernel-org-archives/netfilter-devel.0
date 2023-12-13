Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC38B9
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 07:54:40 -0800 (PST)
Received: from [78.30.43.141] (port=39692 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rDRZD-004WfM-MN; Wed, 13 Dec 2023 16:54:37 +0100
Date: Wed, 13 Dec 2023 16:54:34 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXnTutEACvJPIEJx@calendula>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
 <ZXji-iRbse7yiGte@egarver-mac>
 <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
 <ZXnKpoMQnsoTK6sA@calendula>
 <ZXnS5k/iOj3g5f22@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZXnS5k/iOj3g5f22@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Dec 13, 2023 at 04:51:02PM +0100, Phil Sutter wrote:
> On Wed, Dec 13, 2023 at 04:15:50PM +0100, Pablo Neira Ayuso wrote:
[...]
> I find it sensible to protect a table only as long as the owning process
> remains alive, at least to prevent zombie tables. This raises the
> question what shall happen to orphan tables upon 'nft flush ruleset'?
> Flush them like a regular one?

I think so, otherwise such orphaned table will become an inmortal
zombie that noone can remove :)

[...]
> > I think this 'persist' flag provides semantics the described above,
> > that is:
> > 
> > - keep it in place if process goes away.
> > - allow to retake ownership.
> 
> I'll give it a try.

Thanks.
