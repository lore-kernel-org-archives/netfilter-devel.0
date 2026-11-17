Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.58.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907324;
	b=Zhxcgci+PjJGvkJCKVk/SkZX7nRJdXUAOOcUcY7T/8w/3hWzvZIAXwFpPwC5mlfDUzPC
	 KzytjKfmLsUqumJnRMLAVclG7wiAAF8irFhJgCZpwBYUSlga0h/PwemDekiMcnZJoVRZA
	 lJVBWmoeEDdiC/iwAPb0+XBdVslL+4zVjQ1fIZnSdBnsex5paqQVriEZZnBnTd42KAI1C
	 p/h4rmX2jsagte6VHxfj7701j6/HLDP26lpHl8toOWZa9NL6c4w7RHv30T0oQCsFysrO7
	 Fu583d2klounLBoJ+CDe/mZBS2bhaL+38c6eSeayBcZx3JhpWngjm98TKNMZgf8H11g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907324;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=n3tFkYYcWo63ywazI8rMlwtk6cvO7kdc14NRzobXhEM=;
	b=dExtlMkTdm/ZnpxVeT0vcFnQnb5Te8f1IizZSJqygVQAPAy6FYyW78rWghVkO/2bQ+F5
	 6u6QoUnazeoYNqL7Y092xkCGHB9kf3xO8f+sIslkvkKEtP+GxmjeqjF4xsQFdVsJSGnbs
	 tOam63LYf/XlDz3Kwi+A3eVhlpdofmsVSnQ3E0HE9gcL9+Pk+RXho0Yq2DH67sYTbEUtT
	 voj4o743WupxFYTHq9zaigQq1L/+BiR+M7peGIxCIAo+BSLYAAqfPpEcLRXX0QT9ECKtK
	 b1E5BFDPHhqI5AHu2OyuWtPUYdlYCNhYMVlAeF07sVrs56QrFHiSmNL+8DOmuNpk6UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=sSahcOYq;
	arc=none smtp.remote-ip=162.62.58.211
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F2D606A329;
	Tue, 17 Nov 2026 09:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0F2D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=sSahcOYq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794907317; bh=n3tFkYYcWo63ywazI8rMlwtk6cvO7kdc14NRzobXhEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSahcOYqkkv63vNkdqo3LhbhxoF6K/wuDEW48xE8Oph3bl5YFy2yVenQOLQu4cVSj
	 TSOF08pyvmBIEGAtHRPkhSKISwA7GOPrr7HCR4ktOXiey0kl2BA/q63ly85cScuv22
	 OVTjz+zdYaU5N5+2CJyd/F4G1jS/M1kmDAh6LEOM=
