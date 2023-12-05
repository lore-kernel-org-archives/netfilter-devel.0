Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA17B116
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 03:46:00 -0800 (PST)
Received: from [78.30.43.141] (port=33848 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rATsD-00HY5r-BD; Tue, 05 Dec 2023 12:45:59 +0100
Date: Tue, 5 Dec 2023 12:45:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: turn assert into real error check
Message-ID: <ZW8NdKJ2v5tu8/Lv@calendula>
References: <20231204172121.5154-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231204172121.5154-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

All this patch series with conversion from assert() to error LGTM.
