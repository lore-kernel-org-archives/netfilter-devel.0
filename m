Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877581C4609
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2025 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754498246; cv=none; b=YyKYXo6SSBnAgqko4ih5AeUGmW5KPR/9OsAFP6ZM0BggbX6uBNrkfl+AaWhfKWSrQZ4l6tPbQSNaoXFppR74aElDM2pzVtGdySUvQZTjAWpyz2rTkd4MnZLKUPIImnTIBaT094ogb2qoNtseR6OIzCZq/Nc3DkW/kj9iCi5TMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754498246; c=relaxed/simple;
	bh=aBV+YAJPTt5CXWMzRduCWo5rq7EJ9rinIT9wdZXxPKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KpyCVfwh3EZB7vf0r6BXU25XO/VfaL2hikuxKByjsjKG3pPTKgoYsgTFsjPeUUx23gJaz0fn3s3rp8pfEbT12g/HaxL3q1fQN1zOqg9Ssr6+51uISXhGb3wR+G1IO68JgIrV66zLG791fByA60/rqSXTH4OZ+zmayI5XwsAVlsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oBHkxaTD; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oBHkxaTD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oBHkxaTD";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oBHkxaTD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A905260895; Wed,  6 Aug 2025 18:37:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754498241;
	bh=mhS3rihhT+N+n/1EHlUoCtf0PDno6HOuWII/VXTG7V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oBHkxaTDqgyEaEkcHBqN3Y6xRiMd9Wq+GoXoU6JyYud4QO1cZtiTa0BADP96iUcYn
	 +IyIPmRBnFtVHXwcV6ZYTrdpeXsxabHfv7O6MqylVop25/34EnXCxdkuwHQQmSfuFZ
	 r5FxPaysWP7OiswYYwaom06SQelQ3Ciwhlc2maBgR0QnLLODvTC4fWNQ8FCqB8i5zN
	 l6uUQJHInaZuOBEy1QuDgjRa6ggohOe5HMKIIcgdWYos6HF89qSZgsGNpCzt4TJvrY
	 sV8tEQjZa3NwM2poPEWIqbCzFaNZ0Vh5HMA1MZTkspl9op2IhoQPDgbH1HYWvBkVpE
	 wt55PQsUp1Zww==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 292E86088C;
	Wed,  6 Aug 2025 18:37:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754498241;
	bh=mhS3rihhT+N+n/1EHlUoCtf0PDno6HOuWII/VXTG7V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oBHkxaTDqgyEaEkcHBqN3Y6xRiMd9Wq+GoXoU6JyYud4QO1cZtiTa0BADP96iUcYn
	 +IyIPmRBnFtVHXwcV6ZYTrdpeXsxabHfv7O6MqylVop25/34EnXCxdkuwHQQmSfuFZ
	 r5FxPaysWP7OiswYYwaom06SQelQ3Ciwhlc2maBgR0QnLLODvTC4fWNQ8FCqB8i5zN
	 l6uUQJHInaZuOBEy1QuDgjRa6ggohOe5HMKIIcgdWYos6HF89qSZgsGNpCzt4TJvrY
	 sV8tEQjZa3NwM2poPEWIqbCzFaNZ0Vh5HMA1MZTkspl9op2IhoQPDgbH1HYWvBkVpE
	 wt55PQsUp1Zww==
Date: Wed, 6 Aug 2025 18:37:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Subject: Re: [ANNOUNCE] nftables 1.1.4 release
Message-ID: <aJOEvpa5rZfEURBm@calendula>
References: <aJNHt1OW7w6SBmsv@calendula>
 <7np103p3-6822-3149-q69p-o06n1006pn29@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7np103p3-6822-3149-q69p-o06n1006pn29@vanv.qr>

On Wed, Aug 06, 2025 at 05:50:02PM +0200, Jan Engelhardt wrote:
> On Wednesday 2025-08-06 14:16, Pablo Neira Ayuso wrote:
> >
> >        nftables 1.1.4
> 
> https://lore.kernel.org/netfilter-devel/20250417145055.2700920-1-jengelh@inai.de/
> is still unmerged; if that could be caught up on that would be nice.

Oh well, apologies, let me catch up on this so we can get it in in the
next version.
