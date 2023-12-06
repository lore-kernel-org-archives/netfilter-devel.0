Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="T9dr21/w"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F56D40
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 06:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Xz9u+hYuwecI014wwH2lrhOvnMVo2SFShrJIWkfK87M=; b=T9dr21/wmdMqUvz9qy8z/1CPWf
	dvyIdaBd5EmPA+BXP1qOROCU9VzsKI5TFN/Xy6PMBsmD4RXh4jiby6gDqI3sjLGNur0UFgqyD1z9L
	meYpbXURvezjCxytrEbW1qQt4X0Sm4UkA5fmdB6qFFysTRgE2dSMtudjH+WrAxQc4JunBw/SmSfu5
	STw8v3FVcd2+1q1XE2yqcBiIGfCMSzn/WH1tt+jLvCrWAP9Bm786YXV8f4oSFX/aoSUo4rBnLHqFs
	ZKI8sXpTz5TYAULCp4VdyAbt6b+TShJEdVBbf2jyhKbb1wOmfvshxQsL/XKb2DPUfBXGhb8DjvKjT
	wVOba+kQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rAsko-00008i-At; Wed, 06 Dec 2023 15:19:58 +0100
Date: Wed, 6 Dec 2023 15:19:58 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Thomas Haller <thaller@redhat.com>, netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH v2 nft] parser: tcpopt: fix tcp option parsing with NUM +
 length field
Message-ID: <ZXCDDgEhAV3KOCwt@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>,
	netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
References: <20231205115610.19791-1-fw@strlen.de>
 <fcb3ef457002c89246c24a79290d25498ef7b0b0.camel@redhat.com>
 <20231206113836.GE8352@breakpoint.cc>
 <5aece71107a2716d9e6742cbc4e159c8c65a5ba0.camel@redhat.com>
 <20231206115906.GF8352@breakpoint.cc>
 <20231206120447.GG8352@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231206120447.GG8352@breakpoint.cc>

On Wed, Dec 06, 2023 at 01:04:47PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Thomas Haller <thaller@redhat.com> wrote:
> > > On Wed, 2023-12-06 at 12:38 +0100, Florian Westphal wrote:
> > > > Thomas Haller <thaller@redhat.com> wrote:
> > > > > Hi Florian,
> > > > > 
> > > > > On Tue, 2023-12-05 at 12:56 +0100, Florian Westphal wrote:
> > > > > >  .../packetpath/dumps/tcp_options.nft          | 14 +++++++
> > > > > 
> > > > > is there a reason not to also generate a .json-nft file?
> > > > 
> > > > Yes, I am not adding more one-line monsters.
> > > > 
> > > > I'll add one once there is a solution in place that has human
> > > > readable
> > > > json dumps that don't fail validation because of identical but
> > > > differently formatted output.
> > > > 
> > > 
> > > What about the "[PATCH nft 0/2] pretty print .json-nft files" patches?
> > 
> > I'm fine with that. Phil? Pablo? This is re:
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231124124759.3269219-3-thaller@redhat.com/

What I don't like is that we'll still get these huge patches/mails if
the dumps are converted. Those that remain are still hard to handle in
case of errors.

> What about making it so we NEVER compare json-nft at all?
> 
> Instead, feed the json-nft file to nft, then do a normal list-ruleset,
> then compare that vs. normal .nft file.
> 
> This avoids any and all formatting issues and also avoids breakage when
> the json-nft file is formatted differently.

We may hide problems because nft might inadvertently sanitize the input.
Also, conversion from standard syntax to JSON may be symmetrically
broken, so standard->JSON->standard won't detect the problem.

> Eg. postprocessing via json_pp won't match what this patch above
> expects.

Python natively supports JSON. Converting stuff into comparable strings
(which also look pretty when printed) is a simple matter of:

| import json
| 
| json.dumps(json.loads(<dump as string>), \
| 	   sort_keys = True, indent = 4, \
| 	   separators = (',', ': '))

We rely upon Python for the testsuite already, so I don't see why
there's all the fuss. JSON dump create, load and compare have not been a
problem in the 5 years tests/py does it.

Cheers, Phil
