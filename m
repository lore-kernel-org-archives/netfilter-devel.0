Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793224914;
	b=Q0Y14SJ4a0vMpGuejlCm23f//1h0zso1QVvOOwTqMY9RiD6UFoft7RiIUHXPuCHWBA0s
	 Pp2yXnZcvgQN0PbIolcADV0roZDQpfrF34uXTrvQPrBQTFKnD77YugZOENtt3TFsHun7a
	 7a1aDrNiuQCfCKomAC+teoyOTs87CAbobtEioSEHYK6XGXaIXfJjtj3gHbPj5kwqGQ4bU
	 flmkjHoiNmBbuqQnx6IjeY9moczGMyUKuXyt7BKIQVzkCZykM1xFS2sDxy43Bv2JKZakG
	 HAbUWCgXK9E1Q3OiQaN6UuHfotEnsWoB8qk/W22lthlbFFrGgvtroYYAiEARF/ggflA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793224914;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=3Rv7tQbRsvuq3WAIi5GyIt3wKvxrSuLpMHj9oOG4vyY=;
	b=5CSX7tAgQo3jRCPcrZuiIKetOjLUOUfqiJ0dX+K8C/YeBpbsyoqQoNslouG8Tz381Nxp
	 8Uui3bjT5Cuot2rW7bTd7RrGbW8YaDn86TWkqdMCYHtSRWzsLnSJQU5GQnnPecytqgkPn
	 picf2jjJ//dPCZjsZ2NjiAMLYsW6skGAXrdLEsxp5cHuFMEmxc28cTolhSeGwIu6RbUx9
	 vQN3A57JYFnC0FgRBp8yPBuZcnurT5O5m9dZ1Clq5vgkNuLUJFZRqa7piPCh88iKyIM6P
	 FY1b4BAQo6t4f02m5j4ROA6VLSKZxDKP/5y8xoRs6g3wvkuLu+oQ0aTwdKFy0azQQXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=ktV5xYwt;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D66606A322;
	Wed, 28 Oct 2026 22:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50D66606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=ktV5xYwt
Received: from mac.lan (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id DFD2020B7167;
	Wed, 28 Oct 2026 15:01:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DFD2020B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793224902;
	bh=3Rv7tQbRsvuq3WAIi5GyIt3wKvxrSuLpMHj9oOG4vyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktV5xYwtlIvls/LNLrf7a+eEGSve62NydD225Q+Xq0stHH+N8u5g9QcJY1H2mlAhN
	 2eF0I8FWVp2MKrCR10ckmacldRzPiFbQzDKpXruD1l3P4eZ8jf2fhgfkeKTeclbXq2
	 qjNUWkdVCA5jsvwh1N0rU43LYLxzaCNujELEZjCc=
From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
To: netdev-bot+sinfo@kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"Vitaly E. Lavrov" <lve@guap.ru>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	Cen Zhang <cenzhang@linux.microsoft.com>
Subject: Re: [PATCH net] netfilter: xt_recent: do not call remove_proc_entry() under recent_lock
Date: Wed, 28 Oct 2026 18:01:36 -0400
Message-ID: <20261028220136.50921-1-cenzhang@linux.microsoft.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <179322419201.3327.14972314584790214914@kernel.org>
References: <179322419201.3327.14972314584790214914@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This was found by LLM-assisted code review.

We confirmed it in QEMU on mainline f0100363d8c3 with a reproducer:

- With DEBUG_ATOMIC_SLEEP enabled, we see the "sleeping function
  called from invalid context" warning quoted in the commit message.
- On a non-debug build, we see "scheduling while atomic", followed by an
  RCU stall, and the netns workqueue remains stuck.
- After the patch, the same reproducer completes and reads
  return -EIO as expected.

We could not find a syzbot report or an earlier public report. The
reproducer is available on request.

Thanks,
Cen
