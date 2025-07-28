Received: from outbound.mr.icloud.com (p-west2-cluster5-host11-snip4-7.eps.apple.com [57.103.71.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E4026AE4
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 23:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.71.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753745127; cv=none; b=AZ0iQqCmGE4s1JD5gh5tZzjIt/UO19FMQ7Vr1/MvHYQ5xo335NffDQeGoqVMg0NCK6cRsP1afjWCTXzY2sXNG3cIji4SEvU4Qi2Wp/rpndEewBhsECLJ99Z0flOeVbNwStoibPHTDA3ONsH85irLMhRpUqi5giA1nxLW4Pvmmsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753745127; c=relaxed/simple;
	bh=k139K79Szi58NCVPHLA2iDI2q7B9C0lVbL35XSmCNGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Djou7VadfoLAS+zuAFQIN+gaS6iReZubmM+q91YQTHPbp1cnm7QFWVenfy/DeJ20JX2DJRPyhcvFQkYXkq4UQuENlQZzUysiAUQ0GHweyVf0ZW8pFEPlA37cH/Al0dYyk1qtSluEuSatlO1RFZJAH1qgM2+zzVjKXE8D4qPDPds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=frJDI33I; arc=none smtp.client-ip=57.103.71.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="frJDI33I"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-1 (Postfix) with ESMTPS id CA2CE18005A8;
	Mon, 28 Jul 2025 23:25:22 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=k139K79Szi58NCVPHLA2iDI2q7B9C0lVbL35XSmCNGQ=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=frJDI33IJqUqS8UYW/Iz8QeUufQj5wcLNGFNRj+iuT10Z1Z8jYZIj8BZfMn8xlzFO/OXWOslOdoOUOfPbcu5FqWqVxEBbJzeGEItVU6iOk8hXiZBM0UlquOWA3n2MR3EYqEGU+0gQR3Xx/JxZ+NoQZmluJPfbMgHy6/e0XiWi6xdsrmqDnzsky+qFofz/Af8skvKkxyrfNtGKhV9m3PR5TyKh+uZN5V6rT0+1z3ghETrsyMb+/6xSWzESWiC9zy2+WA8NsdTLB5YyZxYawHnl4PP+SvJS6HGC2BAFz2vGzdrpldLgImsRuK2o7o/mrJskbR6kTThVmWT2q6QT+tGzA==
X-Client-IP: 67.163.93.242
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-1 (Postfix) with ESMTPSA id BDD1C180028B;
	Mon, 28 Jul 2025 23:25:21 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org,
	dan@danm.net,
	regressions@lists.linux.dev
Subject: [REGRESSION] v6.16 system hangs (bisected to nf_conntrack fix)
Date: Mon, 28 Jul 2025 17:25:06 -0600
Message-ID: <20250728232506.7170-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: EEomygTu7PzHn_HNe-t--f-h9DEbhH69
X-Proofpoint-ORIG-GUID: EEomygTu7PzHn_HNe-t--f-h9DEbhH69
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDE3NSBTYWx0ZWRfX6BiReqo1Kd79
 9kKMUss6n2qzUiPM5BVMkOkH+0b3jQkC/PXrB2SVELr2fYVLztch6IQalZW+VSyGRpeXAfMmhk1
 DAOLg7BP6H2g8PRIQa8e/X/iSaub4BDCZEa9bwL9saNBfd15wcg9IG2QP9MnOgcYVZcs5YFgFxL
 MCPO4A7kKRQAZCrXUy/SjWUogQeEDTzaDsQVfOlIs7zDuKvNVrT0L4k0ay74+i1EJCfSjqDXEkk
 xEfvlFSpGcmX+FxiJaNVk8OiK+4iKIpmWgD9CLd1n78wcdq0clzMnlevpuVd6NgkZjuzXFmAw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_04,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0
 clxscore=1030 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2507280175

Hello netfilter folks,

Since v6.16-rc7 I've been hitting a vexing system hang (no kernel
panic is being produced that I can see). I did not have this problem
when running rc6. I first noticed it the morning after upgrading to
rc7. I found the machine unresponsive. Checking logs after restarting
it, I could see it had been in the middle of being backed up by an
rsync-based backup system. This same sequence repeated the following
day.

Then I also started experiencing the hang when running a build on a
proprietary codebase that I work on. The machine that is hanging is a
virtual machine host, with a fleet of VMs that I use for doing various
development tasks. One of those VMs is where I build the proprietary
system. I do that by SSHing to the VM from the host and invoking the
build from there. The strange thing is that at the point the hang
occurs, there's nothing overtly "networky" that the build system is
doing. It's just compressing and creating a self-extracting archive on
the build VM. But it happens with 100% consistency which allowed me to
bisect it down to commit 2d72afb34065 (netfilter: nf_conntrack: fix
crash due to removal of uninitialised entry).

The hang is still present on the final v6.16 just released
yesterday. I have confirmed that if I revert the above commit on top
of v6.16, I can no longer reproduce the problem.

I know this doesn't provide a lot detail about the cause of the
problem, but the nature of the hang prevents me from being able to
check logs since the whole system becomes unresponsive. Any ideas on
next steps I might be able to take to gather more information, if
needed, are welcome.

Cheers,

-- Dan

#regzbot introduced: 2d72afb34065