Received: from [172.29.64.1] ([182.239.117.117])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 57798CE3; Tue, 17 Nov 2026 17:21:55 +0800
X-QQ-mid: xmsmtpt1794907315tb5ur8e5i
Message-ID: <tencent_1EE75BCD1429860DD8309301916DB83ECC0A@qq.com>
X-QQ-XMAILINFO: MDbayGdXPuoeP/H8N3crNxHKRXI+kjeSgtk1cmDENv/PnWsi2k4HyMsiTbVxqN
	 ykhzbKLijsSw8S6Sv1X2rfIn96Frj6OAGBIvclXK2z2D2D/Ml2yAlAHA/cweOy5oPs55DLh5xRic
	 hXy2h1fJatFqfqAv8JCz/kU2X6gCI9WDTqFVStJBtD9cD++kb6/MV7O60yIksHi0yOU7mx+E1s9z
	 oZeZhMLafhHgcSBqHk459uC9iDMX1qNdCs7VRVs4QM5y1sZPR/qgHXD731Lu9yMiLP4POs+9IYLC
	 65X1ZTc4JmeJDCC4Zv24hpeVTVH1tWF1+5LYCJDHpW0DoZvEKpKaqyeKWtH6n3cEv2wCtfKnkpQr
	 VLojwUXB+i1EN3kK2lnr8QU8xxnh4XvISitLFuyaljHtmPDQl/est2Dt97nT3AjO5orY4HE3mR/F
	 kvRI4Q0DHzcf2T2M3gTKcEj3jerHtJIgHjSh77PmqzMByf/19YcflIECDgmGkP7dwciBHDudADBN
	 QO/Hn/E6KL1OASKGJHnRdoHoer1+y0o6jzd+wj1ZkFyD/qGrm+fTPb0k5Cn2XHH+eSeq/ccOqdvC
	 JoAopWSGYGWfyjhBejwgFGluLUs/9OrpkqDfogtKvlPRb9Ij3tTqsCneNe0/1vTUetgdAcLHp1H8
	 92jbpcJA2eLQJ7sF9gvjm2QAgAD+E24pdazShkvdMKmmClNbgNqTnhKhGhlrPVjnB8PWy2OxtKEw
	 UsSxxnFcBfqvaecz4uSrSQmgZUp1Y7HrLYxcnmphL2Jpr+5zZDinGxNBvKzSV5rQvQkMyAwWZtd+
	 1XcINk01ru2AKPJkXoOU3bBmNtUt31CxX1nbi7a3xN9QDG2r9CUkWNs67QbGVw+JzvXWcs2ZcMVQ
	 Rt8nozP91iqvziLX+E1q0oU64dx86+ncAXiYPUAyx8QMVQNa8fr0UccTTjmmsTwpVUgFJcGHUwPT
	 bu26y/lmf4skOIkrNqX2kTovBzjgj6XvklOKEkdjsllt7mOOLr06xz4pyxojKsz8M4+blFvSNlQ/
	 Jt4fH+k9T8NIUFZ+khpcSXKWcwg5axbEcYHt0orOgEY3C3mm0r
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Ma Xinmeng <1564938642@qq.com>
To: pablo@netfilter.org, fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH net] netfilter: nf_tables: don't unregister hooks that
 were never registered
Date: Tue, 17 Nov 2026 17:21:00 +0800
In-Reply-To: <tencent_19A48DA487BBFCFD990AC5A8010C663EA007@qq.com>
References: <tencent_19A48DA487BBFCFD990AC5A8010C663EA007@qq.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

This issue was found by FuzzAnything's AI-assisted kernel fuzzer while
fuzzing nftables netlink messages in a user and network namespace. I
reduced the sequence to a standalone raw-netlink C PoC and checked the
mechanism against the kernel source.

I triggered the WARN at runtime on Linux 7.3.0-rc4, 7.3.1, 7.4-rc1,
7.4-rc2, and 7.4-rc3. The baseline stack from 7.4.0-rc3-c027test #4
(the signature is the same on the other versions) is:

  hook not found, pf 2 num 3
  WARNING: net/netfilter/core.c:522 at __nf_unregister_net_hook+0x71/0x1b0, C=
PU#0: repro_c027470f/1087
  CPU: 0 UID: 0 PID: 1087 Comm: repro_c027470f Not tainted 7.4.0-rc3-c027test=
 #4
  Call Trace:
    nft_table_disable+0x78/0xa0
    nf_tables_commit+0x1c03/0x1ec0
    nfnetlink_rcv_batch+0x939/0xaf0
    nfnetlink_rcv+0x190/0x1b0

The sequence uses only valid nftables netlink messages: create a table
with DORMANT|PERSIST|OWNER, close the owning socket (PERSIST clears OWNER
but keeps the dormant table), add an IPv4 basechain while the table is
dormant (its hook is not registered), then re-own the orphan with
DORMANT|PERSIST|OWNER. On commit, nf_tables_table_disable() clears
DORMANT before walking the basechains. __nf_tables_unregister_hook()
then bypasses its dormant guard and calls nf_unregister_net_hook() for a
hook that was never registered. This is WARN-only; with
panic_on_warn=3D1 it becomes a local DoS.

After applying the candidate patch to 7.4-rc3, the same PoC returns 0
and dmesg has no WARN. The A/B test also passed on 7.3.1 and 7.4-rc2.

Thanks,
Ma Xinmeng

