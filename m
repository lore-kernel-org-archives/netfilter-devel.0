Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7368D46
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 07:33:20 -0800 (PST)
Received: from [78.30.43.141] (port=43172 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rAtti-003obc-S5; Wed, 06 Dec 2023 16:33:16 +0100
Date: Wed, 6 Dec 2023 16:33:14 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v5 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZXCUOZapyqFtNZDc@calendula>
References: <ZWBhH235ou6RhYFn@calendula>
 <20231126015352.17136-2-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231126015352.17136-2-duncan_roe@optusnet.com.au>
X-Spam-Score: -1.9 (-)

On Sun, Nov 26, 2023 at 12:53:52PM +1100, Duncan Roe wrote:
> Enable mnl programs to check whether a config request was accepted.
> (nfnl programs do this already).

Applied, thanks
