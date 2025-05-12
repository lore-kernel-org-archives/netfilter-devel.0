Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D5425A32A
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2025 10:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747045422; cv=none; b=P7ALYzyUe830qqsupNf2GMMuwKu5s/A29FD/9Vpi2RVOOEgmYkhSwYVEGG2kDYyc4n0lJbXBHCZjZ6gTmktdN6PSu+QgfWNlrR+Fdq5Jc341Q557iaY6kMuGzKEJjs1cwzqUN+cWuq5Au3iG9g+E4R9EHB/PYwDpOgS/zyKpZmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747045422; c=relaxed/simple;
	bh=aI0fhk8+5czSg7Nd8dzJMROIVuRfY50SDs36spXqGBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IodxAZrg6n6IBaKFSxyQZTymGrAixIdx32LpugRq54CX9XMgCmAUDGqORRVWgDJFFbXtje40EMK7OttxcOwK/3B4kgfmlu3HDNrrmjCVBYui0Oz9gmRkGskB4UDNjeHuskeZQTDtqQO3QIPP/jBLK0IZw4F4ojpX6FvYug5YGSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B137jdzP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B137jdzP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MzD1nmKuhXwANk02AE5y2rDumD4sRELCwfZIC0lDWSE=; b=B137jdzP9NX6M11q2sUrKuGJw7
	tNidAvvZxeyBeHibEj0uAOlYJl3ZDY0xG6sdmaDyJNr1q2rRvRY7U7Do7nRkUBR4ofJT0piqlOHn7
	pcv/GxMCd32n9TPTbR/xkKgB69YTfTfyMoCXGUpwmAsbmDn9HDT6aHRw8cIpwtDtDYdovAg+P0XJi
	Mfz+IWnNbNgSHEmZdf9yTa0WTVhHM6r83W9c+zy54yxFfpk5j6eaT7qmPoDwIY59CUAdqzcF0o3kR
	lmI4Z8U90NDqD82HAPukh4idgzuxItxjTgNH3ED4w0vczPB/5jaI/gMkNSLRFqS0YgUiQbglwSpKy
	iP6pxT5A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uEQJk-000000006TW-3yYl;
	Mon, 12 May 2025 12:23:28 +0200
Date: Mon, 12 May 2025 12:23:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: =?utf-8?B?5ZGo5oG66Iiq?= <22321077@zju.edu.cn>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Fix resource leak in iptables/xtables-restore.c
Message-ID: <aCHMICSGU2LT7SS-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	=?utf-8?B?5ZGo5oG66Iiq?= <22321077@zju.edu.cn>,
	netfilter-devel@vger.kernel.org
References: <87aa5c8.77e3.196c354f80c.Coremail.22321077@zju.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87aa5c8.77e3.196c354f80c.Coremail.22321077@zju.edu.cn>

Hi,

On Mon, May 12, 2025 at 03:10:47PM +0800, 周恺航 wrote:
> The function xtables_restore_main opens a file stream p.in but fails to close it before returning. This leads to a resource leak as the file descriptor remains open.
> 
> 
> Signed-off-by: Kaihang Zhou <22321077@zju.edu.cn>
> 
> ---
>  iptables/xtables-restore.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
> 
> index e7802b9e..f09ab7ee 100644
> --- a/iptables/xtables-restore.c
> +++ b/iptables/xtables-restore.c
> @@ -381,6 +381,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
>                 break;
>         default:
>                 fprintf(stderr, "Unknown family %d\n", family);
> +               fclose(p.in);
>                 return 1;
>         }

Since this is not the only error path which leaves p.in open (eight
lines below is the next one for instance), why fix this one in
particular and leave the other ones in place?

Cheers, Phil
