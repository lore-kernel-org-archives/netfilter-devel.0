Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=98.129.92.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590159;
	b=dWPGD2xBvN9cRYO8yxw/U6yfTdl7eypD91qKfP8VPnlSHiqI56wb0JwPbHEPAN/B0249
	 c3XcGdPUnvmor2lLpvm47hl1FNYxECARo4DeUQtyYg0LgAsPekI4+YelsSNKQo72mFAaB
	 g9lgIGeAzo9qXr17So6DnnVJGvZaVvmigWYwPCNLMM8Dnm/1wG05H6aPbD+5H19mudBUV
	 CxYLvSEqfc/QE3pcUxX+wBxVRrIllX+NWLlj4TZArCtneSUePGnodUqD59zSqf3T9e/Vy
	 rXHem0WMiaYL2Cg/C6LTN6zYXaWr6euznPB1rgnmWP8QkW35Hgdpb93FDuA8iCn1klA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590159;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Virus-Scanned:
	 X-Virus-Status;
	bh=3Im8EeV8jfHPhu3EVgsbILzJDwxRLVIAMwLlejct7Yc=;
	b=aPInz0gBvFYWcC0Ov0xI0UJ3PxjFmVJTtZxHmxy3w6TjPKIuOt1t+Ed2OtBkWEDkjPWB
	 8dtUdh17yuRXFvudwnQv1aSNotWejS3Tzegqh/rE+tALM2n+uidjedjyB/QooTKrDdhYp
	 im4/2p5uRC6JA0unaljPwoJrL8tFXHzEVaHuESTGF+s2fR0jfBPJveEzXJqUxR43rJIZx
	 4at1teMuGQt1gCL1h7Gv/9FtpSDSlGOV4WYjWcapktvOaMGYwSrGGHbR6/8VDgQTrp7IP
	 I4OOae5tuyZWJNInJxtuDfPlVd4pT8tSd94ivBM+J3MXrRUO5VcheXB/CzAYqpHrZBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tecnopolis.ca;
	spf=pass smtp.mailfrom=tecnopolis.ca;
	dkim=pass header.d=tecnopolis.ca header.i=@tecnopolis.ca header.a=rsa-sha256 header.s=mailfwdk1 header.b=E3gsFeSF;
	arc=none smtp.remote-ip=98.129.92.4
Received: from ewordofmouth.com (mail.ewordofmouth.com [98.129.92.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3D60A2623
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 13:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0C3D60A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tecnopolis.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tecnopolis.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tecnopolis.ca header.i=@tecnopolis.ca header.a=rsa-sha256 header.s=mailfwdk1 header.b=E3gsFeSF
Received: from tecnopolis.ca (S01067085c2fe8a16.wp.shawcable.net [24.78.148.126])
	(authenticated bits=0)
	by ewordofmouth.com (8.16.1/8.16.1) with ESMTPSA id 69LDgPHI4190125
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 08:42:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tecnopolis.ca;
	s=mailfwdk1; t=1792590146;
	bh=3Im8EeV8jfHPhu3EVgsbILzJDwxRLVIAMwLlejct7Yc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=E3gsFeSF/Hz1aSmgi4ErN2kh3yIy63IfeKgXF+Q86kn09X+x5BcAy6yhPM+GDT9YN
	 1sn4Nt2Oohy1BmuJclzTxBmV4Zpg7XNgjdtb4qVn2Z09ABlSaRRuh/nZbQX+du4vrX
	 zjv+bgQt3H72PkSXuMXyTNokx9UwdP7+vcqAOzuI=
Received: from pog.tecnopolis.ca (pog.tecnopolis.ca [192.168.100.1])
	by tecnopolis.ca (8.18.1/8.18.1) with ESMTP id 69LDgPb4274315;
	Wed, 21 Oct 2026 08:42:25 -0500
Date: Wed, 21 Oct 2026 08:42:24 -0500
From: Trevor Cordes <netfilter@tecnopolis.ca>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: expose named set element count
Message-ID: <20261021084224.5c03b6f7@pog.tecnopolis.ca>
In-Reply-To: <ateYUFIPFZshosqX@chamomile>
References: <atdp-FBVOOKgN0De@pog.tecnopolis.ca>
	<ateYUFIPFZshosqX@chamomile>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.4.6 at pog.tecnopolis.ca
X-Virus-Status: Clean

On 2026-10-20 Pablo Neira Ayuso wrote:
> On Tue, Oct 20, 2026 at 08:17:44AM -0500, Trevor Cordes wrote:
> > Hi!  I have an application that can create very large named sets
> > (dynamically) of IPs.  For monitoring and testing purposes it is
> > useful to get a count of elements currently in a set.
> > 
> > Currently I an running "nft list table inet mytable |wc".  But once
> > the ip set grows to much over 100k IPs, that command can take
> > around 90 minutes on my system!  During that time the nft command
> > takes 98% CPU.  That makes monitoring in this manner nearly
> > impossible.
>
> There is a count field in more recent userspace nft and kernels, what
> nft and kernel versions are you running?

Thanks for the quick response (and I got subscribed, yay).  That's
great news that the feature may already be there.

kernel 6.12.101 and nftables 1.1.3

Unfortunately we're stuck on slower-moving Debian 13 for this
production box, and from your version list it appears we may be too far
behind.

Unfortunately, I cannot easily
nft list ruleset
because that takes 90+ mins to run.  I could try overnight again.  I
don't recall seeing a "# count X" part to the output before, so I'm
guessing I'm too many versions behind?

The main thing though is that I can get that same size 10 # count 1
output WITHOUT running the full "ruleset", or even a subset -- it would
absolutely require a command I can run that *omits* the actual
elements.  Can the latest version do that?  If I run anything that
lists the 100's of k's of elements, the nft list command shows me
nothing for 90+ mins then dumps it all at once.

I am perfectly fine with waiting until Deb 14 or a newer 13 to get this
feature that might already be there.  My main concern is that I can
expect it sometime in the future, so I can turn my frown upside down.

Thanks!
