Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185263D76
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Apr 2025 04:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745985990; cv=none; b=HSbd0EplP8ZtJymciaEYQQQC0K4/EFxSkZIy5D8Y8P2tk/HrbZBM/jK2QnKj7H8Tmo9lzfFEQxdZxwcCrDAlHKkE5qLiHIdsM1ImHErg6w/9jXZ4T0jp6uNDqvzvT/9IWEuN3VdkDBKQVTM5tNvsRAZ8blX2dTenOJ3zDG8+fEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745985990; c=relaxed/simple;
	bh=AWEAszHixMabaHum7/doBO6Caip/PQgW7hNPrb1Yb0c=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=C5N5gHzp4iznqFZP6agf2GuDVfyoEiGwDCh0sh03+pCeYe+sVWFwh4lvricT1KZJQIBPJtSdyF6HGG1xQviH0dslYtemdKVzK11vNE6Xiw55Dz/cgnvv8BdIm9x6p7djvtqDpIOf+/jlpxV2FOhEYb7OVKeUix5xkQOa5wDTXyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TxcMEIFs; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TxcMEIFs"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39c14016868so7060009f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Apr 2025 21:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745985987; x=1746590787; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AWEAszHixMabaHum7/doBO6Caip/PQgW7hNPrb1Yb0c=;
        b=TxcMEIFs8E1LfJwT3Q6cdK6qmdaqZlJphy95vouChNr+PYK7dIiE6Vch5vUERTc3ci
         P1SM5I9z/x9quNpdQOQOkMLqeZnBHCvpFXpMW8XSXt8CKhQBgUOvewQArZTz1xZs+DKG
         vlyrQ+5h0TIOphJ/dH/iSjjFszy3MDTny9zaqnTqMtbO9ZpBlPyuo8FlaOlT1Na7fBRY
         a6um63cs4NoG8be1pZROsO5DYK13BirpByvdDXFiMujlC+17+1xGj6uQVMQWWY64khlb
         080XmvGU9+lcm1fL4cTDvTkGcL5wlFgb8OgctUgdg7JBU/TjSNqKVdUD+i1ziKEtBVo7
         4xqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745985987; x=1746590787;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AWEAszHixMabaHum7/doBO6Caip/PQgW7hNPrb1Yb0c=;
        b=h+86NptUIubTXVd+95lK79WD9k7DuFe7n/bUix+OyMcbyfC4TdWs5ExjhaP6tkAxiE
         FCQ2GnWa2JqaKtCVUzw5FOZjp80jwlhsxpWSSils7NlCMP2lSnGLKybYTSVGrEudun9R
         qa8E6X254XnS0Qcwl2qhNQZGVSnfJGNwrlOt38quPhdhvyN30VRcOTgGq87lIg7uowI9
         YaGCNS9EDpzFECLaBj6VigVfAp5I97UyPWtck4X9KIwkm9P8gXUq5BRL2tZL3XicBGcX
         4KYymbSj9uRp3BBk3I063M7PwIeEXT+TrZErJ9Es/0Oma+dWGaTewuicqAyXwkxeeOZ9
         s7Dg==
X-Gm-Message-State: AOJu0YyNIhXvfVMxAv1V9tizC836YpQCaWEWsiRg4d7Mc/a5H+fAdNfy
	j/XT6m6FJMFanxzI0jGE74UhOJj9DuI28JkCnVDQzGIF1XaEOE33ID7Prg==
X-Gm-Gg: ASbGncswF3Rp7Oc+iLixSigmYj2hjpQJtHI6DrqWAbpvLv1jeXmtGDIUE6XO1ouHrsK
	AzPyfqxCjqrv9xaz+XJKLikENwcuXRPcxsGQl8TBAS55MFkBHRZOhDEjGICpspcFklH09d2103i
	WIGeyQTBMXuj4LLaFOBlV1pQ7TwHWQptY8rvfPBQxj0DT5U2T32CZDNu5EqKpKzOhigF8PWcO3V
	P9T0mwqEGhag4npaubEAjntxkwNgF2VDcgZWXiQDrfwxW+ntB3FFnewX0oFRCkrYP+sIihpDGw2
	o1RTuTGySpEZGtnEGWXJrgg=
X-Google-Smtp-Source: AGHT+IFyFkHFqAVoSV0YL8/cqniIkYxAVlGG6DOh5H69AYeXKaBFhYrCFc1ktCqUFLg7hftkBzpwIw==
X-Received: by 2002:a05:6000:40df:b0:38f:2766:759f with SMTP id ffacd0b85a97d-3a08f7a4016mr1059399f8f.41.1745985987101;
        Tue, 29 Apr 2025 21:06:27 -0700 (PDT)
Received: from ULRICH ([197.234.221.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a089edeca6sm4235748f8f.40.2025.04.29.21.06.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 29 Apr 2025 21:06:26 -0700 (PDT)
Message-ID: <6811a1c2.050a0220.2c559.fa5e@mx.google.com>
Date: Tue, 29 Apr 2025 21:06:26 -0700 (PDT)
X-Google-Original-Date: 30 Apr 2025 05:06:27 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: theodoseraymond5@gmail.com
To: netfilter-devel@vger.kernel.org
Subject: Privatkredit
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64

R3V0ZW4gTW9yZ2VuLA0KSWNoIGJpZXRlIEtyZWRpdGzDtnN1bmdlbiwgZGllIElocmVu
IEJlZMO8cmZuaXNzZW4gZW50c3ByZWNoZW4uIFdlbm4gU2llIMO8YmVyIGVpbmVuIFBy
aXZhdGtyZWRpdCBvZGVyIGFuZGVyZSBPcHRpb25lbiBuYWNoZGVua2VuLCBzdGVoZSBp
Y2ggSWhuZW4gZ2VybmUgenVyIFZlcmbDvGd1bmcuIEJldHLDpGdlIHZvbiAxMC4wMDAg
YmlzIDUwMC4wMDAsIG1pdCBmbGV4aWJsZW4gUsO8Y2t6YWhsdW5nc2JlZGluZ3VuZ2Vu
LiBLb250YWt0aWVyZW4gU2llIG1pY2guDQoNCkJvbmpvdXIsIA0KSmUgdm91cyBwcm9w
b3NlIGRlcyBzb2x1dGlvbnMgZGUgcHLDqnQgcXVpIHLDqXBvbmRlbnQgw6Agdm9zIGJl
c29pbnMuIFNpIHZvdXMgZW52aXNhZ2V6IHVuIHByw6p0IHBlcnNvbm5lbCBvdSBkJ2F1
dHJlcyBvcHRpb25zLCBqZSBzdWlzIMOgIHZvdHJlIGRpc3Bvc2l0aW9uLiBNb250YW50
cyBkZSAxMCAwMDAgw6AgNTAwIDAwMCwgYXZlYyBkZXMgZHVyw6llcyBkZSByZW1ib3Vy
c2VtZW50IGZsZXhpYmxlcy4gQ29udGFjdGV6LW1vaS4=

