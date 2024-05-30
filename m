Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED40920322
	for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2024 07:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717055553; cv=none; b=ojGGZFJ8AMQ4EQrxmpgm41cWD20XfEhhhYR22WLLb3W64kiklH1obOjCmlWdT4dGVtyXh8l065mXYZ6kjn82z6Y39pNMUI/SH0Iagj37/DffWZdCm07WIYff3y3sEYx96NQLhzjFXvTm22G/BCqwZ7zh0O06ypzsUvTGnKlt9Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717055553; c=relaxed/simple;
	bh=UEuux+9gAr029aRO7lrsS9R+qUkjQ2VCcyyeTYu2fqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjP/rqXIMQn6Gn5remH+KQCikxbEpQ5JYGKqKdXwei7ptWMKE9ArHA3gn/7RqRbVVvhOyZLZXNV5b4AFkhD3ILHdeinKBPYSmVf/RHlZSR6Yhf1rFZg1Acc0yNJwZE5clmIGCcMudj8uFVKltLpjRh+6hHYiA2dXFZv8jTwbBiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sCaaC-0000TL-I5; Thu, 30 May 2024 09:52:20 +0200
Date: Thu, 30 May 2024 09:52:20 +0200
From: Florian Westphal <fw@strlen.de>
To: wangyunjian <wangyunjian@huawei.com>
Cc: Florian Westphal <fw@strlen.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	xudingke <xudingke@huawei.com>
Subject: Re: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Message-ID: <20240530075220.GA19949@breakpoint.cc>
References: <1716946829-77508-1-git-send-email-wangyunjian@huawei.com>
 <20240529120238.GA12043@breakpoint.cc>
 <d6a7fe4b75b14cdda1a259c2acb10766@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6a7fe4b75b14cdda1a259c2acb10766@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

wangyunjian <wangyunjian@huawei.com> wrote:
> > -----Original Message-----
> > From: Florian Westphal [mailto:fw@strlen.de]
> > Sent: Wednesday, May 29, 2024 8:03 PM
> > To: wangyunjian <wangyunjian@huawei.com>
> > Cc: netfilter-devel@vger.kernel.org; pablo@netfilter.org; kadlec@netfilter.org;
> > kuba@kernel.org; davem@davemloft.net; coreteam@netfilter.org; xudingke
> > <xudingke@huawei.com>
> > Subject: Re: [PATCH net] netfilter: nf_conncount: fix wrong variable type
> > 
> > Yunjian Wang <wangyunjian@huawei.com> wrote:
> > > 'keylen' is supposed to be unsigned int, not u8, so fix it.
> > 
> > Its limited to 5, so u8 works fine.
> 
> Currently, it does not affect the functionality. The main issue is that code
> checks will report a warning: implicit narrowing conversion from type
> 'unsigned int' to small type 'u8'.

Then please quote the exact warning in the commit message and remove the
u8 temporary variable in favor of data->keylen.
