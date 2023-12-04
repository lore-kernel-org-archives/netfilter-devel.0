Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6180C95
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 02:48:38 -0800 (PST)
Received: from [78.30.43.141] (port=33606 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rA6V7-00DuLT-4G; Mon, 04 Dec 2023 11:48:35 +0100
Date: Mon, 4 Dec 2023 11:48:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
Subject: Re: does nft 'tcp option ... exists' work?
Message-ID: <ZW2ufym+r10rESua@calendula>
References: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
 <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
 <20231203131344.GB5972@breakpoint.cc>
 <20231204094351.GC5972@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231204094351.GC5972@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Dec 04, 2023 at 10:43:51AM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> > > FYI, I upgraded the router to OpenWrt 23.05.2 with 5.15.137 and it
> > > doesn't appear to have changed anything, ie. 'tcp option fastopen
> > > exists' still does not appear to match.
> > > 
> > > Also note that I'm putting this in table inet filter postrouting like
> > > below... but that shouldn't matter should it?
> > 
> > No, this is an endianess bug, on BE the compared byte is always 0.
> 
> We could fix this from userspace too:
> 
> ... exists  -> reg32 != 0
> ... missing -> reg32 == 0
> 
> currently nftables uses &boolean_type, so the
> compare is for 1 byte.  We could switch this to
> 32 bit integer type, this way it will no longer
> matter if the kernel stores the number at offset 0 or 3.

This simplifies things.

> Phil, Pablo, what do you think?

Just make sure this does not break backward compatibility. When used
from set declarations with typeof, for example.
