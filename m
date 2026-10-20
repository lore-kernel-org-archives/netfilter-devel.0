Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514134;
	b=hbdUaEHGLvxtpzEm7ndULFnLD0IM315eUxtn27Kk71LH9U8z2pf6yASReoAmj+Oqyzl6
	 ldiGllb/8ZScQ0nFlxGFcUbDhr1PRqXj3W3riXYvZApofdRcOMtrMDhlT2ZllXgRHr28A
	 U3I32NdJHkMS06W1+2p5nHee3Miy6Un/E6xZVZ2LXV2/afmt5jWRl40u/5WZnqPlYw84q
	 Nl6/NPV7l5i8X2o0g7oQ/wfjqS1zALEt85eNUDDLXSFuWOPl6ZagwBGmjkCp6/wgzDTva
	 zBOJYAMzur4UOkDlHwZiubFWD/Mq/tU/bKLIJN1XejM2l1QeekZKm2alKkye1g5Q94g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514134;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=s4USjUJKp3803Q+4KY+Uo3cRBHiK62bJYQEoVrKxiIw=;
	b=qIJh+DohW/tIFyKSMBMPq2KaDThBqjj1unx79ZCf/S7+owFGcKS42Rlm9nIJd+8MRlu3
	 9gaeRRC5lpDeL/hupIaxLoCnWy3P95iv/Kgz5sDAv8Lr/KyPLYf/xqoilzsvPoVlqSozO
	 +kWBCHNu/4ExHm+YXO4HRz6mDw9alqDjcEV3gQh2jN/k7x/e8AjCH0UdIK3g1Z9bfFtWq
	 +wSeqbMaYi9P+TqYjci0oVbLwBnUhXIhi5QLpwTcd1Tbmtx944+DcaYVC6vHHymGIKRjM
	 u/0iBezTjH9MhM56J9sgNAkshHou/blcmzXkMVtfo7VN+mEh1Z2YM4+jNbMbcKGAh5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VM3nIYUc;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2DD03606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 16:35:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DD03606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VM3nIYUc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792514131;
	bh=s4USjUJKp3803Q+4KY+Uo3cRBHiK62bJYQEoVrKxiIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VM3nIYUcQjSKecMlYPa6ZaoY7sVvBCJbmNbf7wRB6huw5DZQWfh7p5dgeQ0BH6Mdy
	 sSiMlQEmEI2W71fXi+jAjmNDmUgowMfAIKIuef4fKt1E/OWhuNjht9m4DTkxMwsIju
	 9Kcr7Tg1IajVmb8czObIRJmOclnyucnbkoYjtB8qDxODJGdKGmtK5MxLD7KVFvB1jr
	 uFyumSZ4SMLDlJx53fwBj5EwFAy1ASdQSs2Rez4OOaqmv321DC83Is6gQrnWByqr9q
	 y2IGhOT9IeL3nlm7EtLzXF9ONKVZVdA9sIo88P3vOnGUAL+UhqwcmWd17FOgxPz77K
	 g2sex2WtwEaSg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1ED056005A;
	Tue, 20 Oct 2026 18:35:31 +0200 (CEST)
Date: Tue, 20 Oct 2026 18:35:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Trevor Cordes <netfilter@tecnopolis.ca>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: expose named set element count
Message-ID: <ateYUFIPFZshosqX@chamomile>
References: <atdp-FBVOOKgN0De@pog.tecnopolis.ca>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atdp-FBVOOKgN0De@pog.tecnopolis.ca>

On Tue, Oct 20, 2026 at 08:17:44AM -0500, Trevor Cordes wrote:
> Hi!  I have an application that can create very large named sets
> (dynamically) of IPs.  For monitoring and testing purposes it is useful to
> get a count of elements currently in a set.
> 
> Currently I an running "nft list table inet mytable |wc".  But once the ip
> set grows to much over 100k IPs, that command can take around 90 minutes
> on my system!  During that time the nft command takes 98% CPU.  That makes
> monitoring in this manner nearly impossible.
> 
> I think the in-kernel code tracks the current number of elements.  Can we
> expose this through the Netlink interface so users can get an instant
> count of elements with virtually 0 CPU usage?  (Note, I'm not talking the
> "size" data point, I'm talking the actual IPs currently in the set.)
> 
> Less importantly, I'm wondering what is making nft take so long to list
> these huge sets.  Maybe the IP numeric sorting and formatting?  If it's
> all the sorting, maybe an nft option to disable sorting would help?  Or an
> option to disable formatting and have nft just dump the whole wad of IPs
> on one line per set?
> 
> Thanks so much.  Please CC: my on replies because I'm not sure my
> subscribe request is working or going anywhere.  The listserv may not like
> my mail smarthost.

There is a count field in more recent userspace nft and kernels, what
nft and kernel versions are you running?
