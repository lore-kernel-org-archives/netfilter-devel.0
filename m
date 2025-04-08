Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6E610E5;
	Tue,  8 Apr 2025 08:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744101587; cv=none; b=JrjHtCxYYptGLhQWqn20Ub2MSS4dtjzDFVJQiutvL3kJXuz9IYiRunaY/c4NFQC3zMINn16RNmNMcgSFwFnWP3to/DLB7tJ/ERQuLNRGjqa6Z+X51fy/XFXiVBfPvmEOeV6ihwjHZmNAoUaMXWUO4YW+QnGP5pdDLgESvF12IWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744101587; c=relaxed/simple;
	bh=LSP5b+YQcQrSZ1ZT5Br4ItsP+yNHZF/MSCM72QEEbJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nQQ/LNV5MtjnsGIffLHiFNoa7enlfqgUq58NfUQVBZRNoDkS5Y3uU8HthsGq8FRoUdUi3uKoyNWQkssB2XDBpQrnPkbe5pE2saGAoa31VGA7s2uZ70fQ45lkA1S3Hf2E2sH9h8zL5jH9SwjqNzXcqRnak6Q5sHa4T2Fv7GuXHvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XxekwzBA; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XxekwzBA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=LSP5b
	+YQcQrSZ1ZT5Br4ItsP+yNHZF/MSCM72QEEbJk=; b=XxekwzBA8CSWe2P/AsH+I
	VcX1avYR9vhMs33rNzh9pcy4zUJZcQC7hY778eUx+H+eZaBjSHXmIZTMhyA97G+B
	ZfcGjIGeXt5mPDjFy1nbKCP07ng+R8hQ0y8tSnCbKL8Zd5ynBz3v+ECVr87zCVZu
	tvJeJQPAhEaHLS/nC6M134=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDXz3ue4PRn2VDzEw--.53339S4;
	Tue, 08 Apr 2025 16:38:55 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: ej@inai.de
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	xiafei_xupt@163.com
Subject: Re: [PATCH] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Tue,  8 Apr 2025 16:38:53 +0800
Message-Id: <20250408083853.59199-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <66ror6q2-7pq2-os23-rq8r-8426ppr6pnps@vanv.qr>
References: <66ror6q2-7pq2-os23-rq8r-8426ppr6pnps@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXz3ue4PRn2VDzEw--.53339S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr4DGw1kAr13Jr47uw47XFb_yoWfCrb_ZF
	ZrXFnFkw1jvrs7Jry5ta1xZa93KFW8Ar1UA3yrtwsIkr1fXw15GFn2grW3ZF4UGr4ruF15
	u3WSgw4kurWfujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUU9NVDUUUUU==
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiEBgpU2f03D9+pwAAsb

On Mon, 7 Apr 2025 12:56:33 Jan Engelhardt <ej@inai.de> wrote:
> By inheriting an implicit limit from the parent namespace somehow.
> For example, even if you set the kernel.pid_max sysctl in the initial
> namespace to something like 9999, subordinate namespace have
> kernel.pid_max=4million again, but nevertheless are unable to use
> more than 9999 PIDs. Or so documentation the documentation
> from commit d385c8bceb14665e935419334aa3d3fac2f10456 tells me
> (I did not try to create so many processes by myself).
>
> A similar logic would have to be applied for netfilter sysctls
> if they are made modifiable in subordinate namespaces.

The patch is to use nf_conntrack_max to more flexibly limit the
ct_count in different netns, which may be greater than the parent
namespace, belonging to the global (ancestral) limit, and there
is no implicit limit inherited from the parent namespace

