Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F6F12BE90
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716557103; cv=none; b=tHa8ajmvEV02tl3HBn5HGNkdY2OQKta7QIx3ftL6oDH37/vQqyDnF+M1geoA1UPPntjtPSt88YagTH70PhjsjcLz5CvYeqJDQNcko+x9fregmz/tUpn0X2LannMCcnhjeZjKhFzWy14YrKHHldDZz7n5MqOw25YsmpjHPjAO9ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716557103; c=relaxed/simple;
	bh=79sunbzm+Lo4pL5mmumuGym2gafehJEo7srBCwODDVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PnT8NX6R+gDw0oPeFyj+g9cgxNGigQdFv+7tOxGeE186ToUDBNNKkRIf5fwWzJclAw83rVTqbugJ4p6lqXbdtgYtcedeV+cEyMdyV5sK+paYy+AGnpW5pR+CfW48Do74VObk9nnTU6Bdx9LDr/X8/ZDpJAZ9xNNfM0pMHQjZ9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b=fwpcNzcR; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b="fwpcNzcR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716557097; x=1717161897; i=michaelestner@web.de;
	bh=79sunbzm+Lo4pL5mmumuGym2gafehJEo7srBCwODDVY=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-Id:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fwpcNzcRStbO3X+wk4UPOBrIkWxeANfBrY6dgSDPYCYn5QU11QKr64MdZB/Q5hIK
	 e7bQSqpfnp1oq44tDoQmMEkHGqRjlnUuqyeK5zWd/pgdNcLiqZMBhdMVFdUM4pu9i
	 dbblX2KEpjs61hfj5ni8mAJhUW/bZ/cciQ2ZbQ+I/IH74SPpdU35zqeZx9nwyIIeM
	 nfQG5rJ6ZB9Bq2zJieEi8p7goh8X6z1hztudMuRJYARoXZj6JjGs4IS71rpwOJct6
	 ZiJ6hKWN153FP4eVtvvzTcmOs2SzHHs627okubZmUZVa9g5FIkEM5P8nK7ZWU7SbU
	 amC2G2GM0HuxSDRspw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from del01453.ebgroup.elektrobit.com ([130.41.201.208]) by
 smtp.web.de (mrweb106 [213.165.67.124]) with ESMTPSA (Nemesis) id
 1N7gbY-1sWzuN0tjm-014n9n; Fri, 24 May 2024 15:24:57 +0200
From: Michael Estner <michaelestner@web.de>
To: phil@nwl.cc
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH] iptables: cleanup FIXME 
Date: Fri, 24 May 2024 15:24:51 +0200
Message-Id: <20240524132452.84195-1-michaelestner@web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Zk9yrd8Ji1xAcblw>
References: <Zk9yrd8Ji1xAcblw>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fn2aaqEaLhJ6eYTeayU0qgQGFcI5s77hR0nCi2zFbneAMEu2LeH
 i+Qs6/wHpGDN1qUN2SLVlGiFjMZDuS4ybIOVsTRe5djMFr57Ie8fPv3i21KNiiQLsgp/vH3
 2/cKS0ven4LjtxlU4uVy5M+yTSfHEhjzl1/WR4ZPJLqjoP09XTBsRM8L8aJcByaRzV+K4XH
 5e6mMcQGSQ5eDYtFkQqBQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tP1DKRPAobw=;F43LdgV1BE6rgd4WN0It3CdtANc
 Xfc6QKr5Nx3Lq4rBKHoKTZi9QEMV+Q9+4fY+QTKRnmNwSiF34m1uWZ/VhT6qVDy4L90aQkMfl
 cPFJNQH+F3Gx7uzqW9kFq2sAy2zgyqlxazVk4s+zcmXtPufs+drwITX4wH8kaN1GO+QtXAUYZ
 mZO+5/hptxB3IgP1bV60rAzEdaX8/N94kPDQJdWZLW5GQXzR4CnaWcgmjwa3DtlRWzfHKSU8q
 zbK7KKY30//HBjkImhLWFKXLbCPyy6bcEL6NkzIvkDo0wFMk4YPsYGajRWPSa3Wtk+68+cl8W
 lc/vxAAHDeL8CQMI8ibYCyhcESD2qupoSFCHW2BKfkUdM3zwvtQOT9Psmufq19tf1G9j15mb7
 pcXvJmQZDv1tgBVgcVMa81v0mpar9LkCkKsnJbEIKRSgv3a8PO5wSoyCBufubwJDHxAlLL7WW
 IHiku0saJGsNH6z+gs22xexipHqHgqbADnoZKWwlb7ZpAFJ2BlkTeBXx4yhwqwLZHYoVwE9VZ
 6SgSCjPpuqqlWiLdd5hY9XWAiAx3MsIdx1LXusOoO8+3zpj4EhHWSv41nbST2poXC1CqdsNWb
 0norODejuU9q/I5ZpRGmqt+e8jW5RPDbsDk638rLlHdpo3cuSHlRrm0V1Lh2CqgNnbFYTMI4Z
 GOLWXM3M83HtFPCpok/BStYUyAHxLLgBCvuNMGQM26vTa2YNoD8c6iQrVhk1Ei/SnnlkTQxXK
 VDPc1eREJx2If8jPazs2AhW/pbfTWWK11xsa5/8kkOoSsPCPwO4cvrHG2Ylfp+ARVbV98Y/GP
 sxZdeRqhHJw+iYp0dt2McyJpgDes/4nytt9Eztv8k6xrQ=

I checked bitmask in the ebt_entry struct in iptables/xshared.h
Should be compared here since bitmask needs to be the first
field in the struct ebt_entry.

