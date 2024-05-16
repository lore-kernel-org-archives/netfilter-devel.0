Received: from qs51p00im-qukt01072501.me.com (qs51p00im-qukt01072501.me.com [17.57.155.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14CB14B95D
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.57.155.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715889562; cv=none; b=BrxSwsiJ4IWuir/dgDAhyiwIl4+/15yq3rB9dDrcKpD/yXgNOt/pdnbzinxIsED0M/oij4WJ313dNeqaGrD8rnZWLXmeYLuo96fWzyCIT30+eeT1xpG2uRaQTgWwx0+yy4kMcNA+id5Xsvj2eH17eSdm5Ym4vlDLmjefUpZNeu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715889562; c=relaxed/simple;
	bh=NZ5u3mkPSYCIB7YBtOwOV3xXl6e4mwnns1nlKKCgUb4=;
	h=Content-Type:From:Mime-Version:Subject:Message-Id:Date:To; b=NVSQjNNnO2rauraa9hRRgJwckmdDXYjgUa+ggYkmWY6st72YfJTQRF/fqNiDr4UCyDYq5/6cBOp720DNWmJGk4e3PRtc+TRGg4lJnS73eXI4HOrqPrCYU6UbZQzXhTTXOyqIeorZs5FhkxCd7pTn9B0EGgw2UMzmz6w1RyKKefk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=sj+yRuNp; arc=none smtp.client-ip=17.57.155.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="sj+yRuNp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; t=1715889559;
	bh=NZ5u3mkPSYCIB7YBtOwOV3xXl6e4mwnns1nlKKCgUb4=;
	h=Content-Type:From:Mime-Version:Subject:Message-Id:Date:To;
	b=sj+yRuNp+xZ4as/KJ8iAcbh30i3/yOhOwa4zp6gB4vGskJJPYTllPfE67KFn6Z0/5
	 yZIyuVmKv4Qo3YJejqesjLQZiizdDdvTa6/M3AKfA5OONFxyp913iubxRGBdrM0gZy
	 S7AEcZpYhIDCiFBxfsV4ApAC0SZLLhjWeCgb8LRrDCqUwJAHP5P6RyfOD9aoWmPBNR
	 D0GGu/fTXgz3KWj7o5311+cjm51b8BSPZ3MuOU8JWXK+h61neAPT0nBQObR8laAai9
	 TmOUUiX5e/leqhUeJhWKU+d6S3vkgZYFNczaD/y/bKSNOzTi/ROcxhlxybb4W2Ru9P
	 DzRh2oGwlOtJg==
Received: from smtpclient.apple (qs51p00im-dlb-asmtp-mailmevip.me.com [17.57.155.28])
	by qs51p00im-qukt01072501.me.com (Postfix) with ESMTPSA id 2814F44033D
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 19:59:19 +0000 (UTC)
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
Message-Id: <04B6238A-8A85-4F3A-B77F-012B6609DB77@icloud.com>
Date: Thu, 16 May 2024 15:58:46 -0400
To: netfilter-devel@vger.kernel.org
X-Mailer: iPhone Mail (21E236)
X-Proofpoint-GUID: mCSTVS_uq5dA3whdAd7HwpnKMq9ycAtJ
X-Proofpoint-ORIG-GUID: mCSTVS_uq5dA3whdAd7HwpnKMq9ycAtJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=606 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2308100000 definitions=main-2405160145

=EF=BB=BFHello there,

I am playing with ebtable=E2=80=99s but can=E2=80=99t seem to see traffic re=
played by tcpreplay. Does tcpreplay traffic skip ebtable rules ?

Thanks,
Byron=
