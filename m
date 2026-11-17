Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.231
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932146;
	b=QcLn5aygAQV8kA/daug+RodZ93Em9rJxoh34GQx/K1+XFrqTpk5omqysDjpL2tm3udDl
	 sn7EMXwMy9u3d9sO9jdKhEhh0ZiPcLz7gjvo/q95XFryGYcaQXqADNsMJaCAQQJEx9fGO
	 GpPtvzF9qitzwhxogzvUHEUiCmMTRgdHq6SCjyWLcER4J3Jwxho7Oc3PCLyFn1jhK9LSG
	 FdKr50Rp05hudouIhjjNlPL7QkfidCRNVjnX5Y3BPk9gk1aOkKG0QgBRAJxqgtwAaeQ+k
	 YHsxhCqiQtryn81tQFGS6Gold/74GQGWdWBG0C6yBW6xvAo/yWFZMxeroytIGtWLJ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932146;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=jpPgHLDAen9Xpfcyv+fbKuLcvanrrLTUhEDvQ492YYU=;
	b=aOWAJMv5HxBs5yPjzWOvA/RfH1g3NDYJXD0GYIBnWNM+DJyUWNVEcfiJwUyqYvI2F1/W
	 ntxdUJXT9ToR2/K48R6ZflwnuNRQVj9loVoQWt9RF/EySXWwxBFAJdv5RHPaO4MntXveX
	 MLQANmB6G52p7QMHMcZDpH8C+2hLKjxc+w7Yjpb+MSY/Mp897jMAWaPpCrsslv2nboUxQ
	 ADE6d/xjwMjwA0JLpvmhemEJqxBmXkFyJ35YFcJsH+rYi7DdClsPfcMfS5HQfTctxRTxb
	 G9Qj+reBBOPuzHpVSJB5COoKwClLFdWNT8RYj37fK/FzOrcc+oJaonqhArD5Xo69BHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=EKvaFGIk;
	arc=none smtp.remote-ip=203.205.221.231
Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E760606A31C;
	Tue, 17 Nov 2026 16:15:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E760606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=EKvaFGIk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794932141; bh=jpPgHLDAen9Xpfcyv+fbKuLcvanrrLTUhEDvQ492YYU=;
	h=From:To:Cc:Subject:Date;
	b=EKvaFGIk+KDXUFbT1zIiMwwlcWKxdldSDxsbrF/dr1CCgtNrbbwzogc0bNyrpuXY0
	 HK1CJNG1Jn7K6hQ400BrCsDQIUb+F8ezFxbWsdqP3LwDM/ik6+7kUimFfK7U7sio4a
	 QW0AFPH0M8exnVr6jFu7x3zPH0uiuy7oOGHBPWgs=
Received: from localhost.localdomain ([182.239.117.117])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 3E6A5A2C; Wed, 18 Nov 2026 00:15:38 +0800
X-QQ-mid: xmsmtpt1794932138t2omu2abd
Message-ID: <tencent_80CDC0280E0D4030AF01A16E583E88E7970A@qq.com>
X-QQ-XMAILINFO: Nvot78Ae2aERTHY+VVar441mJAbr1luSKujRFNI6bLbpcdvcAoETXDf50rOPQJ
	 WTlowAWCq7xT/TUSqqIRYEGRg3cPu5SfJq4pez5DwqwZIGE0XV09pe/jIrUQDWSYCajgaNsAOqb7
	 koJiLzesEH8kYFcj33UZXQKinxvu/cAxeR381wke+3IfbzLVmu4JhSGI93c7dyzGKEhlCCY063/a
	 bedb8OkmdGN6s+sWGCai8sxyqe0O6nTKE5AAu8fAFfgEvcBXOj7trscsMmiAWckEtlbzPNhWwbbp
	 VeMtZcx6Qio3mbBU/u/mZusEnPI5nn2ZIZSkFyyVtL2SouOsN/7X2tLF/qUnfGKyDclCkQbyCaA7
	 KiETlpaxrR4yZxdU/osNaftZ7EwSrOxPL5OXWT1n3Mg1pKsBTZR13i3OB7t1kNVw+VwFpl242ymM
	 UelQ0Bs2lLTLjwy1+0Dff6ue3Dnf5xjpsiwmdXWGk0cyWjiBu6nJaDDJiIcJ1GyZ/qOPGmiUCI6D
	 fK2ss5Tv0XTdCA/IYowqaHIkYGc0sLDpIyKOd3CqEaNvIkxdlcd+GDJ/Strk510yVR2zA8ZRPF3q
	 6b4l2LLazU2AnKJ11348AnKubBzfwPlkHDvtKpIXCiFDk4Yc/JNHImBGcdjLouODaLr7IwQmIJj1
	 9jzSwDDGA0MfTjQdOFZVnj0UOMpls4tlMm3GnmKfAVQhNA6RfThG3Pz2KKhEXF4v9nxVdtVqSWrr
	 oVKSMJRztawtN3sDOh81q8Yv2qYqUoiSUlu6bMCOv397t26gqSM1hvznT7kBaXfDI0f7Ev3RA1dc
	 fVGhyVXwCbmLMJ6ZETTDhcaZ33al52qoZa7hWFJPyZ23drsqbjvSzCws+I4FHimuYOR0tdNErrxO
	 lONpTtpHF7pxJtVUiRezm4iXdy3/T5k26TDsLjUEctJdrjMm8wXr4tc4dSvr6XDJsxiLIRhu+RRz
	 O6rNMTdCKaV+s6WrXIMVlY45VTU9oqmzLgaqS8KgwjAR2ODKcI/vgXq4yJTWs42K6KJzCUFl+x4T
	 B4ywrof9FFMDZP3m3cMMyelq8TbvRqCre/8JwvdfTTIUxxp2CT0o4UwwVcodv2zVfVV3beMg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf v2 0/2] netfilter: nf_tables: only disable tables on a dormant transition
