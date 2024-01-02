Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D95FBE7
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=50924 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rKenc-007xg4-F9; Tue, 02 Jan 2024 14:27:18 +0100
Date: Tue, 2 Jan 2024 14:27:15 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nicholas Vinson <nvinson234@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl] chain: Removed non-defined functions
Message-ID: <ZZQPM7YeHRO7q349@calendula>
References: <f5b5ce9e42b038cb43064764385813fedd556bf1.1703646281.git.nvinson234@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5b5ce9e42b038cb43064764385813fedd556bf1.1703646281.git.nvinson234@gmail.com>
X-Spam-Score: -1.9 (-)

On Tue, Dec 26, 2023 at 10:05:17PM -0500, Nicholas Vinson wrote:
> The functions nftnl_chain_parse(), nftnl_chain_parse_file(),
> nftnl_set_elems_foreach(), and nftnl_obj_unset() are no longer defined
> and removed from the code.
> 
> The functions nftnl_chain_parse(), nftnl_chain_parse_file() were removed
> with commit 80077787f8f21da1efd8dc27a4c5767ab47a1df6.
> 
> The function nftnl_set_elems_foreach() does not appear to have ever been
> defined.
> 
> The function nftnl_obj_unset() does not appear to have ever been
> defined, but declared within commit
> 5573d0146c1ae71ac5b3e4ba6a12c00585646a1a

I have provided a patch to support nftnl_obj_unset() for consistency
with other existing objects.

Unless anyone says otherwise, I'll apply this with minor updates
(stripping of the nftnl_obj_unset() update), thanks.
