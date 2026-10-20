Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=98.129.92.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502266;
	b=Oyr8s/iKg1Sihbdpb4amWVvo4WCaFnMzVv753CDTC65ypxQguPrLjwK0AxlJdW5EtE72
	 cyUf5mUzhM3JJdO+E6IWFp2HeSoV2t6LL0BpkIeZBUgghKYg57f9I26VYOgRr+3uwWoKo
	 qW4kWQ47KR/Bsn3zlbG+NNLb0u3ccXPRstRNlFtlGOAVX+0dqDU2UyNcGyhFWuOZS6y3v
	 XDqqudRaHGIFaU6Q53lU8DF+Ljnzdin5NCFUHmYCfTFuX80WmLCRsPmzlvlVcoawATrci
	 JOq1p7XxHUFK+LNGbPS1Q0rUhqk4SoulCIWm/iC34GVDu8z9NAr1Dskt2cJU/vxkC+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502266;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Virus-Scanned:X-Virus-Status;
	bh=4BDhp9SIqgxJ8CTTS5ngVopqA8SKhM6XdKuEb4011qg=;
	b=h/smDr/lFKo9fpw92AmKeW3d76uF7sjMVBjBgec3Cft+QuROYwzCSUQOodQMWMznwEPD
	 Hc712F9LdOW5I0M5gQesLtwl1S+zLfGmIjJM8DrC8aIlyhyLdEqcpZ+QXICXD91Szg5V7
	 GH9xh7n7KLgfRCd+0B/TBDSCb6f41ZRMfp+hAdLTX1xg5LrfLsrc+9SaJKNv5WY5dujUm
	 oPUJBH7+L0UUOKJ7whv4XN4oYvpl3IItCN+li6RWHcvCLeHFcqrbYOFzQkbbz0qYBc2fG
	 PixtKDAylPhSAVEfNtw+4Cva6qjlEVsaWVgxhPc62GQD4anw8EgK/r6B40//ci/5O2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tecnopolis.ca;
	spf=pass smtp.mailfrom=tecnopolis.ca;
	dkim=pass header.d=tecnopolis.ca header.i=@tecnopolis.ca header.a=rsa-sha256 header.s=mailfwdk1 header.b=aqdj8bHZ;
	arc=none smtp.remote-ip=98.129.92.4
Received: from ewordofmouth.com (mail.ewordofmouth.com [98.129.92.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B5E606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 13:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19B5E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tecnopolis.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tecnopolis.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tecnopolis.ca header.i=@tecnopolis.ca header.a=rsa-sha256 header.s=mailfwdk1 header.b=aqdj8bHZ
Received: from tecnopolis.ca (S01067085c2fe8a16.wp.shawcable.net [24.78.148.126])
	(authenticated bits=0)
	by ewordofmouth.com (8.16.1/8.16.1) with ESMTPSA id 69KDHiUm2622652
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 08:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tecnopolis.ca;
	s=mailfwdk1; t=1792502265;
	bh=4BDhp9SIqgxJ8CTTS5ngVopqA8SKhM6XdKuEb4011qg=;
	h=Date:From:To:Subject;
	b=aqdj8bHZatyiBwuUpgb4bIX96tZZjuEk5+LnmpXd5jPJz3IttAz2wF/dvOo1/Gl0l
	 RYVp+sMzCEIJSEUtDFOb3aMKdSTGeuhfyVPgvMv2NtX3qSTn/wTww9qLgM2RIvHEhA
	 6aI87D46inAZ9s3NAQ2ia3txupy0Bl/4PpWKrHL4=
Received: from pog.tecnopolis.ca (localhost.localdomain [127.0.0.1])
	by tecnopolis.ca (8.18.1/8.18.1) with ESMTP id 69KDHigB4089950
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 08:17:44 -0500
Received: (from trevor@localhost)
	by pog.tecnopolis.ca (8.18.1/8.18.1/Submit) id 69KDHi8P4089949
	for netfilter-devel@vger.kernel.org; Tue, 20 Oct 2026 08:17:44 -0500
Date: Tue, 20 Oct 2026 08:17:44 -0500
From: Trevor Cordes <netfilter@tecnopolis.ca>
To: netfilter-devel@vger.kernel.org
Subject: expose named set element count
Message-ID: <atdp-FBVOOKgN0De@pog.tecnopolis.ca>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Virus-Scanned: clamav-milter 1.4.6 at pog.tecnopolis.ca
X-Virus-Status: Clean

Hi!  I have an application that can create very large named sets
(dynamically) of IPs.  For monitoring and testing purposes it is useful to
get a count of elements currently in a set.

Currently I an running "nft list table inet mytable |wc".  But once the ip
set grows to much over 100k IPs, that command can take around 90 minutes
on my system!  During that time the nft command takes 98% CPU.  That makes
monitoring in this manner nearly impossible.

I think the in-kernel code tracks the current number of elements.  Can we
expose this through the Netlink interface so users can get an instant
count of elements with virtually 0 CPU usage?  (Note, I'm not talking the
"size" data point, I'm talking the actual IPs currently in the set.)

Less importantly, I'm wondering what is making nft take so long to list
these huge sets.  Maybe the IP numeric sorting and formatting?  If it's
all the sorting, maybe an nft option to disable sorting would help?  Or an
option to disable formatting and have nft just dump the whole wad of IPs
on one line per set?

Thanks so much.  Please CC: my on replies because I'm not sure my
subscribe request is working or going anywhere.  The listserv may not like
my mail smarthost.
