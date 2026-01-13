Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E4130C616
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768333511; cv=none; b=pIR+7QV9lkw8j8Dyt5O8WMsmOnwt/Cbrt9A8O9rf7L2vpZ2GhGsg2PPha9+GayCKQJMyWyD6XkyaihLBqyXs94on1m3tzYZlhV2gF8P1LG6Cb9kdMBezNzIQ8Tgo8c30JdT/rUUwx5wwuv0G1h9dFyHFfj+8KiKWmtG+QEsYGDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768333511; c=relaxed/simple;
	bh=BUigQmv+IS7SNf1S/5NL6itraOCI8E1tv4UT92H7zMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XDEBW1i/Dr2ijGSPeteRE0hlQT83Xdw1SD3JBChbZcesrXemIWwxRCFxaI7JfW5kbqMM8VqvTBiITo6m6pDooVIYUjdX0QYM067hjhiFmlqfBk1Eekwh9++pkUEAoGI2IsQnlkXNn1oUW5zGuCZNdsamjHO7xfDO3P/On1DygxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aPiPLF4i; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aPiPLF4i"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-93f542917eeso2617108241.2
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 11:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768333509; x=1768938309; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BUigQmv+IS7SNf1S/5NL6itraOCI8E1tv4UT92H7zMA=;
        b=aPiPLF4iQFJ2frMo536J5NyvXV+rKXUnT5jUXc5bIHceaTY9lF7rfKPN1GTpvAFe0h
         xxdsW+P7DTXuQ1VJvFIzRN0Tr6/vRuvVnTpb+WLqsDog1tSRUONBveJLJBv8vXjI2tfs
         glWSoCgA3JCBPYAfjmnwl9VOy8pu7ZU+K7mAU2Rc0pOutQC13kKNTODyddR1cyvPlDS0
         5fzeLxOphFObZN5LuB22ugEXxQ5BNMBDQfWYicdhkjNGcnC9sj7UVnK8kAOWkKsihiaK
         AWdwTayv4k1Kz1cz3e0Y32tb1E8Fkb/doSr0lIErUVf4eLVuTAotOerkI8X6nTL9t+9X
         jmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768333509; x=1768938309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BUigQmv+IS7SNf1S/5NL6itraOCI8E1tv4UT92H7zMA=;
        b=GQF5Bjft5XuxIVw+E0wj5WHedVtNUN4RNfkfRRJZ++H+RpOgfI0q4ctqnPtGz9Hnrn
         0ULxymsm+QRH1zrzmueoxC9OExt5y8KSSkJ5PRwLs5EyLzIAlYoFi/BRgX5C1UvZc5PS
         ge39TwX/Ootv4Pm+qFGAaz3vBpOTL+ATHGXBQJEjGKePrDiFgX0t1ANS8q+rokMeG3SR
         Kd5jtCWzDQRMimRTxT7Y7G/7neDRSSEA/fQTCCgjTVy4/Bo5nfq4GqP/kKqczZlZFkc3
         +5gBo4ozuzSkIerXOJzRZkI8vWOk2iKqCwnMu2YQTgXnoza0xrgQpatstk/lJamR8CGd
         Pf2w==
X-Forwarded-Encrypted: i=1; AJvYcCXgxUj9w3b4ZsoY/0sjH7vJ6/qNTzFyi7IYEayaC2iUZO3pPDSsNnWN3dP2XeszdZ0w+tSw0AqjjDO/mSO7QIM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/t6qgjGhf2xeW4fvqv2IbSBgnkwbwZ3dP0YsGodY4S+7Sp3oq
	JcmwFpLqaQukU7zZZxwmi0pJP/e1ctExG3zY8ajA6xCHOxtKQH7oBo4y1aeVzTdx/Qf0yfmkUhG
	V1+lxurHG+C/eXKctaYMkr8xDZUs3c/w=
X-Gm-Gg: AY/fxX6RqfPW/gUeln9BhM+vneN3DVQAZiZFU1s+PtXY1XpqMODLDdm8emOCQhbxHbT
	v4VMHE0xswNJ/fuRctn2lPxqF6ZYUOeuwWitekwOOsG78Bl/bFz6j95HITIyX+AkXke0IVJaK+o
	74VDmDTlvCgBxs4ZTuCSNwX1i9u+2DA7Kv2nxLgmAff66spe8qNSUoAEb1ZDOEqUt/ytU8y2jj+
	aeSnCiWTNMV2IhqyLaj3Y5fY9jdo4oMwsVbtBVQD7C/JYWYSHDBzY8Da+HnJHdj2zUwQ27asdQ0
	VO9FKOW4flfItEKJhhYZBGBbLv4p
X-Received: by 2002:a05:6102:3913:b0:5db:e6bf:c4d7 with SMTP id
 ada2fe7eead31-5f17f5c0ffbmr152415137.21.1768333508926; Tue, 13 Jan 2026
 11:45:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <20260111163947.811248-2-jhs@mojatatu.com>
