Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4710433C0
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2024 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727548811; cv=none; b=OytojWX+3/X+vW/crDK5O+WaQuOABYTFs6jg3OKQGQjNtp63YDbsTfnsfmu9uoiV7KiS4ETq8lD2VDO/0nab70YD5Fy/8DdLYytXikAdMvGWBKmGWsOHFoq6dX21C6MhS/tlbNcBcvrJPZUyQ6rO0xWTIdctyKQzlJFUVYohGuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727548811; c=relaxed/simple;
	bh=j4PWLoEU5STK3efxAzAOZsaZrIGvmsh6/ZBnKAvsASA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grm24+uIuOqwPkdFhTcOAN5kv6/A6d7h6PCGAUZdiYWNtp6f034UDCe5/NcuEZmAXymfhVTNNKq31naD5ZifRF/9V3SV9/ZJilbAZREicBnDYhJqAHlMvBIxHyTLw4nSCbCXo0FclcxLITtEWDezA9gXMi1qG4QRJwH9aHuga4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hEwWfQ69; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hEwWfQ69"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VNLqHYaD8IaSdDg+xXyiThKSjq2xHKrxwu8xR8ni4u0=; b=hEwWfQ69EOCrMrgl35NDPRhgtn
	fdhOj24ecqFDtx4XPAaL8BwCGyiHBcsyC2aS3Ivg5tfvOa9oy6NoVLVxJNKFe4gHyiOSlaqOfWyn0
	Ve6GHJnBAd8JYBmuRNXgNXjdLrqR0H82+spfPNMu4trK2NUOTRzfKavr7EPDtHJgXFN0wB2SfJzkR
	P1A+6RMFJk3kYosNAqMMQHHO7AKurEDUVcUAjTH/parvkAY9wCfMedx9SmhMvTVxfrakiQ9kf61AJ
	yWLOhuSnXzUFnwIzPWuA1GujE/p1d9GyKgXII3s9W3K1qxD7jzYrFpIuFlSb+AZ0X4JvjW+9lrXxI
	Yaoup3ug==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sucMJ-000000004BW-1NxB;
	Sat, 28 Sep 2024 20:39:59 +0200
Date: Sat, 28 Sep 2024 20:39:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: imnozi@gmail.com
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: iptables 1.8.10 translate error
Message-ID: <ZvhNf0ZjqFX-41v7@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, imnozi@gmail.com,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240928001227.2b9b7e76@playground>
 <20240928085851.GA18031@breakpoint.cc>
 <20240928082713.3f394112@playground>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240928082713.3f394112@playground>

On Sat, Sep 28, 2024 at 08:27:13AM -0400, imnozi@gmail.com wrote:
> Ah. Does iptables now auto-insert a space between the prefix and the message? 1.6.0 didn't, which is why I added those spaces years ago.
> 
> But then, how does iptables-translate grouse about the '"' being a bad arg if the shell strips the quotes out?

It's the other way round: You're capturing the quotes in $a so the shell
will pass them to the command after expanding the variable reference.

[...]
> > > [root@kvm64-62 sbin]# iptables-save|grep -- "^-.*LOG" |while read a; do echo -e "\n$a"; iptables-translate $a;done

Your test-script is simply broken. Instead of 'iptables-translate $a',
call 'eval "iptables-translate $a"' and everything's fine. You did not
try calling iptables-translate with given parameters manually, did you?

Please keep in mind that the first step after writing a test script is
to debug the test script itself.

Cheers, Phil
