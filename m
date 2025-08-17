Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5A61487F6;
	Sun, 17 Aug 2025 21:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755467691; cv=none; b=Edq6XWPlNe9sYzdrkeuKp9KojmE8GTsq0kjxUQPi0s9a7sg8jQWUcdcx1F3V3gRfZMs+HXqqqvPF9mDmQVdU+B+q+kO1wbN2MGJDZ5lGrA1TcMAOrc6IKRHamzjgtCTqRAf0bwUBTOv3Vpyt85M6ds128dM8gjBiYWJoO7fLN8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755467691; c=relaxed/simple;
	bh=IWXFC2voGJYKNiNyf8ME06rV59gjN6vG1F4rNXKyPJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXPE6KnyM8ZvhST5w22F/UCDESY2dfTjo8HatgifmyD/h91ZpSsoBUWJYtUd9i/0y+EQsBZHWL03witJLnPoDqijG93owY5dPQLyqiElb3ilJcGntvhaecpCM+GsNy7F9hAYVAGzf5MYDL6tU3dVuWecoKY8dRwF3EMCMY+0FIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BrTxEm7N; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BrTxEm7N; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BrTxEm7N";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BrTxEm7N"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B045960254; Sun, 17 Aug 2025 23:54:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755467687;
	bh=1Y0+UCKsxFUq4up0QIEksQ54PIsmsZM+UE/W2SjIhpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BrTxEm7N5gG+ZjmYuU7CLYycDE2nyl38DUQaoxdJ10nqKSQaOuC6Hry34sId22qwv
	 KoKJROkuSfXhgrTbdNX3LvFzMNxfCrq+x2oiy+Fs6IT7VJ2F6TX1ea8sfahz+dZ6Ec
	 ATZULc8YtM7ELaoZgXbYYczeBPxHsYmO0CLqeC62UEXYHscqY3Ed+iIyUBt0s79XQU
	 4QMKmMU1irPOlItKuRHzpdzb62ZzaHEHt9qgS+1UGgXdvXtTjcN68CjLMuLXB+Fiut
	 ffOtbVSX5tYNzftRXzU/reAT1WFDv85cB0RW1vUSVudjHNJPafr13GPoFo9t5yZekk
	 2UoKsSkn4lKIQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4DE086024E;
	Sun, 17 Aug 2025 23:54:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755467687;
	bh=1Y0+UCKsxFUq4up0QIEksQ54PIsmsZM+UE/W2SjIhpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BrTxEm7N5gG+ZjmYuU7CLYycDE2nyl38DUQaoxdJ10nqKSQaOuC6Hry34sId22qwv
	 KoKJROkuSfXhgrTbdNX3LvFzMNxfCrq+x2oiy+Fs6IT7VJ2F6TX1ea8sfahz+dZ6Ec
	 ATZULc8YtM7ELaoZgXbYYczeBPxHsYmO0CLqeC62UEXYHscqY3Ed+iIyUBt0s79XQU
	 4QMKmMU1irPOlItKuRHzpdzb62ZzaHEHt9qgS+1UGgXdvXtTjcN68CjLMuLXB+Fiut
	 ffOtbVSX5tYNzftRXzU/reAT1WFDv85cB0RW1vUSVudjHNJPafr13GPoFo9t5yZekk
	 2UoKsSkn4lKIQ==
Date: Sun, 17 Aug 2025 23:54:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org
Subject: Re: nftables 1.0.6.y stable branch updates (strike 2)
Message-ID: <aKJPpBQygmpfAZQh@calendula>
References: <Z5J7Vh5OPORkmmXC@calendula>
 <aIv5RcJY6RycFRFc@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIv5RcJY6RycFRFc@calendula>

Hi,

On Fri, Aug 01, 2025 at 01:16:21AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> I have updated the 1.0.6.y -stable branch:
> 
> https://git.netfilter.org/nftables/log/?h=1.0.6.y
> 
> This branch contains 334 selected commits out of the 887 commits
> available between v1.0.6 and git HEAD.

For the record: I have just updated this branch again to include 52
more backported recent fixes.

[...]
> Proposed plan is to release this -stable 1.0.6.y after nftables 1.1.4
> comes out, in the first two weeks of Aug 2025.

A new nftables 1.1.5 release might happen due to a regression in the
JSON parser, release time for this 1.0.6.y -stable branch is expected
before Sep 2025.
