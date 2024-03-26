Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88365C61F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2024 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711459281; cv=none; b=VndMZ0iN/ENFwt2fpuX9J9cpa4vRzHYStYZ+XAefIPP1XaFnThikCWxhuqDPstMlkqhYgcTFAQpw9spV/kUpSpVeTUYmtEv8QkXRx0nGy7lzmJxLV+hyzppMVrbavZ4KAKflVf8NEaZ6+S41gCGUD00BQ7nLKFRw/ztiX512Hq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711459281; c=relaxed/simple;
	bh=52fKov18dk659w31AtaN4/y0YGkjK5qaus6hElbsb7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1zqHriduwWra8eEq83N5losv25OCCRwBsZekHLV6FpQnsHVeKAX0/In0uo95C0iwhmsl1Tnlv5+miXYhpjni13t0Mkq+vfGKFVvQdqTtOZVXczod7Z+1NW4BT3P8SiTwPXCoK6i6JWyKqN6lAwqE61bC+B4M12R5P8Db83yIzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=G5onVafj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="G5onVafj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IEU1Bb62qlWVkFUCmHCtS1dU3MncEX5QwQhCwzvhjWY=; b=G5onVafjnHnyVP4Ht+Lq697bUT
	QXnbuyd2iHCFq+JoI7KjveqUJxHilfdFHMQLxdWXz4C1lNYyug+0YXNuhY6SsglKv+t8fvXJIKmB/
	LzXNoZ699VtW8JFIMIS5AwXh8gmF8SHbIUzMWAzFtVhIf6mPebg+rvJUwmoHi4WNrtEzS5hMJz1Hn
	NGLpm50NZ517SGIgfqhSji8IaFY6yyUKCKDqUlYpBLUsRcS/nmCQ9qkIkHfHBd67a8Qwe7KHioCqg
	5M+iJcBJ4gH/z4MXCIUxTGef2yRx+2vQNNC7NsDlKHZryl2jxtcwyAf95PsAFzgbFYEc0MRCJv42x
	9rQKjrZw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rp6jm-000000002oV-329Y;
	Tue, 26 Mar 2024 14:21:10 +0100
Date: Tue, 26 Mar 2024 14:21:10 +0100
From: Phil Sutter <phil@nwl.cc>
To: Quentin Deslandes <qde@naccy.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] Add support for table's persist flag
Message-ID: <ZgLLxn9LZp8xhmSP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Quentin Deslandes <qde@naccy.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240322154855.13857-1-phil@nwl.cc>
 <20240322154855.13857-3-phil@nwl.cc>
 <f3f6acf4-1f20-4571-b452-85c5d0299a21@naccy.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3f6acf4-1f20-4571-b452-85c5d0299a21@naccy.de>

On Mon, Mar 25, 2024 at 02:33:48PM +0100, Quentin Deslandes wrote:
> On 2024-03-22 16:48, Phil Sutter wrote:
[...]
> > diff --git a/src/parser_bison.y b/src/parser_bison.y
> > index bdb73911759c8..1ade7417f8d6a 100644
> > --- a/src/parser_bison.y
> > +++ b/src/parser_bison.y
[...]
> > @@ -1930,6 +1921,31 @@ table_options		:	FLAGS		STRING
> >  			}
> >  			;
> >  
> > +table_flags		:	table_flag
> > +			|	table_flags	COMMA	table_flag
> > +			{
> > +				$$ = $1 | $3;
> > +			}
> > +			;
> > +table_flag		:	STRING
> > +			{
> > +				if (strcmp($1, "dormant") == 0) {
> > +					$$ = TABLE_F_DORMANT;
> > +					free_const($1);
> > +				} else if (strcmp($1, "owner") == 0) {
> > +					$$ = TABLE_F_OWNER;
> 
> Don't you need to free_const($1) here too?

Oh yes, thanks for spotting it! Guess I messed up some c'n'p here, the
code is really obvious.

Thanks, Phil
