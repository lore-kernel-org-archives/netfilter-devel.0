Received: from outbound.mr.icloud.com (p-west2-cluster4-host6-snip4-7.eps.apple.com [57.103.69.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3D615533F
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.69.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753991356; cv=none; b=AAqKEeleYdwpvTk+udHkkGWVwG4TIHjUJzlqiIIhK+z/vepZikYn4fzK7Aad0szHZwl3rgNTXW1TgQcQ64ctHcgNcN6/5+3/7CjfD1qLegOFEpOobgep81KgE+ZFMZQ7rt6vDAbcWLnaE8fHOClsPE3bIsy5JsYYcxlo6XuXHbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753991356; c=relaxed/simple;
	bh=tJMph7PAoCnXOQFzLumOR0FdUhAx7STtwzBiRyel7f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhJD2/UN25bRZN5wD/RjeaWCpLQZKU1E3BNLz6Hw8VgSL8c5bWR1obmm045SnQIbm6QxWvOFHSY9J/VDrxLD15atlFVa4vg8JJ41afwX30kG7Hjwe7MQ1/gvahZHDuRYkbiygeYa0NJMxsqSMao4Ra49/fM7DnPyZel8/hoWUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=Gv1uE6Oy; arc=none smtp.client-ip=57.103.69.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="Gv1uE6Oy"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-4 (Postfix) with ESMTPS id 93F3E18003C3;
	Thu, 31 Jul 2025 19:49:13 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=j8qFmNxfJpVDpOyrf256QjlAte6ll+Kx/fbnfWATlsE=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Gv1uE6OyFqtcCi336qDohjS3SFKJoIj9smJGAUgBN27GeFz6SsCco5tXX/eKGq+nsJfWgS/ODgqqSSIS97y0fnOC10/uvMUvO7HEHHwqCUXDaGY0o0DZWZslh9NIP/JkwB5Aw0EK7mulZBNrpxvay4YCUpfVhE1TOmavXFH3HqXvKqNzNdqy1HxDBkpXz4yZgZ5R2DzjR0liMKfCL/iPLcp6hPnnr3IfaveQXgkwy0zmsPk5/q0caQKo+vH+82OMPlz/okbWzgZincAzZSBe6iFhAJrsVy4AFbm2n0AaF8HMeLMvD09AI5lZYY+yu/EYvC8E3n7tpQQqKcibMh08yQ==
X-Client-IP: 67.163.93.242
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-4 (Postfix) with ESMTPSA id E051718001A0;
	Thu, 31 Jul 2025 19:49:12 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: fw@strlen.de
Cc: dan@danm.net,
	netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] v6.16 system hangs (bisected to nf_conntrack fix)
Date: Thu, 31 Jul 2025 13:49:01 -0600
Message-ID: <20250731194901.7156-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <aIuQoUQQnFMyvJJs@strlen.de>
References: <aIuQoUQQnFMyvJJs@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDE0MSBTYWx0ZWRfX0LHx5QnSPZ8V
 zweSq+q6WbNKNNusrRWTipKjPfkH/MFzgrwuh2lc+5X+EoKNOJ85+elJxBRP7rqojVL4lCtjg0h
 fUFm9tlhIhTR14Y9X7EAE2OV3qdY/AGVEI8w80hhAlj2cWLCcB9Lsq91r0E4w0YrGSWk/Bvtbfu
 J4rOAhwl+dgfDjfSPgpnKoUVQBU72PstMzkE/MO//hetHxKU2dBmebJbPN5O+AtMX1QHcnKBlAu
 HOKNvLSqGEW0jiAYHYTCM0RHh7g/q8PjWHBGLNNx3z7IuwbwglWBsf/T8iYI0LF4F5HoQBBxo=
X-Proofpoint-GUID: X4gSKUyC0gMzkcE81f0s74MUvdiM7hkn
X-Proofpoint-ORIG-GUID: X4gSKUyC0gMzkcE81f0s74MUvdiM7hkn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_04,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 mlxscore=0 clxscore=1030 adultscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2507310141

Florian Westphal <fw@strlen.de> wrote:
> > Strange.  Can you completely revert 2d72afb340657f03f7261e9243b44457a9228ac7
> > and then apply this patch instead?
> 
> Any news?

For some reason, I can no longer reproduce the problem in new kernels
that I build. I can still reproduce it in the kernels that I built
last week. But if I build a new one, from the same commit as I was
able to reproduce it from before, the new kernel build can't reproduce
it. I didn't change anything (like compiler version) since. So I'm
stumped.

I'm not sure what this means, other than that I can't test any new
patches because any new build I do doesn't exhibit the problem. I
guess at this point I can't rule out some kind of hardware failure on
my end (though that would seem very strange that it would consistently
point to a specific commit, and the problem went away after reverting,
if it was a hardware problem).

So maybe we can ignore this for now and see if it comes up again with
anyone else.

Cheers,

-- Dan
