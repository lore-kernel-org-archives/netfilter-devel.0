Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2B17F3
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719476310; cv=none; b=R4HJtbkepvF9bQfU04inQzpwhqkipSSHFO+ET4DUyXbpaqa8fy1JnVl7+PnJIf+JjE6g4ciDcCe1cv+v7rCc/ep9FN1+Z+8eUqIDLTJM4I9tPgGNM4P6E/u/T7Qu27Zabqd+1kXj/WfAG2Klw9Y6Ai3fGudHVK0kA0RqyuIBDbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719476310; c=relaxed/simple;
	bh=PeMpEDqAEjDWpq3T+Dtg30CvP6vbcFRIPSYDCbSkK6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zcx/foX3g0Q+YM5bJt+ND+PnSEOL6bMwesEt01edzNC4KoLc1ZRRUNgoQYkKRX4p+4z7y0umUoTLML0oi/prAuz0LczX8gOeK5STU4mbrwMvI5Ab9zuhtH0cZH1wydA4r6qWiQUBfD5RHHlUCp1YaTLWKsEQXZO9AyGFlNzfBkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Gc5oCQw9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Gc5oCQw9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zK/Z1lXyhOwluEl4uZQxPDbz3OnTJSzY7vTQL1nApmA=; b=Gc5oCQw92iN65a1flcveRCX/yN
	71VG73RfJHLBI9C3t7ArKVjjKoL79VKhoOO2jtKpeJtr/trDwe4S5fpnaAm7EFgzPWQuI6sWTdvR4
	A2/qDIKznHhEDEpdpoD4zHqhNntr5+abMMA2WQZpPmsPcS2utNrICNoODdA0DTy/IiqBGanBVuczN
	+mXEB+JyYZ+md5H945iN9Lbckd8eYVmLoW4TcDjI+pQtZD2+wZJ+Hodo5yxrTAINKmGiBmwly3A5l
	SdQRBpf/5b4hCaiJeKJpM6hwExocvaXx1dU8A5cysng2Zy7syej/n8JOujK99F7oQH8Ppj7AKimjO
	E8i1TxnQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sMkKj-00000000809-431f;
	Thu, 27 Jun 2024 10:18:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 1/3] lib: data: Fix for global-buffer-overflow warning by ASAN
Date: Thu, 27 Jun 2024 10:18:16 +0200
Message-ID: <20240627081818.16544-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240627081818.16544-1-phil@nwl.cc>
References: <20240627081818.16544-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After compiling with CFLAGS="-fsanitize=address -g", running the
testsuite triggers the following warning:

| ipmap: Range: Check syntax error: missing range/from-to: FAILED
| Failed test: ../src/ipset 2>.foo.err -N test ipmap
| =================================================================
| ==4204==ERROR: AddressSanitizer: global-buffer-overflow on address 0x55a21e77172a at pc 0x7f1ef246f2a6 bp 0x7fffed8f4f40 sp 0x7fffed8f46e8
| READ of size 32 at 0x55a21e77172a thread T0
|     #0 0x7f1ef246f2a5 in __interceptor_memcpy /var/tmp/portage/sys-devel/gcc-13.2.1_p20231014/work/gcc-13-20231014/libsanitizer/sanitizer_common/sanitizer_common_interceptors.inc:899
|     #1 0x55a21e758bf6 in ipset_strlcpy /home/n0-1/git/ipset/lib/data.c:119
|     #2 0x55a21e758bf6 in ipset_data_set /home/n0-1/git/ipset/lib/data.c:349
|     #3 0x55a21e75ee2f in ipset_parse_typename /home/n0-1/git/ipset/lib/parse.c:1819
|     #4 0x55a21e754119 in ipset_parser /home/n0-1/git/ipset/lib/ipset.c:1205
|     #5 0x55a21e752cef in ipset_parse_argv /home/n0-1/git/ipset/lib/ipset.c:1344
|     #6 0x55a21e74ea45 in main /home/n0-1/git/ipset/src/ipset.c:38
|     #7 0x7f1ef224cf09  (/lib64/libc.so.6+0x23f09)
|     #8 0x7f1ef224cfc4 in __libc_start_main (/lib64/libc.so.6+0x23fc4)
|     #9 0x55a21e74f040 in _start (/home/n0-1/git/ipset/src/ipset+0x1d040)
|
| 0x55a21e77172a is located 54 bytes before global variable '*.LC1' defined in 'ipset_bitmap_ip.c' (0x55a21e771760) of size 19
|   '*.LC1' is ascii string 'IP|IP/CIDR|FROM-TO'
| 0x55a21e77172a is located 0 bytes after global variable '*.LC0' defined in 'ipset_bitmap_ip.c' (0x55a21e771720) of size 10
|   '*.LC0' is ascii string 'bitmap:ip'

Fix this by avoiding 'src' array overstep in ipset_strlcpy(): In
contrast to strncpy(), memcpy() does not respect NUL-chars in input but
stubbornly reads as many bytes as specified.

Fixes: a7432ba786ca4 ("Workaround misleading -Wstringop-truncation warning")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 lib/data.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/data.c b/lib/data.c
index c05b20144cdad..64cad7a377302 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -111,6 +111,9 @@ ipset_strlcpy(char *dst, const char *src, size_t len)
 	assert(dst);
 	assert(src);
 
+	if (strlen(src) < len)
+		len = strlen(src) + 1;
+
 	memcpy(dst, src, len);
 	dst[len - 1] = '\0';
 }
-- 
2.43.0

