Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585E5AC
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 05:01:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rA8ZX-00083s-2R; Mon, 04 Dec 2023 14:01:15 +0100
Date: Mon, 4 Dec 2023 14:01:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
Subject: Re: does nft 'tcp option ... exists' work?
Message-ID: <20231204130115.GA29636@breakpoint.cc>
References: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
 <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
 <20231203131344.GB5972@breakpoint.cc>
 <20231204094351.GC5972@breakpoint.cc>
 <ZW2ufym+r10rESua@calendula>
 <CAHo-OoyOh_6AOjCUrF8qZR-vuf=uhy_8WwzyFURwP_7=3jsWeA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OoyOh_6AOjCUrF8qZR-vuf=uhy_8WwzyFURwP_7=3jsWeA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> wrt. the fix, perhaps this should be fixed both in the kernel and in userspace?
> it seems wrong to have unpredictable endian-ness dependent kernel logic,
> but a userspace fix/workaround would be easier to deploy...

Right.

> Is there some way I could feed raw nf bytecode in via nft syntax (if
> no... should support for this be added?) ?

You could try this:

tcp option @34,8,8 == 34

(where 34 is the kind/option you are looking for).

