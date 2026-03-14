Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C4434F259
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773497025; cv=none; b=TNhoRk8jrcu8hGRpOWbmTJYbyJ6co829uaj7eJvGmOwAfHhfVydnClHx05UtHJdoq5KVD9lsi3OMOhPvtnNEOxtHyc8TaJb2gzbOLyppYLucuBCeUpc/FtONFcZq6CsaGCSvEWAhtLVxBnXILiuBvi2XcIf9rGfxJ9y7J/DYQ/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773497025; c=relaxed/simple;
	bh=sgPSEBXiJzbLUZfpo/yiL7lSsuvwcrEZVoSXxcN8Trg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RlcdeAek5Ay1ndD2XVkRrXzChP64gFqzx7cDO/tgIk5nhgg/l/bJmIqxmnUaADAobGfi9C67bbp4AHUxN/Gtaj9i8N0XPODqoTlC5Jg9EmAo+EwAzzZZllBA94ynlm1To53dqU4NThDA6YSYrMPMV1iZ62ur8sU5hmPN30ug+K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=naAjBzjc; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="naAjBzjc"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899a5db525cso35979496d6.3
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 07:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773497023; x=1774101823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozggT4VxXxi8nNocpv6bPtGBFv9+GusqHxKISYZjKwg=;
        b=naAjBzjcKOhTPuzjMw4A3c5mCvmKOuEcqDolxMAdROPVIR2Zqvb992FrptAvczZ1Gv
         Cn8B73JNKdfMpD+oaeptKTMvvjU8qVWvVDgf5wT8jCUNnvkOib1QFKooFYxXyl3SJ9tN
         PzICESDCJbEG675cNKUQiKoJyUdRI645Zr1NDLldq33XuNn3RBBTEGdTSA8ycXmeu5+Y
         c709/5Zzv/RuBR6IV2NaQN7A5M5j+H0tI6QwawR013pc35SUmj9x+dw/fDEr++4WNhKZ
         lVtK29R2wwfYfHf38f7ZthLHstSdCeGGBJP6JSmQin4Rr91JwrZUXCNZ3KTOnmHI9LTQ
         2CZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773497023; x=1774101823;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozggT4VxXxi8nNocpv6bPtGBFv9+GusqHxKISYZjKwg=;
        b=CAEZJpx73tix3RqWDywWBs0xlaT6QEtSoHD8Wj3+AJijo1OjaLkSti1qw84cM5IZ9b
         gQm0UP6shYMfpViH2D6nnMRvYsNiR3W1NahVNtYRo6yhWOzeD6F5NQImEUe4iMyPxx17
         7GLY0trDGmrTixvnqldcQCwxdY19xIofjSDfIQTYl0J+Yu8G8uVjTqcM32avjJotpl3J
         zy8bYmS+LYy6sFJu/onrm/Nafrd88rlM5EI9LBEU81G6AF8vUUQZGg8q5fTJqmcfKXmD
         koDBur3zINoDEt9fiZbJJMu3JywNS9Q7os7Uy7kt0gDPExoOwtAmSLFXw4pQZH0K5Yfr
         BXYg==
X-Forwarded-Encrypted: i=1; AJvYcCVafZHaGzTB69Cg+SQ+lpBKF2rhxbGgLu1jjHHAWMe42XaSB2F+GywxUNnKtXJ/YswRHTleApD1r8e2FlF7EP8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfM2CfR9ANetYD2w7rHERV/GQNLe99Ui4WqgtuRStLVsWFj5VR
	EcSpY8iHNhYMSVmaxu30S6jcOQHFvTQdoSnYULY1insA5qz4TF4mbiqp+VjiO+TK
X-Gm-Gg: ATEYQzyjuL75crGhgLgYZkszexiY5kU3lAaICsu1bnpOB77xrJi3M24F2B+8dlAWqcL
	RnDJUcZ48W4uQ3lhEz9Qj553m2Z/MLszA0M6MFsKxCM30EgjkkmCAIPWUzBOVdqTB/4+H1NcJux
	aZ1+sO2YKo1iD724SDL6C3w1i/l5jGnl2oRNWDLBNRZjaMjjCRAz6FPW9BT8IgXFpN7eMjo3U+Q
	qoQPNP5KmyZdbzApBsJSvOZUXA7SITWpaH5/VhSRE40bq5cJwkwt/DhgRbb7KMlSuwgE9o0QEiy
	z/vnzfWlC/dVg6EmaqspAwBUpuA+nv0zWE6nOEGuDWdEeAGQm9xUpBQeu/8nsuwme8Yz71OtUEd
	wmnN2dj+KboOl7ys5DOo5uEGSwPr45xhYluPyzos/yoUfJYnECGTPygxn+dSrCd/aL3dLFaON4D
	7baEOowjDGez5ABA1feXucwSZlHZb99NyxuPCh1O2Ztn5wBmOuc5yqKtDcu39jVFEu6N/+Xw==
X-Received: by 2002:a05:6214:5907:b0:89c:44f9:e879 with SMTP id 6a1803df08f44-89c44f9e989mr4328376d6.49.1773497022499;
        Sat, 14 Mar 2026 07:03:42 -0700 (PDT)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cfc85dsm78266516d6.37.2026.03.14.07.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 07:03:41 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id F187DBE2EE7; Sat, 14 Mar 2026 15:03:38 +0100 (CET)
Date: Sat, 14 Mar 2026 15:03:38 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Cc: 1130336@bugs.debian.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: [regression] Network failure beyond first connection after
 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was
 skipped")
Message-ID: <177349610461.3071718.4083978280323144323@eldamar.lan>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Control: forwarded -1 https://lore.kernel.org/regressions/177349610461.3071718.4083978280323144323@eldamar.lan
Control: tags -1 + upstream

Hi

In Debian, in https://bugs.debian.org/1130336, Alejandro reported that
after updates including 69894e5b4c5e ("netfilter: nft_connlimit:
update the count if add was skipped"), when the following rule is set

	iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset

connections get stuck accordingly, it can be easily reproduced by:

# iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset
# nft list ruleset
# Warning: table ip filter is managed by iptables-nft, do not touch!
table ip filter {
        chain INPUT {
                type filter hook input priority filter; policy accept;
                ip protocol tcp xt match "connlimit" counter packets 0 bytes 0 reject with tcp reset
        }
}
# wget -O /dev/null https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
--2026-03-14 14:53:51--  https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
Resolving git.kernel.org (git.kernel.org)... 172.105.64.184, 2a01:7e01:e001:937:0:1991:8:25
Connecting to git.kernel.org (git.kernel.org)|172.105.64.184|:443... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz [following]
--2026-03-14 14:53:51--  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz
Reusing existing connection to git.kernel.org:443.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/x-gzip]
Saving to: ‘/dev/null’

/dev/null                         [                         <=>                    ] 248.03M  51.9MB/s    in 5.0s

2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved [260080129]

# wget -O /dev/null https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
--2026-03-14 14:53:58--  https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
Resolving git.kernel.org (git.kernel.org)... 172.105.64.184, 2a01:7e01:e001:937:0:1991:8:25
Connecting to git.kernel.org (git.kernel.org)|172.105.64.184|:443... failed: Connection timed out.
Connecting to git.kernel.org (git.kernel.org)|2a01:7e01:e001:937:0:1991:8:25|:443... failed: Network is unreachable.

Before the 69894e5b4c5e ("netfilter: nft_connlimit: update the count
if add was skipped") commit this worked.

#regzbot introduced: 69894e5b4c5e28cda5f32af33d4a92b7a4b93b0e
#regzbot link: https://bugs.debian.org/1130336

Regards,
Salvatore
