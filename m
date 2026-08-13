Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85252485518
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786640383; cv=pass; b=VBtp0xfC2ZPoKNdrKarE4kv/Z9m3JWWn+3AiVNiBuD3+aY/fOEGZ5ApKi1O7eiQfeB/cFKWwStK3myIuninDYbRvp8sOIuIMMwh7ZY5UtpK86u856QVSPBQG0USbkQ4drHpCvMqaZYHGl9P9JXH3TjYisRIXnyHbyop1Du+VoTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786640383; c=relaxed/simple;
	bh=xoBdWEtJTPlDLVyNbMab7t+/J7TUwi1z7zZtLQ6klVM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TQIHGXSF0Xu9KIlu3q3OQUMoTUZcz6DxAwhfSMhY28Xp6xN8QCFSWUVtBpE1p//2QTxAVdstkpgKVyYZC42pP+Qcv/TLVRwzHVMVyUG5+WzzDMp9SDgjoj6Tr9LjqCMOJfD+R+dO3DNihzBuZDj+LgMOqp0F7oiA3yW8uGNKcQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eoe0mBVp; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eoe0mBVp"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf50c6f235so2377735ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 09:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786640382; cv=none;
        d=google.com; s=arc-20260327;
        b=fHZX84ARqvi7DQmiPcfR7Cf/BpsXwsvi9E/gYkaO/x6IRdsg/k48lLVPhZvFmhWUlm
         hQk3ttCyMsfeUjvmw7wkSdrXq8LT+rXd27lT29GPKLUWliFW4sVtVYg/gtvz2gj1ottE
         Kyq9ic2cIEWGGy+VZKaPOZkT5LLdcxZCOcJ7ZpALCXXxWH4En8tsxqR+C1qFRcjCdUe9
         l06pE0X+T4ZAGOM4CAuqpOp6aStkSrGprHejXP2PIwNRkwjTCTc/JMtzgtmezpWJFyPP
         EBify83IKr1NOTwmCp41tT2tc4g5rEdbY3v1kAUElsDoixKsDAtO24zGVqJ0XL1bQ5tl
         rjwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5PCXtpD2RlzIqld0EEK6YS2HyVzJj+XySKEtASyVQ20=;
        fh=bfTnhp/QuOXYdfdZIc47Hwj9C6MwBViq6ABSv2EgpV8=;
        b=WNUjHwmD2dW90Hn0A7ik3Zf0y6b+h3xIJeU/pxchM+cb14HwzSkXOLSnBeXeNBT2mS
         0z/FEVN0YwJcrDBD13h1J/sCK0ilBdVGfRRd8KHSPUDhuOukxctrJTiPfiW1CINkLz0N
         JgfiSxScA4Tfnzw5fTPxBIrvvZsmB4p84zkA/DwH1khSmo3WmNXAVTbSBjC8AQdTlAtC
         kKG6I9TQuGS3+XIfqpM95Q1VGnodMFup347rjYi8BPg5+M9/E171MNUGV+VMj+pD2gsF
         HY93e2GHlvQ4ivwbWuTN63vtKi06s8oJuOuJZc5a2H85fFfFMrGPx9bPKhKzrusGMclu
         9puQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786640382; x=1787245182; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5PCXtpD2RlzIqld0EEK6YS2HyVzJj+XySKEtASyVQ20=;
        b=Eoe0mBVpeSDdi7T3XLAxzyHYM/od6gilK0FfqVVaQnZJYb6FAffj76MwK44CEVzxo2
         lXpLCcfWLZ8F4f6y7n9iprcEXpf/LB/QinAUhfqR85T/QRXVJw1zfPbfA213B4qaLDYp
         atlsAA3O4a09qU+CdwO0K84bocjkDq/yaCphvjK/i9Lm2miLaRe3Ms3JgWyx3fyTMYZY
         G8l+iTgvoJcNCBROZuHQp6E+SHjZpCP37JK8UdS4tVmvPl3nhciAGcSLLMV3Em4vNSGf
         gsekNTEOAczWdL16NLWztGmQ4GbXSqn9UvXhmLELIa905JDObZu1vX4pO6TOTFFZLVKN
         66iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786640382; x=1787245182;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5PCXtpD2RlzIqld0EEK6YS2HyVzJj+XySKEtASyVQ20=;
        b=MFKEWaYWZScFD7NzJWXgAKkr7rR79+SMZg9r+MqAyC114Ck+UI775tFdrPgeb46bQg
         FiWYZ4Ds1X9U0fP5zSyLqNThxG2soIweBti3VjwpDKp5NfLsedRaTmFN4Hk16vTOhzI4
         3ZLnkDELmuW/8jpCeM9hpON0ssp1tSZk2qQI4VSgAPvoPZttTKRvRD0zN7HrOnF72gBT
         rFPqecb2heCU0dZJ5XNePaRi9wesrHfn4TzlOgAq4uL3YUN8TwXoCMNP8poc/JOiL6Ql
         WYNyyNTl6eHp0xWM7gJwfiP82Heqzu0NFHFL0cC0EUoU93UTHy8YhBQGVO+blVDF7mjF
         a+xA==
