Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1E1EB
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 07:15:56 -0800 (PST)
Received: from [78.30.43.141] (port=46086 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rDQxj-004Snu-1K; Wed, 13 Dec 2023 16:15:53 +0100
Date: Wed, 13 Dec 2023 16:15:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXnKpoMQnsoTK6sA@calendula>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
 <ZXji-iRbse7yiGte@egarver-mac>
 <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Dec 13, 2023 at 01:13:54PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Tue, Dec 12, 2023 at 05:47:22PM -0500, Eric Garver wrote:
> > I'm not concerned with optimizing for the crash case. We wouldn't be
> > able to make any assumptions about the state of nftables. The only safe
> > option is to flush and reload all the rules.
> 
> The problem with crashes is tables with owner flag set will vanish,
> leaving the system without a firewall.

So it does currently in a normal process exit.

Reading all this, a few choices:

- add an 'orphan' flag that gets set on if the owner process goes
  away, so only ruleset with such flag can be retaken. This is to
  avoid allowing a process to take any other ruleset in place.

- add another flag to keep the ruleset around when the owner process
  goes away.

Probably it can be the same flag for both cases.

I remember we discussed these superficially at the time that the
'owner' flag was introduced, but there were not many use-cases in
place already, and the goal for the 'owner' flag is to prevent an
accidental zapping of the ruleset via 'nft flush ruleset' by another
process.

> [...]
> > > For firewalld on the other hand, I think introducing this "persist" flag
> > > would be a full replacement to the proposed owner flag update.
> > 
> > I don't think we need a persist flag. If we want it to persist then
> > we'll just avoid setting the owner flag entirely.
> 
> The benefit of using it is to avoid interference from other users
> calling 'nft flush ruleset'. Introducing a "persist" flag would enable
> this while avoiding the restart/crash downtime.

I think this 'persist' flag provides semantics the described above,
that is:

- keep it in place if process goes away.
- allow to retake ownership.
