Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2312753EE
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2025 04:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739506653; cv=none; b=njfjQmrkvxiUOF4Tk8C9UNinG6zgsU6fXG/fMo9Mp6n2XyjPBX3OFEE455/OWzAd4ipaYjh+fImsU81Y0ydbmFM/uf7iAd3J7lyGgqjCgpIq4TFUtqS5zdb+q7K7QfExBCoi6VxBM/9EaKHMsbrTPyJmqYqzflafjtIu5gdNcHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739506653; c=relaxed/simple;
	bh=J/s/TlGp10KYRXQvur1xxIZLHlCHKLKYp1vSns4wLXg=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=m8tc2lHGVWZ5BjtRJSUu8AbcWkn+2kZPstDSF2yEaNGF8EWEGF8f8nFUWrL1q7m58Ny+t0wSVQFcHhl2tGM5ERKIMyRokjJ8FRvMPDqBps6aE0jwmLIkZvD90U5TS3mDGLIDAP2uxgv0jr/pD1XlqN0qhhBPYvENAZHSptncVVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=PMdqY3ux; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="PMdqY3ux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1739506643; x=1739765843;
	bh=ZjCUwKx7Uu7xXrZokZqFanT7dXy7uONV2ZmGXtHbLBM=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=PMdqY3ux/KJNJADids+smt2cCPhT1WFpluINc6Heu/HUGdeKnhcBQzXHfP2QcstNY
	 sho4Vfm83nRo7nYlqR2RLArlFxvx6LMn1f2Uw1y71r7Nku2lKS/o8KqTjSPmop42OK
	 eBy9SuV3NARMNGbxWCGMrXlU/uR4xzX5Sq6pXFzBKxRQR8bzmUy7aOS0D1nygi1ZZt
	 M8t/PBxFjYsFgQCIFxmdZ4ACbtRupyjOhPxxiY5tSem979L+aWqprRpwFgtHHIF5hC
	 S63G1nCvYz36zObaW8chPf9ltxvxgVc0dE3MuxGI/MmQGUOuMISwXq3J3mWw3oOVdT
	 +LaGbC1DQQWEg==
Date: Fri, 14 Feb 2025 04:17:17 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: payload expressions, netlink debug output
Message-ID: <iUf9BfY67Kl_ry63O6gOxJ2YHKmO-OFslzCRzfWVOxIe15iVlUV2G07XiT0qu5bsF9vvyrDRT4TQODjt2ksTfpiv1-nYlhgG5ryzcidhdug=@protonmail.com>
Feedback-ID: 13811339:user:proton
X-Pm-Message-ID: 227f44252dc5dcd27660e8e4aaf120120748777f
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

It appears that the incorrect register is accepted when data is modified.

Running Debian 12.9.

/etc/nftables.conf:

#!/usr/sbin/nft -f
flush ruleset
table inet filter {
 chain output {
  type filter hook output priority filter;

  @ih,0,128 set 0 \
  accept;
 }
}

output (viewable with /usr/sbin/nft -d all -f /etc/nftables.conf):

[ immediate reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
[ payload write reg 1 =3D> 16b @ inner header + 0 csum_type 0 csum_off 0 cs=
um_flags 0x1 ]
[ immediate reg 0 accept ]

If reg 1 was modified, I believe it should be reg 1 that is accepted.

Please, may somebody with more experience check my assumption?

sunny
