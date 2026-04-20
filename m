Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAE5298CA5;
	Mon, 20 Apr 2026 11:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776684974; cv=none; b=gdrcE04IfsK3O/nBVR48CXOoLxCgtyq5oPcototx5Sd4cxWK+NVhX+x1paSPMAug1aS5zcD+8l3ix4ixiD0zxemJD7uK0Cden0sIH/WdtpEGSuXvm4F/U6d9iyntyRhp2Wf9oHPAypKT4YzKKnkOKzI66b7NtRQtS6Job/vWzzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776684974; c=relaxed/simple;
	bh=DZ2IJIsTPYRRREqEtaAfuRENNxtiPUVPNWrGhzjMUEI=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=QKjA2NVAOZ0VaCNA5BMqAkMwav8w37qN3L0HWDPR+R+zR/EVFVtKmqmEA5Lh7FfHGiVnlWpI5nfFLrNzd8Bs76JAq9rwfdCtEPr02BCrBUuF3spW3cY0iBqNdh3qTQ9W3hd0WHWz5233pwFZjNJT4K6sO/WkZF0yLDt+gCCroPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/HYEkIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/HYEkIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D640FC19425;
	Mon, 20 Apr 2026 11:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776684974;
	bh=DZ2IJIsTPYRRREqEtaAfuRENNxtiPUVPNWrGhzjMUEI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=N/HYEkIEulAcgdEg3Hrvoz9L6hmt1OeZ/WCReQx4cw87fdHCfI35sf5UWpBliPLHd
	 HbZRdnmnGlIVU6U37npZaGkfeVgo6U/EGKhdjfPyWkdsHTcRt4uIQUiH2x5dGAPg9m
	 yfVmdiXO5hcw35aCAL/AXDYKCw5UWsfGrqz8nunlYujPnwWDqmCgQ6mw7/J0fnd6a2
	 LrWjZxDMMjngyKlaexAkzHij7gi4gXj93de2egQ3kmkLzYmtLK3S6uxg0gzLF/AG9g
	 gMVAMWlravYWtFtN5iGJBbOawSznI+RbSMeMooSFOlCvrWNcvmf+LtBkVSTYVpgLli
	 WgkzUTy8tfLTw==
Content-Type: multipart/mixed; boundary="===============6902634143243539288=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <4cfe307cc6b1197fc7bb3a11e79382764ac1d269a42eb4e4ffec9e991e6868e6@mail.kernel.org>
In-Reply-To: <20260420105816.72168-5-mahe.tardy@gmail.com>
References: <20260420105816.72168-5-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v4 4/6] selftests/bpf: add icmp_send_unreach kfunc tests
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,mahe.tardy@gmail.com
Cc: alexei.starovoitov@gmail.com,andrii@kernel.org,ast@kernel.org,bpf@vger.kernel.org,coreteam@netfilter.org,daniel@iogearbox.net,fw@strlen.de,john.fastabend@gmail.com,lkp@intel.com,martin.lau@linux.dev,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,oe-kbuild-all@lists.linux.dev,pablo@netfilter.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 20 Apr 2026 11:36:13 +0000 (UTC)

--===============6902634143243539288==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
> new file mode 100644
> index 000000000000..24d5e01cfe80
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include <linux/errqueue.h>
> +#include "icmp_send_unreach.skel.h"
> +
> +#define TIMEOUT_MS 1000
> +#define SRV_PORT 54321
> +
> +#define ICMP_DEST_UNREACH 3
> +
> +#define ICMP_FRAG_NEEDED 4
> +#define NR_ICMP_UNREACH 15

Jordan Rife previously suggested in v3 that these ICMP constants should be
imported from <linux/icmp.h> rather than redefined here. Would it be cleaner
to include the header and avoid the redefinitions?

Reference: https://lore.kernel.org/bpf/usz5bhydsiejr37owgt3zypckzh7fa7ygmhsyaaiprsljx7iy5@ipopnr5n4ds7/

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/24663313503
--===============6902634143243539288==--
