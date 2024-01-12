Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1CC6A011
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2024 12:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=44126 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rOGK1-006MNz-M6; Fri, 12 Jan 2024 13:07:39 +0100
Date: Fri, 12 Jan 2024 13:07:36 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] set: buffer overflow in NFTNL_SET_DESC_CONCAT
 setter
Message-ID: <ZaEriPoMQCKqu3/H@calendula>
References: <20240111222527.4591-1-pablo@netfilter.org>
 <ZaElewsMUNPLiDSu@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZaElewsMUNPLiDSu@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Fri, Jan 12, 2024 at 12:41:47PM +0100, Phil Sutter wrote:
> On Thu, Jan 11, 2024 at 11:25:27PM +0100, Pablo Neira Ayuso wrote:
> > Allow to set a maximum limit of sizeof(s->desc.field_len) which is 16
> > bytes, otherwise, bail out. Ensure s->desc.field_count does not go over
> > the array boundary.
> > 
> > Fixes: 7cd41b5387ac ("set: Add support for NFTA_SET_DESC_CONCAT attributes")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/set.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/set.c b/src/set.c
> > index 719e59616e97..b51ff9e0ba64 100644
> > --- a/src/set.c
> > +++ b/src/set.c
> > @@ -194,8 +194,14 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
> >  		memcpy(&s->desc.size, data, sizeof(s->desc.size));
> >  		break;
> >  	case NFTNL_SET_DESC_CONCAT:
> > +		if (data_len > sizeof(s->desc.field_len))
> > +			return -1;
> > +
> >  		memcpy(&s->desc.field_len, data, data_len);
> > -		while (s->desc.field_len[++s->desc.field_count]);
> > +		while (s->desc.field_len[++s->desc.field_count]) {
> > +			if (s->desc.field_count >= NFT_REG32_COUNT)
> > +				break;
> > +		}
> 
> Isn't the second check redundant if you adjust the first one like so:
> 
> | if (data_len >= sizeof(s->desc.field_len))
>
> Or more explicit:
> 
> | if (data_len > sizeof(s->desc.field_len) -
> |                sizeof(s->desc.field_len[0]))

I see, you suggest to ensure last item in the array is always zero.
