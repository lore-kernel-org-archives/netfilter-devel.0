Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38B62C80
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 11:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726226674; cv=none; b=Yo/+kxMuzo0tNOcQeVVQYYH1JiPcz4fRKhr0IOjmHwuTHIgLXO1FT1D9rHLig7Tn1GwdxJg54nd095+MnVf8H2xSZAlF0t3rzqYz+pL2R3JLvDcdUX1EF0bA0/4FvzkfUhQBNrMXHMxspOfU3qsgPRnSd2B/njkViAl6nVgecfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726226674; c=relaxed/simple;
	bh=+66uQKoCADJkvGJ1/9NNk4VvCAr71pTBIBHP8Y9px8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkH8xqJ+mKcSSzYPrHlLq2/X+C9QyD53ySg5kcWkp03IhmS7t43W1q6xQVlLlrt/NMeXn5aS6HJQn334m8IYkMkJnoYovX2+AU7FckeT2oTauwYkYmR8iKP1jcSQw9RkCMDk264NxNDEItxx/664O/Gfl/QOrfOJjlc/bO1G6go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36586 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sp4Pa-00AITK-Ch; Fri, 13 Sep 2024 13:24:28 +0200
Date: Fri, 13 Sep 2024 13:24:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <ZuQg6d9zGDZKbWBO@calendula>
References: <20240913102023.3948-1-pablo@netfilter.org>
 <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula>
 <20240913104101.GA16472@breakpoint.cc>
 <ZuQYPr3ugqG-Yz82@calendula>
 <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kXPHocxCTbB5bohl"
Content-Disposition: inline
In-Reply-To: <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
X-Spam-Score: -1.9 (-)


--kXPHocxCTbB5bohl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Sep 13, 2024 at 01:02:02PM +0200, Antonio Ojea wrote:
> On Fri, 13 Sept 2024 at 12:47, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Fri, Sep 13, 2024 at 12:41:01PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Fri, Sep 13, 2024 at 12:23:47PM +0200, Florian Westphal wrote:
> > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > tproxy action must be terminal since the intent of the user to steal the
> > > > > > traffic and redirect to the port.
> > > > > > Align this behaviour to iptables to make it easier to migrate by issuing
> > > > > > NF_ACCEPT for packets that are redirect to userspace process socket.
> > > > > > Otherwise, NF_DROP packet if socket transparent flag is not set on.
> > > > >
> > > > > The nonterminal behaviour is intentional. This change will likely
> > > > > break existing setups.
> > > > >
> > > > > nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
> > > > >
> > > > > This is a documented example.
> > > >
> > > > Ouch. Example could have been:
> > > >
> > > >   nft add rule filter divert tcp dport 80 socket transparent meta set 1 tproxy to :50080
> > >
> > > Yes, but its not the same.
> > >
> > > With the statements switched, all tcp dport 80 have the mark set.
> > > With original example, the mark is set only if tproxy found a
> > > transparent sk.
> >
> > Indeed, thanks for correcting me.
> >
> > I'm remembering now why this was done to provide to address the ugly
> > mark hack that xt_TPROXY provides.
> >
> > While this is making harder to migrate, making it non-terminal is
> > allowing to make more handling such as ct/meta marking after it.
> >
> > I think we just have to document this in man nft(8).
> 
> I think that at this point in time the current state can not be broken
> based on this discussion, I just left the comment in the bugzilla
> about the possibility but it is clear now that people that have
> already started using this feature with nftables must not experience a
> disruption.
> On the other side, users that need to migrate will have to adapt more
> things so I don't think it should be a big deal.
> What I really think is that users should have a way to terminate
> processing to avoid other rules to interfere with the tproxy
> functionality

It is possible to add an explicit 'accept' verdict as the example
above displays:

        tcp dport 80 tproxy to :50080 meta mark set 1 accept
                                                      ^^^^^^

is this sufficient in your opinion? If so, I made this quick update
for man nft(8).

--kXPHocxCTbB5bohl
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="nft-doc.patch"

diff --git a/doc/statements.txt b/doc/statements.txt
index 5becf0cbdbcf..3c5059ead608 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -604,6 +604,11 @@ table inet x {
 }
 -------------------------------------
 
+Note that the tproxy statement is non-terminal to allow post-processing of
+packets, such as updating the packet marking. This is a change in behavior
+compared to the legacy iptables TPROXY target which is terminal. To terminate
+the packet processing after the tproxy statement, remember to issue a verdict.
+
 SYNPROXY STATEMENT
 ~~~~~~~~~~~~~~~~~~
 This statement will process TCP three-way-handshake parallel in netfilter

--kXPHocxCTbB5bohl--
