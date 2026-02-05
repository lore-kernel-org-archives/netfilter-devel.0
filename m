Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001F721ADB7
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 01:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770254954; cv=none; b=XlEW9ogJNayeCUAEAZXyKHhgdzg1xT+dMeNifm1pef8XFjB0l8HKk/LHgVy38ilmQDwVVDrZj/EyVlUr2HSnYY3ujXKJ/nAvW9SSWblefhZj34RMlcz2ZRDBENZodUGuWhzcdvemA9iFL9BttCnCb34kQ/Zo2nfwJnHRzY/tkcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770254954; c=relaxed/simple;
	bh=2fTgC2C4Xkt9ebSweAPrKwjSAJ1XAjmD1y1P20jgQ+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jf6M40X+sZRQxA3jepBFXaJJuy4M9/sHcXRog0pwXZSji5dWjggK7bvMHb5YsRkFafD9E9i7IDnfh0OxciaR8/igKb0s+YIJhyJSObqC1m/EJ20AWtG2Nk/s1OFfCZ5HVtfS4lAo55AZiwBoE/POycI/O3VQ49y4cm8AiZFJTdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D9kWLoxH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D9kWLoxH"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 94D1060275;
	Thu,  5 Feb 2026 02:29:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770254945;
	bh=fFwg268tSmpsTgfKqiJ5jXfjc/rHl1dmWTKBdtZ6h6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D9kWLoxH4U2yl6kCXBto0jtBfh74lSz1GMm5q6DSAv30t6NxPKzJ/91zSvw+J8M9d
	 Kt6dIVPlh0z/gHyRINgtjFdAx8IwPgyq2zB7dq4iSi9pPftMNbzhNCXVlazHB0B7dV
	 Kc9kjQACYgbs1qynyRdriTdJCenPCEkHDa1vD7g3ASwTIsLX8UdFYDsVwkThloXmrw
	 Q7Jvgh3J2vn6i5zafV/2zDPuzSBy6oAmSWqNn5CunME/ORaJzizAn4FUmK33tarsAb
	 dzdH+EmzS6gvslKFDccquN7TNoO05aRly1MQ2HfyROaPwMCHbbrUk5UU89FECWQiCB
	 stt37LZPl7rOA==
Date: Thu, 5 Feb 2026 02:29:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/4] configure: Implement --enable-profiling option
Message-ID: <aYPyXsiChD6WfcBB@chamomile>
References: <20260127222916.31806-1-phil@nwl.cc>
 <20260127222916.31806-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127222916.31806-2-phil@nwl.cc>

On Tue, Jan 27, 2026 at 11:29:13PM +0100, Phil Sutter wrote:
> diff --git a/src/main.c b/src/main.c
> index 29b0533dee7c9..bdcf8ab3c304b 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -16,6 +16,7 @@
>  #include <errno.h>
>  #include <getopt.h>
>  #include <fcntl.h>
> +#include <signal.h>
>  #include <sys/types.h>
>  
>  #include <nftables/libnftables.h>
> @@ -360,6 +361,33 @@ static bool nft_options_check(int argc, char * const argv[])
>  	return true;
>  }
>  
> +#ifdef BUILD_PROFILING
> +static void termhandler(int signo)
> +{
> +	switch (signo) {
> +	case SIGTERM:
> +		exit(143);
> +	case SIGINT:
> +		exit(130);
> +	}
> +}
> +
> +static void setup_sighandler(void)
> +{
> +	struct sigaction act = {
> +		.sa_handler = termhandler,
> +	};
> +
> +	if (sigaction(SIGTERM, &act, NULL) == -1 ||
> +	    sigaction(SIGINT, &act, NULL) == -1) {
> +		perror("sigaction");
> +		exit(1);
> +	}
> +}
> +#else
> +static void setup_sighandler(void) { /* empty */ }
> +#endif

Nitpick: This is small, but please add it to src/profile.c, to make
extending it future proof and reduce ifdef pollution a bit.

With a include/profile.h also you can define the empty stub for
setup_sighandler() when !BUILD_PROFILING.

Thanks

> +
>  int main(int argc, char * const *argv)
>  {
>  	const struct option *options = get_options();
> @@ -375,6 +403,8 @@ int main(int argc, char * const *argv)
>  	if (getuid() != geteuid())
>  		_exit(111);
>  
> +	setup_sighandler();
> +
>  	if (!nft_options_check(argc, argv))
>  		exit(EXIT_FAILURE);
>  
> -- 
> 2.51.0
> 