In-Reply-To: <20260111163947.811248-2-jhs@mojatatu.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 13 Jan 2026 11:44:57 -0800
X-Gm-Features: AZwV_QghuBmNS2SHRIXNqqie9Rli8ChJPn_4i1AP_4fpkgiSVL0_Wio5jYQkhwU
Message-ID: <CAM_iQpVPnwe=YqZubeUFy78ym_TM-R3qvx3u3ydN0t6GbFnmgg@mail.gmail.com>
Subject: Re: [PATCH net 1/6] net: Introduce skb ttl field to track packet loops
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBKYW4gMTEsIDIwMjYgYXQgODo0MOKAr0FNIEphbWFsIEhhZGkgU2FsaW0gPGpoc0Bt
b2phdGF0dS5jb20+IHdyb3RlOg0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9za2J1ZmYu
aCBiL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCj4gaW5kZXggODY3MzcwNzYxMDFkLi43ZjE4YjBj
Mjg3MjggMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCj4gKysrIGIvaW5j
bHVkZS9saW51eC9za2J1ZmYuaA0KPiBAQCAtODQwLDYgKzg0MCw3IEBAIGVudW0gc2tiX3RzdGFt
cF90eXBlIHsNCj4gICAqICAgICBAbm9fZmNzOiAgUmVxdWVzdCBOSUMgdG8gdHJlYXQgbGFzdCA0
IGJ5dGVzIGFzIEV0aGVybmV0IEZDUw0KPiAgICogICAgIEBlbmNhcHN1bGF0aW9uOiBpbmRpY2F0
ZXMgdGhlIGlubmVyIGhlYWRlcnMgaW4gdGhlIHNrYnVmZiBhcmUgdmFsaWQNCj4gICAqICAgICBA
ZW5jYXBfaGRyX2NzdW06IHNvZnR3YXJlIGNoZWNrc3VtIGlzIG5lZWRlZA0KPiArICogICAgIEB0
dGw6IHRpbWUgdG8gbGl2ZSBjb3VudCB3aGVuIGEgcGFja2V0IGxvb3BzLg0KPiAgICogICAgIEBj
c3VtX3ZhbGlkOiBjaGVja3N1bSBpcyBhbHJlYWR5IHZhbGlkDQo+ICAgKiAgICAgQGNzdW1fbm90
X2luZXQ6IHVzZSBDUkMzMmMgdG8gcmVzb2x2ZSBDSEVDS1NVTV9QQVJUSUFMDQo+ICAgKiAgICAg
QGNzdW1fY29tcGxldGVfc3c6IGNoZWNrc3VtIHdhcyBjb21wbGV0ZWQgYnkgc29mdHdhcmUNCj4g
QEAgLTEwMDAsNiArMTAwMSw3IEBAIHN0cnVjdCBza19idWZmIHsNCj4gICAgICAgICAvKiBJbmRp
Y2F0ZXMgdGhlIGlubmVyIGhlYWRlcnMgYXJlIHZhbGlkIGluIHRoZSBza2J1ZmYuICovDQo+ICAg
ICAgICAgX191OCAgICAgICAgICAgICAgICAgICAgZW5jYXBzdWxhdGlvbjoxOw0KPiAgICAgICAg
IF9fdTggICAgICAgICAgICAgICAgICAgIGVuY2FwX2hkcl9jc3VtOjE7DQo+ICsgICAgICAgX191
OCAgICAgICAgICAgICAgICAgICAgdHRsOjI7DQoNCkluIHRoZSB3b3JzdCBjYXNlIGl0IGluY3Jl
YXNlcyBza19idWZmIHNpemUuDQoNCiAg4pSM4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSs4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSs4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSs4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSQDQogIOKUgiAgICAgICBD
b25maWcgc2NlbmFyaW8gICAgICAgIOKUgiAgICAgIEN1cnJlbnQgICAgICDilIIgICBBZnRlciBj
aGFuZ2UNCiAg4pSCICBEZWx0YSAg4pSCDQogIOKUnOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUpA0KICDilIIgQWxs
IGNvbmZpZ3MgZW5hYmxlZCAgICAgICAgICDilIIgMTcgYml0cyAoMyBieXRlcykg4pSCIDE4IGJp
dHMgKDMNCmJ5dGVzKSDilIIgMCAgICAgICDilIINCiAg4pSc4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSkDQogIOKU
giBDT05GSUdfTkVUX1JFRElSRUNUIGRpc2FibGVkIOKUgiAxNiBiaXRzICAgICAgICAgICDilIIg
MTggYml0cw0KICDilIIgKzIgYml0cyDilIINCiAg4pSc4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pS84pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSkDQogIOKUgiBN
aW5pbWFsIGNvbmZpZyAgICAgICAgICAgICAgIOKUgiA3IGJpdHMgKDEgYnl0ZSkgICDilIIgOSBi
aXRzICgyDQpieXRlcykgIOKUgiArMSBieXRlIOKUgg0KICDilJTilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilLTilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilLTilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilLTilIDilIDilIDilIDilIDilIDilIDilIDilIDilJgNCg0K
SSB0aGluayB0aGlzIHdvdWxkIGJlIGEgY2xlYXIgc3RvcHBlciBpbiBuZXRkZXYuDQoNCkdvb2Qg
bHVjayB0byB5b3Ugb24gZmlnaHRpbmcgd2l0aCBpbmNyZWFzaW5nIHNrX2J1ZmYgc2l6ZSENCg0K
UmVnYXJkcywNCkNvbmcNCg==
