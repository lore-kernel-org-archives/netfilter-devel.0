Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792942438;
	b=vKJj+xttCg0CwPGmf42mjM+z3KAxd9OcUGdMJJjnkrmMxAi3xjzf0EGWjshuIsiPncR8
	 /cpOTqQemu4rokAoRNtVTFJOU8+isFoaGQGWKBqxpz4rnO56zHsI3mGjX/eBKcarRLR39
	 o/TXRkT/oAl7RmbRca9YfG9jJDHukcm3FquKNkN60WcX6kMRF0p+HHOBTLzwr+VpIl7oU
	 n2mjmkdkbG7J8XlGqpGYPnoatOBImLEjzmKiBFM0phbeKy3dIopuf3Gsmqaad7ftKtQXr
	 1TFnbC9ruEGzLasjT/hyrAtIIICJudZY2XOEA7/1gO0/jivjUvT7IGHY35lEuuVGW+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792942438;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=6iDde28N5U+/BYCUSb1UaVdhM7Joxyzd5OLlYBVHb3g=;
	b=YUPBFwUhwGVubNVtox0IZP+rq/i4Ze31pYMIDo4Mf4uP28M4adlOlC//MRWoEXwOfPj+
	 HFDxtoqIfdeotovzEL0ZW3YiMEkbycGWs4UeJRz2mQUudp7sfUyK7TNd7RfkfGlqjsk9W
	 1zD1ahOOXORdeerRNUPCed02Gx7RW6B0ii44mY2oNcnGcjEVUiZtFINrRfjK0Y+hqtR7N
	 eNlFDQ56iDp6t0IZbPV88QLN1x+mZfmG3xBc9XNLLijwrybECawqOAssHo64i2JUAGSb3
	 JJQR4wnt25wDb00L+BrOAmmqHmurv5aClVhntUnOIPK5i/7Lv15img9PEinXEkY6s7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.17.10
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740F4606A32D;
	Sun, 25 Oct 2026 15:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 740F4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue107
 [213.165.67.113]) with ESMTPSA (Nemesis) id 1M4aEC-1xJMKg3y0k-00EeJ7; Sun, 25
 Oct 2026 16:33:41 +0100
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 5.10.y 0/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sun, 25 Oct 2026 16:32:22 +0100
Message-ID: <20261025153224.42044-1-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2026-10-24-1-daily-reply-0010-nft-set-nelems-5-10-bounce@kernel.org>
References: <2026-10-24-1-daily-reply-0010-nft-set-nelems-5-10-bounce@kernel.org>
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
X-Provags-ID: V03:K1:L2ENoPxJ0htPrdxyS6i363rsOaxhVR3q3pYtFZIgP0qUNCQRiS8
 Bl3fIbwqb73uOnNd49VT/XUbsp5chjMvDEcxwREdV9Hv1hemvlG9Ut1vcZUy9ecjOv0zY8v
 GPQZEJ0xq8nd4/MQ9dEnk5wfGzx0ECKhlp9dbkljQAXVXImn5ya3EYRgZmCeNYIJ5UnudIG
 M42bJ4mlhfVZu1yAZ2XZQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Onz0uRx/Oto=;GD/C2sP9QoYGEMh985vinLXOF3w
 pGNRgYclweX+CMUrltYvTnFU2CAO3aSa+m3ilWuZfIX/Ne7KanySC3UnqeqIrYsXCYpPJqRav
 dlI1VfbdXcyP3s3Jtv0rt6jtj2Q7ZpRA0ZwGtJ2ZGbgqRtK8C/3JQfngCg+YQ6mP7dzZs+dbR
 1mgJw3Z52tWKNg2vZDx0t46+iATzqXOYGWSuYpbHEfQ5hfaYBwy3Na+7SgcVpNQuPLgxUXhYz
 6ygDEcY4iIFHLuWmhN/ml9RAzrKyuTx98yE/zo5AapDOSuvDczGKOTyzJfL3phpvG/ltPaLcV
 y2KIkQfTC+qPRKNDUyFGM90OxXX5EvjecDCAI7yynRuFL29f+1RaAK4fyiL5HAotWMhWe/eVw
 0fWt3ND7ufL8BGyg1X4pAhlDX+N9FZ3KAfhhj5eBVslanWSj6lDhZIDSRRgJhJhUAZGS1Wn8e
 0OFzuA92BTpXm0bQ8C0SHp0icU36DdtvaHNmuUw6gcjRegSI/8klWxzt1cs65kTu2/oItYYbK
 r6EDzHLHSte+742rOmXmo1KjCQqxTV/kQbhEfckNesCHiluyv1Lk+6ygs0ynbHNnzaWxHOUh7
 dgzIkrHyV7jBoxam6AMMUULW7sT7i8YWGjh3DBw1MhXTZ6v60c/xRlwVP3AKYXeWu38KcVsYx
 kWpX2ZFgMPMuyo35ATIFvkFFyEm2EHAvM8kZjRJs38qBmntp13Fe+9djNyIw+2fbxHi/iwa3e
 W6qewyOoPLh7epR9rfrOJNjEqat1MqpbT1/ZI1/LoPTPPO2AUFmYrKnnY2GLZNY67CzvzbTPx
 sdZeBGQ3K2Junu1OfIncPhRqAcxVMVHDlrMpQMlGKw766kPWiPO9ocy9ad4d/sMbB5F1uCRGh
 S7cghA91/IPqTniW3AulHxBzre2/ueAKjlmZtb3sbH9IentAwduIfPZXnnPXscY5ip/HB4UEP
 iXcXNjLViNZRDiDmEFYp2eKzH9sV10zekOSPASt+eTubhaMBmL/aprNUOG9CxQIkNKcR3j+CQ
 hyeO/YGc66deUQVdiw3i5CulwuF2NoYOY3wRc5PNaFlnTkHb4CTcGOhFjMYDiuhJsIIOTwED+
 gBabtM8vBJ7e/gX7L02ykT2wcDXcx7PAni8bUykUa+4HmQdN+VKgvLIY978UAfPnokFdS1iWV
 93sA1hiOZkjfwjYv0YcrC3mqoUgLIsPVx1X1bLrLUNQVuwkvLAtPin/fjWs16IcWNBIWLrbkj
 S4EUQ+heOaMPlOoPUdJ/GJ1t0E/QaHeN+F7DrCZQcWXIpwnq+xRLL8yIKIhZOn5UQB4FgUqKT
 rYnMlZIjdAaGRK0w7xXCJNAip/jADGVrVJ/I+PVfObtI7EdmbtjXWdDVfE8m/4RJAOqRl1s2j
 2jSXl/lhgsHrshwyCH0dOyR4gfdFN3ZZ5ou63is2Sh1mx8y4kc4MGPU0joKjugqvh7Hee0cI4
 HN2Fh++Zof4p0UQ0cqCABZQhtc4AhEzGvJ6LhA3NnH5qW9etfbT9vNp4ShTbVo1l5UgTkvu9M
 0UvkMasnql0FlzMKKYs7KyH8joByFdfU2lSNBYtdOam9xPVilL/4RHD9Oy19sutTJiIcMURE5
 H+eyAPsaT+E9adVMmIAdw1UoVNY1UfXPDONPLgvyPx0bqXmu+9YEMCAKhJ6klHUyBHWHoLwql
 OK9h3U06yOg/Z7Wp6aYyasXIrBzSiLAepRWRsxl/4zgPD13Vgycb8j6xMVqPSJDSWJbOffQfT
 0w0DAuJ/lSo+rO88eLKfDru+IdXguHuin92lPWGf7vX+kizvsRIS4/B6kQuy2cKWoWMGaQvAr
 y/4xEPnWNbJyqEXEnJ3y70cOHXF/BzRG6vYlgO0y8kZd+e1iTPaov3sj7V9ZC/ii2P0a/zniE
 aLGZmwxO5laN8IhAjWEWc2ppCon6xQmsOh98dINyjugTv9y/J6Gj2Ttx+W8c3Suyt8ia8nmCs
 2m1E4fadiR8jd3CDy1/1Kh7ezGldYWHzYip50zmRacmiciFXzP/3j9CfSEUf6Ify7n/Iwhipm
 +npgvVCduyaxn8VGL5A9Zdqoeq6jKkIUMv9nia9aAnyrkQd6Nx5f1+wKNf70XYsvtQsqUOGkQ
 lIboWag16b9dhGRCFVFhgIzbefTSLgmH0u7Pv4GANohs58QoWgR20ORnozB+FmOwziQm/0nYs
 KKO+RFBAEnBP/HhroGleHtkB0I3jLW9tfcpQL3Kg0wd9PoJofohcswYhoVY2OY3UZDuYl4a0R
 X0hf1lso9TyQ+uEmrFjAMQkzWpPViSDhsg7hyTi1iFk0TpnaYPJCEFVwxMK5y+xEMxLA/+FxA
 mHzJGD15/vJnWF1VwtgbNXW74iZJO1TH0pZ3q7J9ky/h4/4nVicAiN1nOxe+k3oEMA/Nnr4gu
 J11VGucv8Z9uEVpRJJW51Nstk5yxZ4RLiSuKqRM2Xj7vnNPAhUZ32Ih2BDlRTS1GJSetgXGDA
 8BKHHPdtj3HVK/QgjlEzZV0HapK38uUlwcjZDhBcFmvSpBt8fSf1rLEYbWhI+FyWZaH1Yt6Lg
 44wHN76fDyq7yplxnwSsTuEsF2a79EXP2oPEbRabItASv5fFs85cXRqVPH7SvWFsEUOmxyrFD
 2D7O9pJP4DGW76sSFRNMHhmiKUNU6G+GiyIQVt2mheTEXIVjPwYA+QHtyAuSWCHsX21rDV4ZZ
 he4vQfW8yrgf0AiNyh92HSOum4B3Wp0m9rQtiHGDChUiUVaaZ9LHjrXxFHnIjfA59ODqIKBYv
 Xro5ht3g+110nLE0FPs2fVSzL0XIEfHJq8siit/TBYyKGuYVutn+XhwSKdkshYP6LJkyR5FEP
 Efz7BYXXkATmfpJCOQlmC/yJz6Vhc3UduYEQ6JX7LNdtUh4il4m8tfwnAUivh+rhJybUw2Q69
 grZldjs/hIAeRmNGDr+voeFv205/OA4f/CY9JxAVtKZwoMzqs5CCvX8iLRgru+39hZdEbxTTa
 gDF6yeig4FqYDfydXNSGYnekSTV8Lr87jp3DImA5Ucy2j739k7h6tObDtJOaBQY8fj9tyM6I2
 BKb346nJeG1I+da3YMqIr1bwQm5mUl3ESqLIb0m6zKYSjo3smO4etDDKHXLnvQ4ecZ+gYTLzX
 nchXMab5kTanUu35l1eXxLTjJhZPabkJrWRhnGpU4vsUfzcDhn6NpJjdyru4mNbADSSqGjBM3
 4hYlszMeghsjMWqCMRyxWUistHT0kp9ZB3cLsws7uVQTZKdItCoOMxmdEenlK518Ksx7YIYPT
 LvHANzm/L+0RoGuF/ODlyHQiEIb5FxwmYAlWEdt682rqoHD+IxurwCkBGLwFWnY2TKtCfUB78
 Aqhkl02ddWjjV4CU2xfwV8t0dhcrIlQAxnTDP+E/OGIzzWqpbjlk1kEtAu1Ise0UgdHP2uKNu
 dtQ3t++RsTqjG0a0o2Aw==

