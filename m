Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92487139CF6;
	Mon,  9 Sep 2024 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725895038; cv=none; b=LdB3Nk88p6oYxHrXIveVhEQtpqG6S3A03/Jj7rdC6NWzOLE+35Vau/aO0l7nrnZsIHJ/N9e/SQJDO3hAgJ1hL4Drw4B2uVoGwVrB8yuEw0NTwVDSAQa7F0NEeRugc/nURwUPmgUQjOnvlF27grIaflrwWHm2KHFmVuza7ShqB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725895038; c=relaxed/simple;
	bh=4UnHiTSmesifrapU4hY+D7bZkm176mfI1MGT9K3EfJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEUyG5iYKATHC3hAw4U11WKshi30whr0DpGdIRZ2yLmGrClktjGanttb4SjTrEJhKBJI5z6d6ayJZrUf6SLUMVe3pbGeWbbO8qH1uDlDluD0ucfx2qgXVX3PmYuZUyJl4slWlGOYMJdQocWLI9ROibbiaA/qCW+mjJmz/3CuaFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7YNXVJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7YNXVJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC3BC4CEC5;
	Mon,  9 Sep 2024 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725895038;
	bh=4UnHiTSmesifrapU4hY+D7bZkm176mfI1MGT9K3EfJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i7YNXVJn8mr9u3JIms5lk+k+0EzePN3dufNOrxgBDlOeiNGUgv9H1DPzP/hVyfXz3
	 8GQPnUs7e7O/fgP9sikPQRa0V4ZunBXutjASuST+9zmflFiqLsb5OfsahR75KyybqP
	 x8uV+TjA4dwXr19Kxsjl0VvRU8QNJZF2dLGZpUwOHJyE5hq1r/rrCHFbvyZjbW3ysj
	 m069t3GrumzbDer2HEz31i/caWeK0y5bXNi2tlbSjo4HS350D7cwczQLl4YBkdATxA
	 1cPvXLTpY++jkiCI5d1RrH0+VYI1ghZT0wNSlghgnuRFRAt7RozHimqJ8thKy2Mavk
	 plHpgn0RD9iwg==
Date: Mon, 9 Sep 2024 16:17:12 +0100
From: Simon Horman <horms@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Felix Huettner <felix.huettner@mail.schwarz>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: conntrack: Guard possoble unused
 functions
Message-ID: <20240909151712.GZ2097826@kernel.org>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
 <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>

On Mon, Sep 09, 2024 at 12:37:51PM +0300, Andy Shevchenko wrote:
> On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> > On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
> 
> > Local testing seems to show that the warning is still emitted
> > for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> > but CONFIG_NF_CONNTRACK_EVENTS is not.
> 
> Can you elaborate on this, please?
> I can not reproduce.

Sure, let me retest and get back to you.
