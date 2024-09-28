Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CAF125B9
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2024 08:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727513943; cv=none; b=c9w+tf5qdodVmSf7b3YCaxNEFp67Fehn1Oj0CHODMok7iemuWSfus6zkjVxJibBoDPgjIqJ0dZNYsbyGE3tj04MbTNIdafbhpQRRoF9ob266odd6eVr5yDns2hs6NJkqYo/zFqbHcxAkFvGfwVktaZyyJVF+abGd7k+c/nMy/Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727513943; c=relaxed/simple;
	bh=0rLQ+n4XuHGdXfKXVdqzgEr41Q4rttObc9Fd/sD+BW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDD6jsq1+c/z4G619gKjU6VGgzedNNZxxntHzXv0IwtFLyOoWUnMAbvAP4OaHBm1f2zq4OY51QY6NbkS9H+RZNaDOraOHdNa3xZXqYHAC3j/bteMt8raw0YUSifQPU7m2Jr6BhRHu22zGFvrQv82qmQeXW5EIszFvOnqMMeuy8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1suTHv-0004n8-D2; Sat, 28 Sep 2024 10:58:51 +0200
Date: Sat, 28 Sep 2024 10:58:51 +0200
From: Florian Westphal <fw@strlen.de>
To: imnozi@gmail.com
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables 1.8.10 translate error
Message-ID: <20240928085851.GA18031@breakpoint.cc>
References: <20240928001227.2b9b7e76@playground>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240928001227.2b9b7e76@playground>
User-Agent: Mutt/1.10.1 (2018-07-13)

imnozi@gmail.com <imnozi@gmail.com> wrote:
> In iptables v1.8.10, iptables-translate has a small parse error; it doesn't like log prefix that has a trailing space:

> [root@kvm64-62 sbin]# iptables-save|grep -- "^-.*LOG" |while read a; do echo -e "\n$a"; iptables-translate $a;done
> 
> -A invdrop -j LOG --log-prefix "Denied-by-mangle:invdrop "
> Bad argument `"'

Thats because iptables doesn't support it either:

iptables -A INPUT -j LOG --log-prefix \"Denied-by-filter:rstr_rem \"
Bad argument `"'

This works with iptables -A ... because shell removes the "" before
passing it on to iptables, so you could amend your script to use
bash -c "iptables -A ...".

or, simpler yet, try:

iptables-save | iptables-restore-translate -f /dev/stdin

This should work.
