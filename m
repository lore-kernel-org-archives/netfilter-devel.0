Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756EB34F474
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 22:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779920668; cv=none; b=lx7zpErC/HRIwiMm5V0YU25BHJ75g6SLsNYXl+EQjVU+dCxu1hKknVex31U/J8m+It4ohXBkAtC+m0yRXPZslrASCpk3/qaqXmEkNyFy1QOF5mJIISA8mQPGwU5Me4xXUbka/CvV0rlb88b6Y+4GbLv7wU+LxntxFLHxD07bY6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779920668; c=relaxed/simple;
	bh=fybwaFxqKtSwnFZ3Zb3u9ebVj1FzfPPT980QVUek5hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WU5qPE8UIe85dTCkqkmec4l9JS1Itrxt/Gqubo174qkZsybm4TabAxG0ACPrlymyZlYwXx7mg5aFk+zJL3JSHLbcbQxrebSVcLScCfPL8LTaML7gzMFphT+fXwywfv+g2bxsmbB/zy0WSIg/l8B34vT1lltPph3LXaUDu3ZNsOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JLnTP+dX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JLnTP+dX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 159CD60181;
	Thu, 28 May 2026 00:24:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779920657;
	bh=mPa+yrLh78aLOQSl9tqxodEwT/W/NP1k0Lw63FiG924=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLnTP+dXO6VJHL7xZG3pz8pKiGQEE/yUekLmQ4jBJaluN1Mcrtzed0yUzRcrt+Opx
	 tSgFJ1f9p8503Rm772O8MS9kkNolPQiJkTN/2u8h3Z/uvvhq900rajNX9FJEa24LTD
	 ngfkkC4SERGoaCmqo3TxZ9oseodr+ub1+3MK8auO0/RpkAstM2L8FN4SZYNi259uQU
	 cI0+eBWPk5Dey7fk/lrGxJj2rWbLrDBk1s4XWv28Kz02/f6/1otmRuAsCce7q13/Ri
	 XKzZJbeUkgwUBmXJBRfkiG0NFM5Vhpzwc9JqwG2Q2Qt5E6mAC0FpLh3y2uUctnggL/
	 QPBE27MMtqZ5A==
Date: Thu, 28 May 2026 00:24:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc
Subject: Re: [PATCH 0/5 nf-next v4] netfilter: synproxy: misc fixes about
 synproxy core
Message-ID: <ahdvDhDXmPjh1kZ3@chamomile>
References: <20260526215831.6726-1-fmancera@suse.de>
 <e610bace-a04a-4f6c-bea6-3e9d6646352a@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e610bace-a04a-4f6c-bea6-3e9d6646352a@suse.de>

On Wed, May 27, 2026 at 04:10:36PM +0200, Fernando Fernandez Mancera wrote:
> On 5/26/26 11:58 PM, Fernando Fernandez Mancera wrote:
> > This series fixes several long standing issues during synproxy timestamp
> > adjustment and concurrent hook registration. From ignored error handling
> > to unaligned memory access. Most of this are not issues impacting real
> > setups as they would have been reported before.
> > 
> > FWIW; I am sending these fixes as separated patches because they are
> > addressing independent issues.
> > 
> > Fernando Fernandez Mancera (5):
> >    netfilter: synproxy: drop packets if timestamp adjustment fails
> >    netfilter: synproxy: adjust duplicate timestamp options
> >    netfilter: synproxy: fix unaligned memory access in timestamp
> >      adjustment
> >    netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
> 
> Sashiko pointed out another issue around nf_ct_seqadj_init() not related to
> these patches. Could we get this merged (if it looks good) and the move
> forward with a follow-up? I am afraid of pilling up a series that it is too
> big.
> 
> Any thoughts?
> 
> P.S: I am owning the follow-up I just want to reduce the complexity of
> getting everything merged together.

Follow up should be fine, thanks Fernando.
