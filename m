Received: from pv50p00im-zteg10021401.me.com (pv50p00im-zteg10021401.me.com [17.58.6.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A870D271
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 19:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.58.6.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715889025; cv=none; b=qJQp+JXTYq/qdd0j4hPBUYfWpCxTkK1CSNLyEdaBj+6h2jXUVzCOmVRvZG9/owHNNp7Ka8vNO8r6OqH0DC8c2xI//0VFtV6e6DktGrcuTx6DTQMdwH7wbTgXUo85YhoRJ9H7Qj/kRpxS10Lqlk6cxCRnndT9NShMKvWzBvx8pYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715889025; c=relaxed/simple;
	bh=NZ5u3mkPSYCIB7YBtOwOV3xXl6e4mwnns1nlKKCgUb4=;
	h=Content-Type:From:Mime-Version:Subject:Message-Id:Date:To; b=P7h0SDqf2AXLTx5ShRZOAO4sDal7XbPi+KhexnbDMaX+iPv5oqxjL4oa6xnyAvIKdgPZixPCjByNVTj1WmVzbibNPhPAALdud3Ll6Hq4FoxrDfcQ69KVxga1MnYLLGNd4yJ3sxEJkUue99FGMoon+VlqwCY51fdJ4EYqmJ/B5T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=GVLa1Sww; arc=none smtp.client-ip=17.58.6.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="GVLa1Sww"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; t=1715889024;
	bh=NZ5u3mkPSYCIB7YBtOwOV3xXl6e4mwnns1nlKKCgUb4=;
	h=Content-Type:From:Mime-Version:Subject:Message-Id:Date:To;
	b=GVLa1SwwIdIgcQhKYO04QiRRNZMdztd52yx6TOhH6XIdusuJ1MhnM4xi5UOCRKa/t
	 nYN/KtpagSOUOOSHhsQzV/KaTS1WK3wJ4QU6aTr93/ryyKrfH7JTgzoyX10m1E4TOB
	 ZswdM+polb0yGAasY0uEyHwJPlyS1uR5TmnjRaf3WNC/slP2neYi43h3mD5BRdhR4T
	 sO1HnyxGpwCZkZwVgzuMjcl4KkpyX2GRB14Mh0qMhj/lR6ll7pJHw7D7abNjH90uyy
	 A89TYyaCz47qg6STCQAxicdl/AvJp8HTugkG3/WLNuVhbXcdKB/NloRr7TT6gDiQCs
	 gi/Qt7SVZnk3g==
Received: from smtpclient.apple (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
	by pv50p00im-zteg10021401.me.com (Postfix) with ESMTPSA id 767B48E02F3
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 19:50:22 +0000 (UTC)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Byron Mugabi <byronmugabi@icloud.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: tcpwrite question 
Message-Id: <F26CB5CC-6C4B-42FF-810C-8AA499265664@icloud.com>
Date: Thu, 16 May 2024 15:49:49 -0400
To: netfilter-devel@vger.kernel.org
X-Mailer: iPhone Mail (21E236)
X-Proofpoint-GUID: kbY2AgE_ol_Ve1tsnEvgT2PTEVASOAZe
X-Proofpoint-ORIG-GUID: kbY2AgE_ol_Ve1tsnEvgT2PTEVASOAZe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=606 phishscore=0 malwarescore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2308100000 definitions=main-2405160143

=EF=BB=BFHello there,

I am playing with ebtable=E2=80=99s but can=E2=80=99t seem to see traffic re=
played by tcpreplay. Does tcpreplay traffic skip ebtable rules ?

Thanks,
Byron=
