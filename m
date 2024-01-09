Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E363DB99
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2024 20:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=40520 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rNJ5s-0028BX-Sm; Tue, 09 Jan 2024 21:53:06 +0100
Date: Tue, 9 Jan 2024 21:53:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v2 0/3] netfilter: nf_tables: Introduce
 NFT_TABLE_F_PERSIST
Message-ID: <ZZ2yMKXhC8e6MSKA@calendula>
References: <20231221133159.31198-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231221133159.31198-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

Thanks for this v2.

On Thu, Dec 21, 2023 at 02:31:56PM +0100, Phil Sutter wrote:
> Changes since v1:
> - Split changes into separate patches to clarify which chunks belong
>   together
> - Do not support persist flag toggling as suggested
> - Make transaction aware of ongoing table adoption, reverse it during
>   rollback.

This series LGTM, let's put this in nf-next once the netdev merge
window opens up again.

Apologies for taking a while to review.
