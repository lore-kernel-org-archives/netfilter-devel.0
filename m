Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB79173
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753896471; cv=none; b=dzjetzJWW0QTeYLTBOXXBJ1QDgL6CzweEvh6iUeowy7q0NbmUlGCYlMovkF8qQE5EmTM2w+YlyHr1uEyc97VRk54I0hLI20ML7G/BY6xCsIFEqdQ7JXGhmt+T0MmxaZZMUR8RBvAGXkSHNX0z81bwmXXLHMY6zS9Q09r+0KLg/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753896471; c=relaxed/simple;
	bh=1k2X/34eMggpi71wkip5bMeLWY94L59V21mXg9zDXp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3eWbtHgjaIKmirRiRb7yt+Bi0MV8Ok8YqM9MNxVk52A7juI93pYv2Bx4kJeLLqHjFYYe3VJW9hDQCNjV6/FsbHpe6eIZ1IoDKbwM4IrauYOmntFPBL5HrSxoI0MzO7Su+u3BBOqGK6xdAUC5x+Je6BoLvu0G5oLn26WA/O+A08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W5xuofs9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kwhIohjm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W5xuofs9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kwhIohjm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 33BC260265; Wed, 30 Jul 2025 19:27:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753896467;
	bh=Y2KNSsJTj07sLsuyOX5JKz/OUDph9pq4U1nbY26Ur3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5xuofs9ZHq9Ry1VGaJfhfm7fQqWvYzqxZOQwWdF7pRCH2eqTduJXjKi0qlo/jaiv
	 M7rGMYaPu2pYfmEFfXh/Re/rWGsSwzDBmMlgKU4ClhV7EU0G76jeG89R5F2LpBw6vt
	 hGojBnXtYd65jWtuxukeJoP+JG6FtBa/yZGc8FFdDkKu917CmotwWPlFML2VvcJ1T0
	 YR1wZJtwX9v3FUjLi+JAumPpG1zyUEjqhWFeNHkWzqQPjCvc68NAuee+T2qu04uif3
	 KQK5XFXazosqy+Z4bCjJo3h8IGkmqtnygjzJuffLlzjI3SjaDXuQ/elbvyre88AoIV
	 /ZwU2tBMVVotg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8ABEE60262;
	Wed, 30 Jul 2025 19:27:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753896466;
	bh=Y2KNSsJTj07sLsuyOX5JKz/OUDph9pq4U1nbY26Ur3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kwhIohjmPuxOHsLiEJz9tcH5k4q9JvRy3VzzZq6iZeqgxIKJpfdutZR+24agKb5Rs
	 hNmyFrdejDf3TcSzwxDxm24caAlRKtHI6g+aoHmtqEttGE8m9J9X33IcPdx21dddjv
	 Ac+oN3plz0xjYdoTzpAPpttr0NUcX5SfWhxx32I5UfcTyTktEUrC4eW58HLcmpMKWQ
	 LOUWIBNIyfkX78nxJgNUCTp3oZyUkB9Nk2KQqW6S3zlN4jdRe8nMYJNMMoVDDI1QVr
	 zvqVr05wlNXA8MGgVMYp2fu89K+SMYV21FSIH8tkrQw4dNdfLZOTBaQWvIrLQAkodU
	 F+aOo09GMkA6Q==
Date: Wed, 30 Jul 2025 19:27:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/3] evaluate: Fix for 'meta hour' ranges spanning
 date boundaries
Message-ID: <aIpWD5dIrJuahsx1@calendula>
References: <20250729161832.6450-1-phil@nwl.cc>
 <aIpKnp91SvTCTI30@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIpKnp91SvTCTI30@calendula>

On Wed, Jul 30, 2025 at 06:38:54PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 29, 2025 at 06:18:29PM +0200, Phil Sutter wrote:
> > Kernel's timezone is UTC, so 'meta hour' returns seconds since UTC start
> > of day. To mach against this, user space has to convert the RHS value
> > given in local timezone into UTC. With ranges (e.g. 9:00-17:00),
> > depending on the local timezone, these may span midnight in UTC (e.g.
> > 23:00-7:00) and thus need to be converted into a proper range again
> > (e.g. 7:00-23:00, inverted). Since nftables commit 347039f64509e ("src:
> > add symbol range expression to further compact intervals"), this
> > conversion was broken.
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Sorry, I found an issue in 3/3.
