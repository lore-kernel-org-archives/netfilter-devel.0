Received: from mail.jubileegroup.co.uk (host-83-67-166-33.static.as9105.net [83.67.166.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C4D22FACA
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.67.166.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630050; cv=none; b=uzdqmhSyFl9HK8idaLNnmtLcvzsftMTfb5jorkcDUPiInlA4aKT13Q0iVEy/FfCPbsbUI6dOeQhWGscnNfmALIVAdBIqDifbvBZoFHd+B9X2brOMI1cOYtKfRT37e3qWkY11yMHv8RIrL8fksK/ocfkplIfbkrMGNuOBci174kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630050; c=relaxed/simple;
	bh=1N9b0bIYhtbwqmyQcSXlP4tE1DvzYbPpKounknF/7es=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=blOrWLqqmp7GF5dAW1+DePhn9iiyynOGiZHnOyrNJ5Ea/2rhfEaCGxWD3FwYpNnce2zEWJPdjPdxvoOq6pKpO/7QXsVd+OEJPb6efnErwz4PxMb/LNGBrsRtBSHMCKWf/JAogZKVGM0dTxWfamPASS4vuDPIQhU9dL5FNUfWCF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk; spf=pass smtp.mailfrom=jubileegroup.co.uk; dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b=BWprXwE1; arc=none smtp.client-ip=83.67.166.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jubileegroup.co.uk header.i=@jubileegroup.co.uk header.b="BWprXwE1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	jubileegroup.co.uk; h=date:from:to:cc:subject:in-reply-to
	:message-id:references:mime-version:content-type; s=uk; bh=cNVUc
	hhObGwsAsFNoUPKHTQ0fe0q7DGDXX3LAEciBxE=; b=BWprXwE1kDLR2sCer8G+v
	+tQspLRVzcfO/GrrtTwYfvS7ABuCdHnHU/nuKltt8fHTRKP5IfnrRx/x+idRboMc
	ardigshIkDU7SKvxE8B/SrLFyzFWjhrYxkhBd9Ug4i670xED5ZAYky/PHF+XY974
	ccSg6ATCi82IQIEO/aPaR/e3uqymg60Ze1E+koRs2Sc7i9vwf0QdBMBctciQ5Nki
	4VH0Kmc+6RVJg6RuCy3Wu9/dI4LUuzpeBavkZf2N8/tO58UCR5EJvADatUv4kVV+
	FYjT5Bpx8ujeqTnB4RSUyQwkZvXptdT9SpxXhj01ep1IIPff/GkAaniQPKJNOEP8
	Q==
Received: from piplus.local.jubileegroup.co.uk (piplus.local.jubileegroup.co.uk [192.168.44.5])
	by mail6.jubileegroup.co.uk (8.16.0.48/8.15.2/Debian-14~deb10u1) with ESMTPS id 52AI0eYZ010865
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Mar 2025 18:00:50 GMT
Date: Mon, 10 Mar 2025 18:00:40 +0000 (GMT)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
cc: netfilter-devel@vger.kernel.org
Subject: Re: Documentation oddity.
In-Reply-To: <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu>
Message-ID: <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk> <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-AS-Number: AS0 ([] [--] [192.168.44.5])
X-Greylist-Delay: WHITELISTED Local IP, transport not delayed by extensible-milter-7.178s

Hi there,

Another one for you.

In the docs at

https://www.netfilter.org/projects/libnetfilter_queue/doxygen/html/

there is given a command to compile the sample code in nf-queue.c.

The command given is

gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c

Here, and I suspect almost everywhere else, that doesn't work.

Should the command not be something more like the one below?

gcc -o nf-queue nf-queue.c -g3 -ggdb -Wall -lmnl -lnetfilter_queue

-- 

73,
Ged.
