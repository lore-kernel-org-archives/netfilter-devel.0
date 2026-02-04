Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEDE285404
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219513; cv=none; b=MhcmFmIUM4ihL3S8dfuQZLoJMHdsYQgQ3J6flKXfxSPojczkXf9qRdwrDtVxqpZ3cu12gCdQyIcZ03Ls7llxI3H6KmdC+cIRlN2m3T8RGuwljlMuTLEvXZT8+BZefLst40L95S3MKLieRCDED7+SJ+lTEC04U/a/QRPYbKdC6D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219513; c=relaxed/simple;
	bh=dazWroJUwQi0nrwSDlFxB7suit2nOEw7he12y3yOnqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNLUt+XKv2USzkNhgIPudsz7iScqcij/A8IqWxfvgG8burmEVwvL7G6u5Hu7ww9uXuxoI/0wUw1yWqtTog7pL0GACURYTrB7jW9uA+aKP99j0SO7tALanZ8k+VgOFNj0mTEX6rODdx7Pw6ERLbfy/PwI1Yn5qttpeezsS8+WYQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NP4ByoZ0; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NP4ByoZ0"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-794d05dbe22so39056977b3.3
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 07:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770219512; x=1770824312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpODAycToOiJmSD/e3ZFdCwq9sHP+TaddEYeB8Erx0A=;
        b=NP4ByoZ08sf7RBiXN+SbJMYTj6rfGiBOQgtTrWSzyTEUe3ueadqEuK/7SyrBXyFk+w
         xTiqhKlhOtIlfqkHzzPALX2711cV5nJpMHSo6swK/EAVynzWR1f6iWipu4BxKB1oFQvE
         YV56nqOXbS8/kQW9UT7wb3BZrSRDUGLIUVO6WZX1mBNXEpSuaichamwXtWZesz1p85tM
         dthQRf2bCasj+OqiztYhqOSMfcYPjoK2DPkS90RXTObWRyHfBy0oIQl8dC1cV3/OUWrV
         oQCWTCSrquAF3Fu3aKfiPAjjL6VtLa711Qk2hkTnZZOP8Zd3vmdyKokR543T+cDBB9G4
         qTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770219512; x=1770824312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HpODAycToOiJmSD/e3ZFdCwq9sHP+TaddEYeB8Erx0A=;
        b=vNBHoA8XrNG36/N6Z+S5NCzXNYiUSRuJ3SY6KGPoyblg6djvRSByzhD+JlWN88TMeq
         p5KxT9/UK8tp3luilBATWaV/Ap1h6eZmjmeXZEy5t5I/C/XZyEjpxwlNYHgh67Y6aLTZ
         aQD5zt8Cax2lnwDsG3P79pL3OsMXaLEilkL7oGJKELLbkKo+a4Tk2JBqfnESLdurJSBh
         daJFVTFoMq0dTooKzuZk1TpnQ36uVtqSZBPsA8WHZWbZt2DUnAgDQ4HzkryO2099lvT8
         8Ag0tWUj9d0TG0unwRwXJlYuz2T6VWV9q3FFLXMdB2ZEFFusLBAhutz1SBmetIotZQHa
         CPDA==
X-Forwarded-Encrypted: i=1; AJvYcCUEYr0zZZ4e2nNttJd/6sjJbz9dOYZ9FnlhGAt5VEirz/FtX8RjxwnRodehCQ7JXfeSE6naIORZM/Xm1QcA0Nk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/8592rvXYFiapuRl+C71UnsLq4Rymx4JV74XOsZ4B7OgXjFDw
	ubJ2DaiEUzR04INcGbGLCIbuX6xzUeEVy/lMp3aBRKRsBmMSms8/Ru9s
X-Gm-Gg: AZuq6aKZSQlg1CJjZhPZIZmLOuDV/VSxGvC15hnY2zZCY0+Dq9nHQ9ixOMRxl0gCqkc
	UDrctwSELYu0BoFFKJizghN+tDnxH0akJ5AYSX4NKSug9bm2T1Th+RW7HXEIQ5O+WLH8hGgeVTj
	v66kM2YuO75QJ0pS8Z0JtpbzsYPxvgKzqdHyHTONmN/+4geBFSgF2LIFPX8fonc9gj0Hiz/tBpK
	S2Dr8++HjmRSjmxXKXjKZw53NCvIw1bA/z4qVEBEu+Qf7uMn2pBlAkT8td7dsRi6F8Wc3qalM2c
	Y1khLn2pnG6ihl2Mvjru1NLJvqUjr3ahxc57DcSJCAQdw3nH6gVK+CbraCvI9s+AL+SxHv27puU
	ETg7D8G7xcITB0tNLqClfA5kauvMzI9D3u+doPNBrp436VaQvMdKBbuYEUJ+JxoSd7nXzHME0+c
	TRMIKJz/9qn9WEhiYosjwRHpcSPq6pWe2B4++iKovd9aPXPGVxnOIs6blT/thES1S739RL+U9kZ
	bzvA1OvwpsvmqxLHyYA
X-Received: by 2002:a05:690c:6107:b0:794:d8a8:674 with SMTP id 00721157ae682-794fe796c75mr33814437b3.53.1770219512303;
        Wed, 04 Feb 2026 07:38:32 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-794fefedd4bsm23609397b3.48.2026.02.04.07.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:38:32 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH v4 0/5] netfilter: annotate NAT helper hook pointers with __rcu
Date: Wed,  4 Feb 2026 23:38:07 +0800
Message-ID: <20260204153812.739799-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aYM6Wr7D4-7VvbX6@strlen.de>
References: <aYM6Wr7D4-7VvbX6@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds the missing __rcu annotations to NAT helper hook
pointers across several netfilter helper modules.

These global hook pointers are updated and dereferenced under RCU rules,
so their types should be annotated accordingly. This is a pure annotation
change (no functional changes), and it also improves static checking.

Changes since v2: (no v3 posted)
  - Extend the series from nf_nat_amanda to the other NAT helpers
    (ftp/irc/snmp/tftp).
  - Keep the changes limited to __rcu annotations on the global hook
    pointer declarations/definitions only (no functional changes).

v2:
  - Place __rcu annotation inside parentheses (per Florian Westphal).
  - Use rcu_dereference() instead of rcu_dereference_raw().

Sun Jian (5):
  netfilter: amanda: annotate nf_nat_amanda_hook with __rcu
  netfilter: ftp: annotate nf_nat_ftp_hook with __rcu
  netfilter: irc: annotate nf_nat_irc_hook with __rcu
  netfilter: snmp: annotate nf_nat_snmp_hook with __rcu
  netfilter: tftp: annotate nf_nat_tftp_hook with __rcu

 include/linux/netfilter/nf_conntrack_amanda.h | 12 ++++++------
 include/linux/netfilter/nf_conntrack_ftp.h    |  2 +-
 include/linux/netfilter/nf_conntrack_irc.h    |  2 +-
 include/linux/netfilter/nf_conntrack_snmp.h   |  2 +-
 include/linux/netfilter/nf_conntrack_tftp.h   |  2 +-
 net/netfilter/nf_conntrack_amanda.c           | 14 +++++++-------
 net/netfilter/nf_conntrack_ftp.c              |  2 +-
 net/netfilter/nf_conntrack_irc.c              |  2 +-
 net/netfilter/nf_conntrack_snmp.c             |  2 +-
 net/netfilter/nf_conntrack_tftp.c             |  2 +-
 10 files changed, 21 insertions(+), 21 deletions(-)

-- 
2.43.0

