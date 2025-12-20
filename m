Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBFE275106
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Dec 2025 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766264824; cv=none; b=De58NDIw1BHcUavHTEEypAlTctygZPb62MBWgKlrk4/YbLj301ZAgXlr644Z9Wkz0Y2arpcfLsyBNmjaBBMbOVoyiHLeFVyR/d9J43yU5Y6WLWUDNsrBMk8w+xyADoGxW3NPTlVr51gQSMoobP5ZotCr8XXJ83W/69/L2gN5frA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766264824; c=relaxed/simple;
	bh=I7vRj9dPTp90EuLlDTTIOVGANFiwvxyISL8TWE3GjB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvhmnbXnGrxthbnRLZ1D5ipRi4kX+7E8PHBUkXeXPlAUZjOxS497W9lUHKhDVKOhnemZadIU4Uu4fnVj/GYoj2nyEZtfLTx6cmVhP+oJgC23x6kVj6enIeVEbm+aMywh5b7MyfyqNV6yI9m4p+2LTJHDGK75DTaMgG7opNtKCy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ggjMCjhA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ggjMCjhA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 089476024E;
	Sat, 20 Dec 2025 22:06:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1766264813;
	bh=vVQY0KW6HMuhIV6f3HzzIzlnForvo1bXhNXvhsCNsCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ggjMCjhAjweyNNMeQtMCAEvR4ggXlA0kVVimGhzhblGHHM571MKFuGZhipxYNzhy9
	 1436Cy194qhZ93GaDWqNk8ZKHou77huBmaiAvS2BqMpVYL5EK7VJ9XsxwJ0kaeq3MR
	 1aJjgIt9Ot/4LDBLG/nt0/JM3V8fuu5e57mcqy4dYv+VYTF97s9gsMuCP7zF1zPWZm
	 mpAMAYbgICRoo2XBjLxX27qFQg0f0b/TvBv8KrRQZn6SDmcTfV91G+eNzxJMAgkyIt
	 FjE2XSoo8E4MLRiciL1/ZWkvwFM2VLAGzgW3ysoAEJ/EKSb6iNtjc18BM49fVNRzyc
	 7LwRhoNpVfH0A==
Date: Sat, 20 Dec 2025 22:06:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilia Kashintsev <ilia.kashintsev@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Null dereference in ebtables-restore.c
Message-ID: <aUcP6vw_zdSbmWFs@chamomile>
References: <CAF6ebR7PoBEpheSSjsSZqxUJh3yPeh1KjGTuGWsG0KwbuhJKMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF6ebR7PoBEpheSSjsSZqxUJh3yPeh1KjGTuGWsG0KwbuhJKMQ@mail.gmail.com>

Hi,

If you want to contribute to this project, you have to send us patches
in git-format-patch.

Thanks.

On Thu, Dec 18, 2025 at 04:17:39PM +0300, Ilia Kashintsev wrote:
> Suggested fix:
> 
> Check strchr() result before trying to dereference it.
> 
> diff --git a/ebtables-restore.c b/ebtables-restore.c
> index bb4d0cf..c97364b 100644
> --- a/ebtables-restore.c
> +++ b/ebtables-restore.c
> @@ -76,7 +76,9 @@ int main(int argc_, char *argv_[])
>                 line++;
>                 if (*cmdline == '#' || *cmdline == '\n')
>                         continue;
> -               *strchr(cmdline, '\n') = '\0';
> +               char *new_line = strchr(cmdline, '\n');
> +               if (new_line)
> +                       *new_line = '\0';
>                 if (*cmdline == '*') {
>                         if (table_nr != -1) {
>                                 ebt_deliver_table(&replace[table_nr]);
> 
