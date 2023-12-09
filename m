Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9086210DA
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2023 02:29:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rBuaO-0004yD-SD; Sat, 09 Dec 2023 11:29:28 +0100
Date: Sat, 9 Dec 2023 11:29:28 +0100
From: Florian Westphal <fw@strlen.de>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] whitespace: replace spaces with
 tab in indent
Message-ID: <20231209102928.GA9216@breakpoint.cc>
References: <20231209023020.5534-1-duncan_roe@optusnet.com.au>
 <20231209023020.5534-2-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231209023020.5534-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> i.e. this one:
> > -^I^I^I          struct nfq_data *nfad, char *name);$
> > +^I^I^I^I  struct nfq_data *nfad, char *name);$

Applied, thanks.