X-Forwarded-Encrypted: i=1; AHgh+Rp1nis25rY8po+pwrvK6YsuJTckaJKOZZ7bZcGvPJpWipZgYxa9UhXvCxKTqiLeD/VacTk2PmO3fYJ6LNNd2D0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWRSsnDij6uov4WrlTD3K9Ke6RlVJcnPuh3bbePRS3e8ZVQg6b
	24JK3JVhZmxTEhP63p9VEygUfHscfOHaSn5KdTu4EmP2OHS2ic6ZzNHlrsUCAnGjK02s1A3TZSJ
	cszlG3nJyFOg3V2iPuikg1y6zZWzrlPI=
X-Gm-Gg: AR+sD10J9uy8eaiHB6B/PM67cRVQLA/2h6Y1qFTyybgvV+09yqiTMLR7xUIv/BzZqql
	LKddo/yNelHcQv1YXZyUXplw7IVMucX5E9BjiKrmoAwyTKQHLTgCBbnOBtOyNoPIMOCZv4/+wS3
	loSsWYlZCldhqFOCbrl2W+76TVP0Yhk5tJQo0WMT6wvmY0gg4RrLBrWzduzf07tv5SVNjVPXUsg
	5lA0+31LHMDlMZOmd5cgsMabL0VMF88AGvKhJyk0AH0oWCWLpejx2NOMrcsiP7Jsh6IQjCz6POD
	8TSNc8K+X/KI63zmIBQ7i7PxCj/2akoGsD/uM3egrkLMTi1XkZkH/mAPaXhs3YEjd5VBw3O8Uwk
	XMiVQIEQhedi0YO4n1zXITRHPsdRv5te5ww==
X-Received: by 2002:a17:903:40d1:b0:2ca:304:f93e with SMTP id
 d9443c01a7336-2d37ebc2df5mr97346755ad.22.1786640381605; Thu, 13 Aug 2026
 09:59:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joas Antonio <joasantonio108@gmail.com>
Date: Thu, 13 Aug 2026 13:59:30 -0300
X-Gm-Features: AUfX_mwucnYyIHD3IqRl-RHeVt6sDZhmNV6nBBs18XEE_p_RDm2X2qFPzlzle-s
Message-ID: <CAOCBhwHbcnuzP1fz=JLqeRA0xNU=QdqppeRy2y=wqhJR6k_VRQ@mail.gmail.com>
Subject: [PATCH] ipvs: fix integer overflow in ftp helper port/address parsing
To: horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org, fw@strlen.de
Cc: netdev@vger.kernel.org, lvs-devel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ip_vs_ftp_get_addrport() accumulates decimal digits into a __u16
(hport) and into unsigned char (p[]) without checking for overflow.
A crafted FTP PASV/EPSV response with an over-long port or address
octet wraps the value, so the helper configures the data connection
with a truncated port/address.

The netfilter conntrack FTP helper had the same defect, fixed in
commit 2b413fc689ba ("netfilter: nf_conntrack_ftp: avoid u16
overflows"). Apply the equivalent fix here: widen the port accumulator
to u32 and reject values above 65535, and reject address octets above
255.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: CyberSecurityUP <joasantonio108@gmail.com>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index b315c608f..9e3e005a8 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -102,7 +102,7 @@ static int ip_vs_ftp_get_addrport(char *data, char
*data_limit,
  char *s, c;
  unsigned char p[6];
  char edelim;
- __u16 hport;
+ __u32 hport;
  int i = 0;

  if (data_limit - data < plen) {
@@ -144,7 +144,11 @@ static int ip_vs_ftp_get_addrport(char *data,
char *data_limit,
  return -1;
  c = *data;
  if (isdigit(c)) {
- p[i] = p[i]*10 + c - '0';
+ unsigned int val = p[i] * 10 + c - '0';
+
+ if (val > 255)
+ return -1;
+ p[i] = val;
  } else if (c == ',' && i < 5) {
  i++;
  p[i] = 0;
@@ -222,6 +226,8 @@ static int ip_vs_ftp_get_addrport(char *data, char
*data_limit,
  if (!isdigit(*s))
  break;
  hport = hport * 10 + *s - '0';
+ if (hport > 65535)
+ return -1;
  }
  if (s == data_limit || !hport || *s != edelim)
  return -1;
--
2.39.5 (Apple Git-154)
