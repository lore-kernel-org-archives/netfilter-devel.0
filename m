Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BB529B777
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770903334; cv=pass; b=fzNdEq/FvK/2tzfBB991jR7HqLLNCz6E50bbgFy60xlD9ykLxu+XS2/a5zeTw15n1OLGnowHe7md9feIp0gEO+B2E1DRSFlTXwUYQOZDemqtph4HHvS2tBdrFFumrE58NRdwrizMCEMLGsgZNI83klmE+H4d9d5918VSVom82HI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770903334; c=relaxed/simple;
	bh=aRFWnn41uPVrWaWT4sT3FguV8XWmMp5HPBY6mlWoyZ8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Boka1pn/1ZfbQrVwauM7vKRZhR3mX3pBCafYGImWtL2z6+oFmqC3AA+C6h7I0yeKEIy0Jls1jCTvS3lyOKbJnAPn6LdbGVNs4JgcpEomPHjCYndnMOLjl8zR7y4xaqsCcrUKAgTNj6AH6YabuqSrUHQVbc7BVMoHXExcwdz2FNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai; spf=fail smtp.mailfrom=sleuthco.ai; dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b=g5tIR2n1; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b="g5tIR2n1"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-794911acb04so65506207b3.0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 05:35:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770903332; cv=none;
        d=google.com; s=arc-20240605;
        b=Iho9S0LcJ9RIfZcIo7ERximGnz1uwsvA9ayMLpAX2bwz0FrZrnH78eG4WQ8Y8eO/Bm
         80Fx6fNJ0zN1pzAmYQ9wQ2tFAogZEmj5v0tgiqIM9ycoEJdZDrRMP9wGHlaYjoe3FW/m
         W8GMQcf3EKRzc0j5skWtJnWTioeisynVOTOVDc3g+d7frC1NUPacWn9V61ndEHvA3q6U
         HWS7ipBzeM1cyUbyxv7dSqahDAukXfb1/610Ohbagp9sFWjQynnHSGljraLAyJsV5+cy
         0N4EsJoV/kTDcqXoUt5Y0KChg2enBk/8NGVWpLXl5hC9PnUNiWZIEbu2xSAwqGl8hg7e
         4Tdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=9659IzzzoA2vuxDtcj2Lp/qWrzDxt9i63sO/TfwF2So=;
        fh=94XZ0kbhVmGEa7CVQQn7x19t/0l9HgwgaJK+mk7Jllo=;
        b=ZWzduRJ9sP1NMu5BMotbg/l9SYD0G6n+2GW8MkvmnJ3Nrz9VZLFTBjwf/kB73ikHB8
         FzLBijVvExYgjEZ+MuBvlu7y4hBolP9xITh7W3lup/hmtboEVJX33bztoTPCnW+K+ZWn
         CKXZoHF/vA3xRX/P8Nq/Y9kKTMdOgwKkvlzr8CHL6xmBxUQjWxfTAwJ0cajHONRlUosw
         18BRO+TaF39+aR52a9VWzB2eN+nQqdREp96g4bfG9cVLbRnZzK0092ZKJMJYyeuBUKxC
         YUIvbTIv71MLJaf8hioqtE6ZtfxF2hmAKKCgaVKC6KxjGsSNEG6+QiytODuxG0LdNCwT
         1CiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sleuthco.ai; s=google; t=1770903332; x=1771508132; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9659IzzzoA2vuxDtcj2Lp/qWrzDxt9i63sO/TfwF2So=;
        b=g5tIR2n1Hqkmy7iU55+37alNIhr8KFAqrfyRRY610W3bQdvyelQvokSlnHYZ5KE/Jj
         J5TSfGSYj9PaYGn3eRy9iWBAbHPjgUFlB9afmwC9E/i2c9kve34wkRmu3oAchIe8bmMl
         o4JXJs2sqj9XhqKRw3qvISg8hgJQvJCk4ImuK8EHmYyESOOzw0dc6HbS+NKe23IGAEu9
         hKMSAnGUZcO+fblTsMvVom45Lq4Jvm3uP6gmRduKbKUu7eK/BgbtE/QbEWTTILdrWZQZ
         /b6tlLU8ymWi+YhN16rcIMPNqprOoJoVYTRAOtoHDsOo5+/yakOkzbvsJ79yeHKZnqle
         vQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770903332; x=1771508132;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9659IzzzoA2vuxDtcj2Lp/qWrzDxt9i63sO/TfwF2So=;
        b=PZbmBM9ZxGJjn9TZCr0NQFDA/EYONgwvZCbsHhZD2xSek0T/EqZR2Rsa4hnJMVZB2V
         qwSDyqa/EfEBsbRR++X68GFX1o4/m+GV3/6l08g02Ieogf5ybuT6q0KwSqM/kg1UiJuz
         Ml+BpSKpt2+M7IpUjtzBo+gz9O+y3boJRSw6WfOJH4MDcmCB9YM3xk/NVp3KrjLO2v/Z
         UHke8MEWKfW+R+TqKoUYKyka6unefjsVop2SLvs9werbasBOQDgNLf3etok4yPWju4Fo
         xoMdbnhs3JMFTlBG/4z79Z+/IN33dx8LpHMc0FTnLIKWy8BQO2Ucs3UJFncCEdAvj1fC
         /Uug==
