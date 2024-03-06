Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9933E73507
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736751; cv=none; b=Ja8K3I+7yGVR4iUKOqxtZUq2wxARzEvPHG5OQoBCsDS3y09HpqV8fGYIXxKapk93r5DwPr0zFM/JsKIZ474qAUtc0X6BmjOeLpN23JPteiF8EEhrsYqSk9MBlC8YvFBlHTzcghT6EqQwm7LtQiYu9TdaBIXOde4xr3z1q0o69Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736751; c=relaxed/simple;
	bh=DJ3YB1nORnWV+BAySpiEMtP2o/vaTMugph2kNMIDjs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9+WbYqz6IMoC4DW89zv9m3rqEBSQzDG2zMI8pUKctPx4vAJdegAOHhZFTe0uwpo2NmjPYoNsgmb1690XGIo5EJyrlzQDROpUQQEhSjoLLqs/OPCL9Ao9qCodlKa52Pe4v3gvFTAIRqCFVxVTLqIl4nmhXMthOQGNCLiVCE01QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nmFOneuV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nmFOneuV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IkRk52gMTH9gKlfZkDub7aI7+65oidkJoUSTxwruiWk=; b=nmFOneuV+QNyLgK4hyGlW6q/Dj
	oT6oOjtMamFRFk3S0yD1xpVCmWR1zyh9eSKCXfV1kKJ+SD1TuYT5SAPYI5lR64MD46vFHdfU+m5Nk
	nbtDp8yppxX1a78JRYrXCId6SCBd/9ofgAHC1CPp0e/guXKn28Ga5CRr1uEGdM3sLyC2yHJWnWyeP
	gIZGSw/xpYN8SEjQuNOr1IJESnHqE0GJVBVZsX4FKzv3zYIQrNeOUmsu2rZLMAgBOSOS4gYk6pmml
	paR/Jn27FJtviIzF2NhI4Ng28XeSwTYhHGvJg7l/sol4xF9fl3RK6n8ZH14tsvDOfWpfcnJo4wZ6X
	Xyhrytrw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rhsd8-000000006RW-3d99;
	Wed, 06 Mar 2024 15:52:26 +0100
Date: Wed, 6 Mar 2024 15:52:26 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-nft v2] extensions: xt_socket: add txlate support
 for socket match
Message-ID: <ZeiDKkam7FXpCbiU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20240306101132.55075-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306101132.55075-1-fw@strlen.de>

On Wed, Mar 06, 2024 at 11:11:25AM +0100, Florian Westphal wrote:
> v2: document the match semantics of -m socket.
> 
> Ignore --nowildcard if used with other options when translating
> and add "wildcard 0" if the option is missing.
> 
> "-m socket" will ignore sockets bound to 0.0.0.0/:: by default,
> unless --nowildcard is given.
> 
> So, xlate must always append "wildcard 0", can elide "wildcard"
> if other options are present along with --nowildcard.
> 
> To emulate "-m socket --nowildcard", check for "wildcard <= 1" to
> get a "socket exists" type matching.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  extensions/libxt_socket.c      | 39 ++++++++++++++++++++++++++++++++++
>  extensions/libxt_socket.txlate | 17 +++++++++++++++
>  2 files changed, 56 insertions(+)
>  create mode 100644 extensions/libxt_socket.txlate
> 
> diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
> index a99135cdfa0a..016ea3435339 100644
> --- a/extensions/libxt_socket.c
> +++ b/extensions/libxt_socket.c
> @@ -159,6 +159,42 @@ socket_mt_print_v3(const void *ip, const struct xt_entry_match *match,
>  	socket_mt_save_v3(ip, match);
>  }
>  
> +static int socket_mt_xlate(struct xt_xlate *xl, const struct xt_xlate_mt_params *params)
> +{
> +	const struct xt_socket_mtinfo3 *info = (const void *)params->match->data;
> +	const char *space = "";

The whole "leading space or not" handling is not necessary, I made
xt_xlate_add() insert leading space automatically if the first
character is alpha-numeric or a brace.

Thanks, Phil
