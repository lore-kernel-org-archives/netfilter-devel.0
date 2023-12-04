Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D920DF
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 05:33:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rA94z-0008KS-86; Mon, 04 Dec 2023 14:33:45 +0100
Date: Mon, 4 Dec 2023 14:33:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
Subject: Re: does nft 'tcp option ... exists' work?
Message-ID: <20231204133345.GB29636@breakpoint.cc>
References: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
 <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
 <20231203131344.GB5972@breakpoint.cc>
 <20231204094351.GC5972@breakpoint.cc>
 <ZW2ufym+r10rESua@calendula>
 <CAHo-OoyOh_6AOjCUrF8qZR-vuf=uhy_8WwzyFURwP_7=3jsWeA@mail.gmail.com>
 <20231204130115.GA29636@breakpoint.cc>
 <CAHo-OowYxrMcsmhSk17FUFt-5LUwfkOhM+t=v3Yz6_2vbXcnkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OowYxrMcsmhSk17FUFt-5LUwfkOhM+t=v3Yz6_2vbXcnkQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> > You could try this:
> >
> > tcp option @34,8,8 == 34
> 
> So this seems to mean @number(34),offset(8),length(8) == 34
> And I understand the idea, but don't understand where the two 8's are
> coming from.

Yes, its wrong, it should be 0,8 as you found out.

> Is this counting bits? bytes?

Bits.

> Furthermore, I realized that really mangle postrouting 'reset tcp
> option fastopen' is a better solution to my particular problem.

Ah, yes, that will nop it out.