Date: Wed, 18 Nov 2026 00:14:56 +0800
X-OQ-MSGID: <20261117161520.1031-1-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
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

This is v2 of the fix for the nftables WARN below. v1 was sent as
[PATCH net] and tracked a per-basechain "registered" flag. Xuanqiang
suggested fixing the commit condition instead: a dormant table never has
a registered basechain hook, and nf_tables_commit() should not call
nf_tables_table_disable() for a table that is already dormant.

v2 drops the new field and changes only the NEWTABLE commit path:

- if (table->flags & NFT_TABLE_F_DORMANT)
+ if (table->flags & __NFT_TABLE_F_WAS_AWAKEN)
      nf_tables_table_disable(net, table);

__NFT_TABLE_F_WAS_AWAKEN records a real awake-to-dormant transition.
Since table adoption added __NFT_TABLE_F_WAS_ORPHAN, __NFT_TABLE_F_UPDATE
can be set for an adoption that leaves the table dormant, so the old
check disabled the table and unregistered a hook that was never
registered.

The WARN was found by FuzzAnything's AI-assisted kernel fuzzer while
fuzzing nftables netlink messages in a user and network namespace, and
I reproduced it at runtime on 7.3.0-rc4, 7.3.1, 7.4-rc1, 7.4-rc2, and
7.4-rc3. The baseline 7.4-rc3 dmesg is:

  hook not found, pf 2 num 3
  WARNING: net/netfilter/core.c:522 at __nf_unregister_net_hook+0x71/0x1b0
  Call Trace:
    nft_table_disable+0x78/0xa0
    nf_tables_commit+0x1c03/0x1ec0
    nfnetlink_rcv_batch+0x939/0xaf0

v2 was tested on 7.4.0-rc3-c027fixv2: the PoC returns 0 and dmesg has no
WARN. I also checked a real awake-to-dormant transition: after the table
became dormant, a ping left the basechain counter at 0, so the hook was
still unregistered correctly.

Changes in v2:
- remove the per-basechain registered field
- check __NFT_TABLE_F_WAS_AWAKEN instead of NFT_TABLE_F_DORMANT
- add Fixes: 31bf508be656 ("netfilter: nf_tables: Implement table adoption support")
- use [PATCH nf] as requested
- add a selftest as 2/2

The selftest uses the nft owner/persist table flags to create the
dormant orphan, and checks the kernel taint state rather than parsing
dmesg. It fails on unpatched 7.4-rc3 and passes on v2.

Thanks,
Ma Xinmeng

Ma Xinmeng (2):
  netfilter: nf_tables: only disable tables on a dormant transition
  selftests: netfilter: test re-owning an already dormant table

 net/netfilter/nf_tables_api.c                 |  2 +-
 .../testing/selftests/net/netfilter/Makefile  |  1 +
 .../net/netfilter/nft_table_dormant_adopt.sh  | 57 +++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_table_dormant_adopt.sh

-- 
2.56.0.windows.4.niugit

