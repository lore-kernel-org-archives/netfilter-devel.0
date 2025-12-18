Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F2C314A70
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2025 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766063873; cv=none; b=YYWl99BYVXPAxYhzbpkj+0bCTbAA0xNmCbCE12Nb9nsfLZqLh7Z/qWG+v6QCh9QjW4C13XspVVc3xINIK3pMWvLiNWqxa2soPqGOje+6KW4+tmKp9jeVaKFfz8j5vRVyc27AmFcqvd97iy4s+rpj6mmMfphdj37YNu1oJNYHi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766063873; c=relaxed/simple;
	bh=StyCfx1lTasOBP2jqWyKXhzfyoT/V0IEHGtTARfFvTI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=DDyAQD6BV1OJYTsDs+7FBqtRIm0ECjHqKTUa7atnEuGLPYT1YZsMgd3omg6Fv6zkbngZsw95ZlL+GTOUFyQVmnG1TjeuXEpIHTwhf5Q24UC1IpXtNLWpg4ociSjoO3wj3d0TV+5F0ctkvFWATt7nSn0wBWSgjvO4IbyU601dPxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C033zmq6; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C033zmq6"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34c565c3673so827733a91.0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2025 05:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766063871; x=1766668671; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=872wE184JhJ3u7tuHJEZnWGK2QXCPTag6KYyRPVVBFQ=;
        b=C033zmq6kWtMl5xdAbBsEVBpDTjWBuj77BLoodj9D7ZcFFoW1QZO7X2Xwg1ICqKZC8
         p9H7rIFQ3PVTqIXEjV72W8sM/jMRAiq/n4akfbmsmnd+zQieFFocQVW48VRhx1UvUCB/
         ATEt25rm0EdvaJ3oaRDELbRJ3SrZ3LFh2bmmr/22PCXwV9o0yk7T/G8ToyRYcru+HK+p
         kcQEDpnFfOIzub2GJgbOmiod/WJbotG2KuhRPxpX+r8aJvGZu/lko2oXdGKzZPHcxU7a
         7kaTZm5OVF1+nKZ3LBwbN5tTBOdvn6mjsAEIrgLN3uYYdO4s//AvgJKTErjA3duYlBtg
         HagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766063871; x=1766668671;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=872wE184JhJ3u7tuHJEZnWGK2QXCPTag6KYyRPVVBFQ=;
        b=BXtFZCOSP8HoeRKbCANp14ejl6R0V0VVulr9n6ZCIbLsN8yKp1kPi0UeYBdXO3g2f6
         nJc/sIzAobMQ7PBFQNYBhv8yGLvPpoGSVcC0PIxuErS0sZ+GTbRfpK9D3mx2KWf3zXp9
         E7F0QwNDeDG+T2SkOHUnOQyHXniXTajR+JZB9SNt4um8XYq2gFJE2KEjePfeSed/7Vb+
         un7hEvRHCZi2pdz91TKpK5y8s+db0ymPCSjlF0tW09gPx1beACezV3yuhd8RfPx685QV
         /lCjjrwmVA+7tYl3vCoMO3/jg5KywFEYKgMVELEGnMcgjLsmKjKy67eqxabPt+0bDUTC
         5Tjw==
X-Gm-Message-State: AOJu0Yx7Sgs1JIIV7YKDiGtuvga07iSCE6l2yiwM1oCSHRSpcGA5x/mF
	jsA2ainaxeUEM7GHMs1ITe9QS6geB+0ghHGvfsdkwgO4m9egNaIsHjpvy1zFgDZsfH3C0Iky08B
	fXDWakRKRBqdMQjeOgEXCEcOElrvlK4+PUFahAOt9mTrI
X-Gm-Gg: AY/fxX7J7dffAmh4hXrDtvPNcpxWa8cr/ulBTrrwEP8UEAU+gCfWtY+T4tst/vwc2gE
	6sP+6BgZgSV5n/IZUtApG3qXAFsrVvULPpzgPuwIvNzePS7Jpt+UIyeWyBK9dDHBdbrJ7TBQMun
	y/wjf3nesF3rrQUT/IW1re+9CRXCFIiaIew+Yb4RXP2Ur3HdMy68UaE7H/GvElfWQiZ7DYUfLEk
	6gTIrE70ojKVhgKWtH6QsB2GwAYMcSl03LahoBUhxjh+6ByCFzhdf8CrfohhtRgi/8JEZj/qiZ7
	G1tGFfLO6852+A==
