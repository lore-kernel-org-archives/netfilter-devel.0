Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB7518C07
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2024 10:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=54550 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rKyY5-009RWm-4J; Wed, 03 Jan 2024 11:32:35 +0100
Date: Wed, 3 Jan 2024 11:32:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nicholas Vinson <nvinson234@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] object: define nftnl_obj_unset()
Message-ID: <ZZU3wJKLfQdmatV3@calendula>
References: <20240102132540.31391-1-pablo@netfilter.org>
 <20240102175058.24570-1-nvinson234@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240102175058.24570-1-nvinson234@gmail.com>
X-Spam-Score: -1.9 (-)

Hi Nicholas,

On Tue, Jan 02, 2024 at 12:50:58PM -0500, Nicholas Vinson wrote:
> I manually applied this patch and got the following build error:
> 
>     error: use of undeclared identifier 'nftnl_obj_unset'; did you mean
>     'nftnl_obj_set'
> 
> I think a declaration for nftnl_obj_unset() needs to be added to
> include/libnftnl/object.h. Other than that, this patch looks OK to me.

$ git grep nftnl_obj_unset
include/libnftnl/object.h:void nftnl_obj_unset(struct nftnl_obj *ne, uint16_t attr);
src/libnftnl.map:  nftnl_obj_unset;
src/object.c:EXPORT_SYMBOL(nftnl_obj_unset);
src/object.c:void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr

the header file already has a declaration for this (which was part of
5573d0146c1a ("src: support for stateful objects").

What is missing then?

Thanks.
