Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E040859B41
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2024 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Q42NAGYk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PWWJ9YVm4tYtEN20O/cOxzvs2Y6AEeK3/1KDqpeRFo8=; b=Q42NAGYkeH1As1WiBRpLXwbtRH
	pBWwYHhn0pa3usWmTAxcvjD4/bw3BovH6yTMENMbepAVaCaXa0Jr9tpNWckBAPbH7ycLP99ckOTA7
	6G+xz0wM4VOqCIZeC1rmEAzAGYC8dumX6irWFVVCWZaKdQmQLCCUCddkg9LSibentacw5Y3u1hihe
	WUmpcUCqfyy28xKPaEGfDi2+xu8JK/NA4vC/H4myXCMyPTBHv3B8+EQVKG/OCP3XP7jEscFtKNSp8
	LR1wzueCisnrfBXIGLPgLU2qdWBAEjPbDFndzUTsH3gMG6iTK9z5+K9Ocab9sBiEocUlL0hh6IP4/
	jxKSpSbw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rOGoQ-000000000Lh-0LsR;
	Fri, 12 Jan 2024 13:39:02 +0100
Date: Fri, 12 Jan 2024 13:39:02 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] set: buffer overflow in NFTNL_SET_DESC_CONCAT
 setter
Message-ID: <ZaEy5uMXwpAzrVBb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240111222527.4591-1-pablo@netfilter.org>
 <ZaElewsMUNPLiDSu@orbyte.nwl.cc>
 <ZaEriPoMQCKqu3/H@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaEriPoMQCKqu3/H@calendula>

On Fri, Jan 12, 2024 at 01:07:36PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 12, 2024 at 12:41:47PM +0100, Phil Sutter wrote:
> > On Thu, Jan 11, 2024 at 11:25:27PM +0100, Pablo Neira Ayuso wrote:
> > > Allow to set a maximum limit of sizeof(s->desc.field_len) which is 16
> > > bytes, otherwise, bail out. Ensure s->desc.field_count does not go over
> > > the array boundary.
> > > 
> > > Fixes: 7cd41b5387ac ("set: Add support for NFTA_SET_DESC_CONCAT attributes")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  src/set.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/src/set.c b/src/set.c
> > > index 719e59616e97..b51ff9e0ba64 100644
> > > --- a/src/set.c
> > > +++ b/src/set.c
> > > @@ -194,8 +194,14 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
> > >  		memcpy(&s->desc.size, data, sizeof(s->desc.size));
> > >  		break;
> > >  	case NFTNL_SET_DESC_CONCAT:
> > > +		if (data_len > sizeof(s->desc.field_len))
> > > +			return -1;
> > > +
> > >  		memcpy(&s->desc.field_len, data, data_len);
> > > -		while (s->desc.field_len[++s->desc.field_count]);
> > > +		while (s->desc.field_len[++s->desc.field_count]) {
> > > +			if (s->desc.field_count >= NFT_REG32_COUNT)
> > > +				break;
> > > +		}
> > 
> > Isn't the second check redundant if you adjust the first one like so:
> > 
> > | if (data_len >= sizeof(s->desc.field_len))
> >
> > Or more explicit:
> > 
> > | if (data_len > sizeof(s->desc.field_len) -
> > |                sizeof(s->desc.field_len[0]))
> 
> I see, you suggest to ensure last item in the array is always zero.

This is what's required by the while loop in the original form, I don't
see a real reason for it, though.

Cheers, Phil