This is the 5.10.y backport of def602e498a4 ("netfilter: nf_tables:
unconditionally bump set->nelems before insertion"), now with its
prerequisite d4b7f29eb85c ("netfilter: nf_tables: always increment set
element count") as patch 1, as in 6.1.y and as in the 5.15.y v2.

Changes in v2:
- Add d4b7f29eb85c as patch 1/2 (Sasha). 5.10 only counts an element
  when set->size is non-zero but always decrements, and
  nft_dynset_init() gives an unsized set a size when a dynset rule
  binds it. Elements added before the bind are never
  counted, deleting them drives set->nelems negative, and the new
  unsigned nelems > max check then returns -ENFILE on an empty set.
  Reproduced on 5.10 with v1 applied; v2 accepts the add.
- 1/2 is adapted: 5.10 has no NFT_SET_ELEM_CATCHALL, so every element
  is counted.
- 2/2: drop v1's set->size guards on the increment and the error-path
  atomic_dec(); the ceiling is set->size ? set->size + set->ndeact :
  UINT_MAX, the same expression 1/2 uses.
- 2/2: restore Pablo's authorship (Sasha; v1 had no in-body From:).
- Rebased onto the current queue-5.10.

Build-tested (arm64, W=1) and boot-tested under QEMU with KASAN on top
of queue-5.10: the set size limit is still enforced (-ENFILE), counts
stay correct across delete/re-add and flush, unlimited sets are
unaffected, dynset (packet path) plus control-plane adds/deletes give
no spurious -ENFILE, including when the dynset rule binds a set that
already holds elements. No KASAN reports.

Florian Westphal (1):
  netfilter: nf_tables: always increment set element count

Pablo Neira Ayuso (1):
  netfilter: nf_tables: unconditionally bump set->nelems before
    insertion

 net/netfilter/nf_tables_api.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

-- 
2.39.5

