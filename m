Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E40129E72
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 10:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714472339; cv=none; b=UOjudMjHiS3/IKD98/t9xKZIFGLwrulNYFVgfyY6p5+bZsEnzP2TPFN9C7zg6WVikX5aIQho39xJn4X6x+jliXm/SIYE4uS0CIDVLpI1ZstD9SFszMaI6JRwS+ZIuRmSCERmTHlgUf7DFl3gcxL3McD75L3Vbt+GmMycWsY6E8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714472339; c=relaxed/simple;
	bh=WTP0kuJFFCGr3B5NIZ2LEfNN50rejOlAqs5ohmjZzVI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=TB8RUHfIQzx7lEGMgs2HrPtditcyTFUsb/65ZNm1JEp4U2FMFuTw+CfOgI1p80nWYF3KZug53FiJ/4vB21/xlGzNthj1fOIp/DWUGZOKO30R+4ep/1SXAaCYZ1QUXqJLcupHMiWNiTPUYKHSvgA0t5hKd2dHqF3NAtbhCWSSqcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SeYDR/kz; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SeYDR/kz"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a58e7628aeaso376633266b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 03:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714472336; x=1715077136; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rrFZvqDAEpbT/hpuiz/5P/17Uv4VVLsf6B2bRkojVa8=;
        b=SeYDR/kzfMAEE7VdkiI0e3jt1SuQeBag9pcJfVvavMH0Get4hU9605RZks35gOqkQx
         eDuaIbZXarHZbL2zthnFfrfUiDLttCPs3xOWi9LjJJ1FDPqz2OCSoUhpUlzATm/4Sqk1
         c+JRaD+cMym3/SYxyBxjFE/LypqtH13JNgK3FLj9N1nY8/WlFJvaO+uk5HjxtTaE6sKM
         HG6XcWCI3tw9ZBf0R4lDwH5qsGoyF8ukY+bfzNnlnVXBVw/zy/OlIDqh5FXwn5lfX539
         ubgjTnUtahHCCqDU+glEHrPJG+UuOctOLBAsNpzN5+roU7TgkqwsY8PLF/tT88ScBnFr
         wDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714472336; x=1715077136;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rrFZvqDAEpbT/hpuiz/5P/17Uv4VVLsf6B2bRkojVa8=;
        b=NEgU8C3UV43jDQ4OEfwf49vjmvQA2YC6sXhtDVkaVTSCZOMPacUkPNxQqg+I3oChjv
         BiklWEQs3PIZNCDEDT9XC5QQeDM9CYtcSdGQFvcgCvaHq49TslJMbaLbbAeex5t5bKti
         kpdluCclZR4lf3UFz1WpQyzGqEhdKLcB0UZOez9RkaZNUIPtoI9FXzF/bkEl2qi9FiBU
         cJoPRAdOKsq7HPZEnIsgAaC0V3Rk1ejL82F57lAF3ShIJk+564aRZPKmPIlHsoaoQTWF
         JyQsB6xxaUflxHRoJbtY4YQHwXdeqjonnG7ZtU4+uDOjenN/k2RZLN1g4rjQtn2x4N/W
         ETqQ==
X-Gm-Message-State: AOJu0YxAJz7s2321cXab0Zz271OtleiSnyWJNtfo+YJOoaQ9TdKZ8k3e
	G74XUNZmwroIG1tcDAoaVimlBaJKTsaki0XTuUhFjfoBOutuZOE7ZZ7+3tbf5XlVkwoTFoIuXiE
	fVmzy+8+Wra/lQjd16e+MMze3xbakMeNE
X-Google-Smtp-Source: AGHT+IFvYIxc/xLZT2Iy0rM10F+e53PbHRpSHPTjbBsIkCUr5ryxMaLcuVUuEx2VAjl02z8OQPX6W0KR3xkFXqD4Nrw=
X-Received: by 2002:a17:906:fb17:b0:a58:e74b:7e16 with SMTP id
 lz23-20020a170906fb1700b00a58e74b7e16mr1633484ejb.46.1714472335516; Tue, 30
 Apr 2024 03:18:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Evgen Bendyak <jman.box@gmail.com>
Date: Tue, 30 Apr 2024 13:18:29 +0300
Message-ID: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>
Subject: [libnetfilter_log] fix bug in race condition of calling nflog_open
 from different threads at same time
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This patch addresses a bug that occurs when the nflog_open function is
called concurrently from different threads within an application. The
function nflog_open internally invokes nflog_open_nfnl. Within this
function, a static global variable pkt_cb (static struct nfnl_callback
pkt_cb) is used. This variable is assigned a pointer to a newly
created structure (pkt_cb.data = h;) and is passed to
nfnl_callback_register. The issue arises with concurrent execution of
pkt_cb.data = h;, as only one of the simultaneously created
nflog_handle structures is retained due to the callback function.
Subsequently, the callback function __nflog_rcv_pkt is invoked for all
the nflog_open structures, but only references one of them.
Consequently, the callbacks registered by the end-user of the library
through nflog_callback_register fail to trigger in sessions where the
incorrect reference was recorded.
This patch corrects this behavior by creating the structure locally on
the stack for each call to nflog_open_nfnl. Since the
nfnl_callback_register function simply copies the data into its
internal structures, there is no need to retain pkt_cb beyond this
point.


*** a/src/libnetfilter_log.c    2024-04-30 12:45:41.974918256 +0300
--- b/src/libnetfilter_log.c    2024-04-30 12:49:56.774643783 +0300
*************** static int __nflog_rcv_pkt(struct nlmsgh
*** 161,171 ****
      return gh->cb(gh, nfmsg, &nfldata, gh->data);
  }

- static struct nfnl_callback pkt_cb = {
-     .call         = &__nflog_rcv_pkt,
-     .attr_count     = NFULA_MAX,
- };
-
  /* public interface */

  struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
--- 161,166 ----
*************** struct nflog_handle *nflog_open_nfnl(str
*** 255,260 ****
--- 250,259 ----
  {
      struct nflog_handle *h;
      int err;
+     struct nfnl_callback pkt_cb = {
+         .call         = &__nflog_rcv_pkt,
+         .attr_count     = NFULA_MAX,
+     };

      h = calloc(1, sizeof(*h));
      if (!h)
