Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD65137
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 04:57:53 -0800 (PST)
Received: from [78.30.43.141] (port=38886 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1r7bBN-001d5I-Ap; Mon, 27 Nov 2023 13:57:51 +0100
Date: Mon, 27 Nov 2023 13:57:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v3 0/1] New example program nfq6
Message-ID: <ZWSSTNYrVsJO7qeE@calendula>
References: <20231126061359.17332-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231126061359.17332-1-duncan_roe@optusnet.com.au>
X-Spam-Score: -1.8 (-)

On Sun, Nov 26, 2023 at 05:13:58PM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> I've been using nfq6 as a patch testbed for some time.

Thanks for offering. Please find an alternative spot to store this
file, you can write a webpage and documentation for ti, this does not
really need to be in libnetfilter_queue.
