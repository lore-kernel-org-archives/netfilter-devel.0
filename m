Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4496B10C0;
	Thu, 23 Nov 2023 02:36:45 -0800 (PST)
Received: from [78.30.43.141] (port=41374 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1r674Y-00H9rv-8C; Thu, 23 Nov 2023 11:36:40 +0100
Date: Thu, 23 Nov 2023 11:36:36 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sasha Levin <sashal@kernel.org>
Cc: netfilter-devel@vger.kernel.org, gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.4 23/26] netfilter: nftables: update table
 flags from the commit phase
Message-ID: <ZV8rNDHAdttpYrAJ@calendula>
References: <20231121121333.294238-1-pablo@netfilter.org>
 <20231121121333.294238-24-pablo@netfilter.org>
 <ZV4qn2RI8a8cg3bL@sashalap>
 <ZV47LThJC3LMXmFp@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZV47LThJC3LMXmFp@calendula>
X-Spam-Score: -1.9 (-)

Hi again Sasha,

On Wed, Nov 22, 2023 at 06:32:32PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 22, 2023 at 11:21:51AM -0500, Sasha Levin wrote:
> > On Tue, Nov 21, 2023 at 01:13:30PM +0100, Pablo Neira Ayuso wrote:
> > > commit 0ce7cf4127f14078ca598ba9700d813178a59409 upstream.
> > > 
> > > Do not update table flags from the preparation phase. Store the flags
> > > update into the transaction, then update the flags from the commit
> > > phase.
> > 
> > We don't seem to have this or the following commits in the 5.10 tree,
> > are they just not needed there?
> 
> Let me have a look at 5.10, 23/26, 24/26 and 25/26 are likely
> candidates.
> 
> But not 26/26 in this series.
> 
> Let me test them and I will send you a specific patch series in
> another mail thread for 5.10 if they are required.

You can apply 23/26, 24/26 and 25/26 to 5.10 -stable coming in this
series for -stable 5.4. I haved tested here on -stable 5.10, they also
apply cleanly.

Thanks.
