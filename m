Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505665;
	b=WAeX1xtkVNjgZ5i+4Gr0Qaa7E3jlTo3vEP2fuLXOoqY1j6oQC6g4afSM3ElfF/eObxSy
	 HL1ok5568wiRAk45DXsST6Iglcz17vU7Audz/FNfeQuXT3EDg4CCQDtu1Q+cFFsUadyTz
	 rrHAn2iwMR+aufx3a9XzDvtstze6cdlddETF45ar96QxTbS87TksdiH/ArJy0b3ycUu9x
	 k4hPaFmmbaKojuvyBbCBkwitRbMBUiS/7swsjoyudg0xc245tRM3Fn2hhuxCgbODvlR8q
	 BUajxYKO5ZV/Ru01gIjNCAZVDkt9saflG3xGmNgfFZ69scZHmefRbLZDcdrh50/+kjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505665;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vfZOBxspxDQ7P2IBuHoXzQ0XfImR3bOjFKTPJX2P9/I=;
	b=E+H3PW1LmAjSA7CSdK0NQXfTU+f79LQOqX325OWhCAEokr0ZxD9rjCqAdLtqIaHTd7IS
	 rshC6Y2NUK+glEbOsDkvqjSOJMIIuTfE+FH/xN+4jHFZMnTw9iBLVq0jb1gUy1z6THgy+
	 r58OA/oCPuyoxPY2nqPqe0MIFsc6MqjrlyNidSs6dqCWmsmM5pWgephY25KCbrR1iXH3D
	 rOyvugEALlFqdFwGZfzZs5gT6m2w4EQUWiUtqfw15RkjdHaQXeP5el9qbYjEYq6VAw1dy
	 7UY9TZBiErzXC5Ik5TuyBfNIyJ50MG3k8prBFLpPSORrdzazbYQBiJGwb/bxo6xla6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Bfrnk6I6;
	arc=none smtp.remote-ip=162.62.57.87
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C89F606A321;
	Tue, 24 Nov 2026 07:34:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C89F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Bfrnk6I6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795505652; bh=vfZOBxspxDQ7P2IBuHoXzQ0XfImR3bOjFKTPJX2P9/I=;
	h=From:To:Cc:Subject:Date;
	b=Bfrnk6I6U2mvxm5Mjhm8vQJ0/wibSXzSESlMOUAkgnbAKOiUcmwc3DNTfTYLWxral
	 L6idzxjG2/E7y7JXEaiVoY+e/pdCtz2GLvaN1h2SnYhpzi1b53oEZyRJnboHGyQ7Fy
	 PFPy21w22x5NwIi5NthL827xJlMyZDtCon2sn1AY=