X-Google-Smtp-Source: AGHT+IF+ishuCDoG+/2t4Kx0BQOJKh8r3azWoDVqvrx+cGg2EjCFkQSh4SG5d4cnfDcZ34T2kA2Eu/CGA9HAWnqih3k=
X-Received: by 2002:a17:90b:2251:b0:343:6a63:85d5 with SMTP id
 98e67ed59e1d1-34e71e0f8dbmr2539494a91.16.1766063871185; Thu, 18 Dec 2025
 05:17:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ilia Kashintsev <ilia.kashintsev@gmail.com>
Date: Thu, 18 Dec 2025 16:17:39 +0300
X-Gm-Features: AQt7F2rjDGtYLiB9yxUHCLzurhNxs_KpwwBf_1TeQWQ63IQp6uRvGmJCh2mYCtE
Message-ID: <CAF6ebR7PoBEpheSSjsSZqxUJh3yPeh1KjGTuGWsG0KwbuhJKMQ@mail.gmail.com>
Subject: Null dereference in ebtables-restore.c
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello maintainers! I have found a SEGV in ebtables-restore.c

It occurs on the following line:
*strchr(cmdline, '\n') = '\0';

If '\n' is not present in cmdline, then the result of strchr() is NULL
with a dereference attempt afterwards.

Output:

=================================================================
==17259==ERROR: AddressSanitizer: SEGV on unknown address
0x000000000000 (pc 0x5f3c49f0cfcd bp 0x7ffe7f3ebb60 sp 0x7ffe7f3eb940
T0)
==17259==The signal is caused by a WRITE memory access.
==17259==Hint: address points to the zero page.
    #0 0x5f3c49f0cfcd in main /orig/pkg-ebtables/ebtables-restore.c:79:26
    #1 0x70bdc8090249 in __libc_start_call_main
csu/../sysdeps/nptl/libc_start_call_main.h:58:16
    #2 0x70bdc8090304 in __libc_start_main csu/../csu/libc-start.c:360:3
    #3 0x5f3c49e2d480 in _start
(/orig/pkg-ebtables/ebtables-legacy-restore+0x32480) (BuildId:
31bd20ca69b3b280488319fcba61dbf2d259f787)

==17259==Register values:
rax = 0x000070bdc67001f0  rbx = 0x00007ffe7f3eb940  rcx =
0x0000000000000000  rdx = 0x00000e1838cd803e
rdi = 0x0000000000000000  rsi = 0x00000e17b8ce003e  rbp =
0x00007ffe7f3ebb60  rsp = 0x00007ffe7f3eb940
 r8 = 0x00000e17b8ce003e   r9 = 0x0000f2f2f2f2f200  r10 =
0x00007fffffffff01  r11 = 0x0000000000000246
r12 = 0x0000000000000000  r13 = 0x00007ffe7f3ebc88  r14 =
0x00005f3c49f71510  r15 = 0x000070bdc839c020
AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: SEGV
/orig/pkg-ebtables/ebtables-restore.c:79:26 in main
==17259==ABORTING


Reproduction:
1) Build the project with sanitizers:

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export CC=clang
export CXX=clang++

autoreconf -fi
./configure --enable-static --disable-shared
make


2) Launch with printf:

printf '0' | ./ebtables-legacy-restore

Suggested fix:

Check strchr() result before trying to dereference it.

diff --git a/ebtables-restore.c b/ebtables-restore.c
index bb4d0cf..c97364b 100644
--- a/ebtables-restore.c
+++ b/ebtables-restore.c
@@ -76,7 +76,9 @@ int main(int argc_, char *argv_[])
                line++;
                if (*cmdline == '#' || *cmdline == '\n')
                        continue;
-               *strchr(cmdline, '\n') = '\0';
+               char *new_line = strchr(cmdline, '\n');
+               if (new_line)
+                       *new_line = '\0';
                if (*cmdline == '*') {
                        if (table_nr != -1) {
                                ebt_deliver_table(&replace[table_nr]);
