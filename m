Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA61112
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 03:59:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rAqYU-0007hD-PW; Wed, 06 Dec 2023 12:59:06 +0100
Date: Wed, 6 Dec 2023 12:59:06 +0100
From: Florian Westphal <fw@strlen.de>
To: Thomas Haller <thaller@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH v2 nft] parser: tcpopt: fix tcp option parsing with NUM +
 length field
Message-ID: <20231206115906.GF8352@breakpoint.cc>
References: <20231205115610.19791-1-fw@strlen.de>
 <fcb3ef457002c89246c24a79290d25498ef7b0b0.camel@redhat.com>
 <20231206113836.GE8352@breakpoint.cc>
 <5aece71107a2716d9e6742cbc4e159c8c65a5ba0.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5aece71107a2716d9e6742cbc4e159c8c65a5ba0.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Thomas Haller <thaller@redhat.com> wrote:
> On Wed, 2023-12-06 at 12:38 +0100, Florian Westphal wrote:
> > Thomas Haller <thaller@redhat.com> wrote:
> > > Hi Florian,
> > > 
> > > On Tue, 2023-12-05 at 12:56 +0100, Florian Westphal wrote:
> > > >  .../packetpath/dumps/tcp_options.nft          | 14 +++++++
> > > 
> > > is there a reason not to also generate a .json-nft file?
> > 
> > Yes, I am not adding more one-line monsters.
> > 
> > I'll add one once there is a solution in place that has human
> > readable
> > json dumps that don't fail validation because of identical but
> > differently formatted output.
> > 
> 
> What about the "[PATCH nft 0/2] pretty print .json-nft files" patches?

I'm fine with that. Phil? Pablo? This is re:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231124124759.3269219-3-thaller@redhat.com/