Received: from localhost.localdomain ([182.239.88.62])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 889B8CA3; Tue, 24 Nov 2026 15:34:09 +0800
X-QQ-mid: xmsmtpt1795505649tadbfw6cp
Message-ID: <tencent_0D3F10E667CD8029160DC031D700756D480A@qq.com>
X-QQ-XMAILINFO: MFkgsonL4eTu5KvOdqr1InTDIm87MbpIypxts8D6DA3ODrhYoz8PFxiZEw7UPK
	 lUnoeK6NM/2AVBD0Mwc1eHiM+bGhxtlBxr/mfYnoxwWR1fYNHVi/cRiwlOcTau91Hgfd0Y/RX8EJ
	 YKLCK4yz9cygkw8WIgUDloxaO4C0kwU4CgJHhVQzNnAvBb7IsuqJ2xb74FEmQ9mreAIiIb5I7xVE
	 FVTnZ9+DLUYWCxTsClvvLhPwxIw26pDH/5lXgnVPJozNXgFCCeAro3CPND7BycEafjTH7/9zE7MF
	 v2gCcz0BM0bdenR02DdjVtyBn/aj8AWOF+fFoInqxVrnQEvPyqZ5gWl6ay5i/5khb8Na/9Vd7QPc
	 6z2GTwh817lcENBRAV9hqnmVbnwHehZe4uAMccKyLwTlayVFdIM8sGfP+w8tP/F/TOeXoJjtX+9w
	 7bKkiRQZgr6gKryv1Kx3MmcLKxQfuYOMAKcRzHFlVHUFhS72Btm16J8dinQ0ny+I0szpPLI7jKoG
	 5y1kwA7d4Z7we3fLKhxUY2U/DHIPS8D0jVEMSZ+/ZVcl6eZez0fXUWpia+JupOJ8YL+yH8zxcEr+
	 5+M49Bi3/T2NcRr7TUITzFoROg4dkiRYG8l/JJJs52kLo8us5j86FSLNHBW4h6QopOiNJYYW71b0
	 yhx2Ja8gYWD7FJCMESjnMqg0eK8W0aWxufM0U231GpDM5Cuyu3/rsEv61txW2SUOTWo9ENct/aYk
	 UaLpI1AR6bM58+EstJde+IF5K/lZZcxZVZzWs8/4x1jg4f/jbMSX9ajL6j8vkzuFfY6cOsi0BFTw
	 VG7qWuINg97uLUuSD9bwePU5BYJfbRyvRGz0EXMETli4V0vk4wW3MZOtm6NBQrv1Cp9ghvwukivD
	 FO62Lf4/YhFvPmD7UcwnqszaB7ys85oZJUYl4BO0j2H3qo7aDf771zzlAECs4ojj1let+HkLSfOX
	 5mTDP4b/ZbxtygD0SJOXekDozsYawRKxckI1O/wLfeVSq/NZUHM/INMlVjt4htxhCiMn+lEP2/M2
	 2rEfo3WrhLwa8ivGT3In0kQ+auxXfSziA/IA+3izmCCT7If2K4yAR8/cTKZIMitc16QmbiCw==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH nf v3 0/1] netfilter: nf_tables: only disable tables on a dormant transition
Date: Tue, 24 Nov 2026 15:33:11 +0800
X-OQ-MSGID: <20261124073351.1562-1-1564938642@qq.com>
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

This is v3 of the fix. v2 included a selftest in the kernel tree; review
asked to move it to nftables.git as a shell test under
tests/shell/testcases/transactions/, where run-tests.sh already handles
the tainted-kernel check. v3 keeps only the one-line kernel fix; the test
is sent separately as [PATCH nft] (0052dormant_table_adopt_0).

The problem is unchanged. A dormant table has no registered basechain
hooks. Re-owning an already dormant PERSIST orphan sets
__NFT_TABLE_F_UPDATE because of the adoption, and nf_tables_commit()
used to call nf_tables_table_disable() for it. That cleared DORMANT,
walked the chains, and unregistered a hook that was never registered,
triggering WARN_ONCE("hook not found") in __nf_unregister_net_hook().

v3 only changes the NEWTABLE commit path to check
__NFT_TABLE_F_WAS_AWAKEN, which records a real awake-to-dormant
transition:

- if (table->flags & NFT_TABLE_F_DORMANT)
+ if (table->flags & __NFT_TABLE_F_WAS_AWAKEN)
      nf_tables_table_disable(net, table);

The WARN was found by FuzzAnything's AI-assisted kernel fuzzer while
fuzzing nftables netlink messages in a user and network namespace, and
I reproduced it at runtime on 7.3.0-rc4, 7.3.1, 7.4-rc1, 7.4-rc2, and
7.4-rc3. The v2 code was A/B tested on 7.4.0-rc3: baseline WARN, patched
no WARN, and a real awake-to-dormant transition still disables the hook.

Changes in v3:
- drop the kernel selftest; no change to the one-line fix
- move the test to nftables.git as a separate [PATCH nft]
- keep Fixes: 31bf508be656 ("netfilter: nf_tables: Implement table adoption support")

Link: https://lore.kernel.org/all/tencent_19A48DA487BBFCFD990AC5A8010C663EA007@qq.com/

Thanks,
Ma Xinmeng

Ma Xinmeng (1):
  netfilter: nf_tables: only disable tables on a dormant transition

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.56.0.windows.4.niugit

