Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DC81642B
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2023 12:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.43.141] (port=56704 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rGeKw-005ivF-Vh; Fri, 22 Dec 2023 13:09:09 +0100
Date: Fri, 22 Dec 2023 13:09:06 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] datatype: rt_symbol_table_init() to search for
 iproute2 configs
Message-ID: <ZYV8YnXhwKoDD/o2@calendula>
References: <20231215211933.7371-1-phil@nwl.cc>
 <ZYV7UAC3jZyXFM4K@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZYV7UAC3jZyXFM4K@calendula>
X-Spam-Score: -1.9 (-)

On Fri, Dec 22, 2023 at 01:04:35PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, Dec 15, 2023 at 10:19:33PM +0100, Phil Sutter wrote:
> > There is an ongoing effort among various distributions to tidy up in
> > /etc. The idea is to reduce contents to just what the admin manually
> > inserted to customize the system, anything else shall move out to /usr
> > (or so). The various files in /etc/iproute2 fall in that category as
> > they are seldomly modified.
> > 
> > The crux is though that iproute2 project seems not quite sure yet where
> > the files should go. While v6.6.0 installs them into /usr/lib/iproute2,
> > current mast^Wmain branch uses /usr/share/iproute2. Assume this is going
> > to stay as /(usr/)lib does not seem right for such files.
> > 
> > Note that rt_symbol_table_init() is not just used for
> > iproute2-maintained configs but also for connlabel.conf - so retain the
> > old behaviour when passed an absolute path.
> 
> Fine with me. This defines a fallback which is backward compatible.

As an addedum, probably expose these definitions in nft describe? So
users don't have to do strace to guess this. Also display from what
file this is taken:

# nft describe rt classid
rt expression, datatype realm (routing realm) (basetype integer), 32 bits

shows nothing.