X-Gm-Message-State: AOJu0Yy9tExDfnjnjY7c5SisNL1HlClaM61ZABXDEZJR3Fhal2WHtddm
	hKC8+d5NCEhsI0IE/BqE8wMo5koIVCPoZ1sWtZL3vyLw7JlXOnPIDl4G8nD999darRpy0te6blP
	o8r8pFPab/cYfuhvA+EF2OdtPEuM4pfTi7rodgd6hg4icPRkqij4hij+TbI8=
X-Gm-Gg: AZuq6aLj7NC3w9Ud/LazJy/SUdjNLd30ekMHITozczn2TAsn3T5KwlujvKk2LRzZkzF
	A5KBbwuMfuFutk1LqqY4x0Y0o1ojmW5kNkgCc1KQoZm1wrw/anyooxp6+fNSQ5dUFubgoHcH/Nw
	Dwyeg8AZ2wW7CbpxnatwNXyJZZW67E8iHKZTdwRsz5xNGnELdfrwcWmZOcLXQaYGwVoERqBrvvG
	EwoIuUFBnobH9Q3FFD4uDJatdWx28UWMKulqcaSWrUPB7pLEQy34GaDkbTCKjEvNZs1I53M3zyF
	eX8Vkp6I5MSs7qc+g2h8oiYk+XbuaRlJExOSAU8=
X-Received: by 2002:a05:690c:4c11:b0:794:b98d:b395 with SMTP id
 00721157ae682-7973765876amr26770607b3.49.1770903331519; Thu, 12 Feb 2026
 05:35:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alan Ross <alan@sleuthco.ai>
Date: Thu, 12 Feb 2026 08:35:21 -0500
X-Gm-Features: AZwV_QghOVTD3S_z__375356uFHSPewBGrxY5vAzFy-nabNuThwUbpYO80DcJKM
Message-ID: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com>
Subject: [PATCH v2] libxtables: refuse to run under file capabilities
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

 Extend the existing setuid guard in xtables_init() to also detect
  file capabilities via getauxval(AT_SECURE).

  Some container runtimes and minimal distributions grant cap_net_admin
  via file capabilities (setcap cap_net_admin+ep /usr/sbin/iptables)
  rather than running through sudo.  In that configuration the kernel
  sets AT_SECURE and the dynamic linker strips LD_PRELOAD, but
  getuid() == geteuid() so the existing setuid check passes.
  Attacker-controlled env vars (XTABLES_LIBDIR, IPTABLES_LIB_DIR,
  IP6TABLES_LIB_DIR) still reach dlopen(), allowing arbitrary code
  execution as the capability-elevated user.

  getauxval(AT_SECURE) is nonzero whenever the kernel has set AT_SECURE
  in the auxiliary vector -- this covers both classic setuid/setgid and
  file capabilities.  Exit with status 111, matching the existing
  setuid behavior.

  Signed-off-by: Alan Ross <alan@sleuthco.ai>
  ---
   libxtables/xtables.c | 5 +++--
   1 file changed, 3 insertions(+), 2 deletions(-)

  diff --git a/libxtables/xtables.c b/libxtables/xtables.c
  index af56a75..f872cc6 100644
  --- a/libxtables/xtables.c
  +++ b/libxtables/xtables.c
  @@ -31,6 +31,7 @@
   #include <netinet/ether.h>
   #include <sys/socket.h>
   #include <sys/stat.h>
  +#include <sys/auxv.h>
   #include <sys/statfs.h>
   #include <sys/types.h>
   #include <sys/utsname.h>
  @@ -331,8 +332,8 @@ void xtables_announce_chain(const char *name)

   void xtables_init(void)
   {
  -     /* xtables cannot be used with setuid in a safe way. */
  -     if (getuid() != geteuid())
  +     /* xtables cannot be used with setuid/setcap in a safe way. */
  +     if (getuid() != geteuid() || getauxval(AT_SECURE))
                _exit(111);

        xtables_libdir = getenv("XTABLES_LIBDIR");
  --
  2.43.0
