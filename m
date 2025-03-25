Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC08EA93D
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 00:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742862382; cv=none; b=OZI+yxX3nINwDuLOG6SSCgX+SFQl7r6MnBxUI8xoPPhmASf2ep8Q6JVL8ht2gyYS7PxhQtT0hnJy8dEpy8ratzWWsL8WX5w9ALawo+SsCRv/RFQLkG6+iNpJk/OxZPkZ+1nCfrR0i/m8UNpQGuihuS54LNJz3HGkCsY1SibdOps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742862382; c=relaxed/simple;
	bh=9LMEkq+evN62MDwN5MNLL1NfVXr10v4q7pKXi1RTC8M=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=RW30wfrwLkKiJCiSCAYK/gmpBR31ABfzqaYluCsLXDgeg8QZDzT+4WGGnlS3S56L0n3pBC/qVHwPyHbCFcZbsTA/2w/CrO2FY2wyOcW+NuAV3YYg4vurHCkLfFGVg3l0l4ct8O5Ltbsyzhe2CF35SHu6INdmgy7zYtOoQd3VVXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=Lty81hM0; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="Lty81hM0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742862377; x=1743467177; i=corubba@gmx.de;
	bh=D2eqkmZJtkWZN5RV0ZK7TJuuCfJ0cmyycPf/dxkvJfg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Lty81hM0EkftPtZEClRB3hWXCL5HL3gjOqWGiZP3z0Sf3vvUfVFN2ytxfAEm2jYY
	 zTVqcFIfvyTvLCs2LzlN4/LWrTcKY6W/VFyJBpvWKPT83nK9tKZSl7T5X6QbVzAzg
	 s1JZ/Z82fQNvQmcZC+yrKJiw3AIu+2CuBNUAZIB/2GHNIhZiaxCINpOXkK+8eB/zH
	 ZeCMo4+SKFGwaVkVbS5FymioRvX6H4DCn3qBbkxVx3MeVEPD4o1w6W1gioKgNixFU
	 wHw+bl0C6R5MvzVHfwE0RcYLVeLkhnCCtydrMC4S4j3UvoBV4ef6zKqi+bl0PC/6l
	 AmmsqiE1296tSj+Iww==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MOzSu-1tmsmi3UKa-00T7HF for
 <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 01:26:16 +0100
Message-ID: <23d650c0-265b-4b74-afb3-17efba8c96b2@gmx.de>
Date: Tue, 25 Mar 2025 01:26:16 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2] nfct: add flow end timestamp on hashtable purge
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jIQXKAmAKoXh0Df6ozFB4X+AyqSKVdihHx5KlUBX/cwsFGDRhRO
 ownW3rLSss2KqUibUamlZyXKIVGHMyFwAib2Yei2lNRVMkLRuw6/qhDrJKkSsQ4OGqoSgH4
 j8+C9yQ1xGw79rlTaIDiP2PTYhJtJfCHd0kaZQmIFqqD3pAhxYtFKBN2ovJHpZivMCkQQn9
 EITzQvGKC72cQehRUhKcQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:IZh+7Tcvt/Q=;x93buSWLW24mGMh0Tecu0VpCuAw
 ku2bZdz2n445QmVNjNzJQx+zxxJf0m2hEBECfK7Nmz9ubIX7eFS23II0keST0wuR1rtQXmjM8
 b7ppy2xlxKASs1fy4a54y1EWYTU1SF/2l0rbtuhdSdaiOBAGVP2mPOdnhiwfYXCZ5rfwsTiLf
 XIrCCfZ0Ho89P02K4FYpM5m5LUL5MTu8B8o6O22pKYUnM6gJaBHzwfeZwGuAgvk/QPwNDfF7S
 A6PvGgYzHWE0dPcKfUlWf6DuTpUFuN9CitnRMrKbZZutcthggwbXDK7vQ2+5SzdexiuXUmnp0
 rcDW0f9Pks+iibFUN2rqNwgxspoJ7r4jSHV7Y5VztwWDvR04YN76Oj26zqkzOXhYp77vVZ4NY
 /I7SmkST71WSE1GSyRj7X3Q1/xuzw+hzK4dp54i2sE+3vc/jzVse6zGuNnBbNvTc5zVGndUsT
 dbnCwhSxuWki1TQNmLlGfqhJPNgwioCnaYAACcSzYYOQ8trNxOn7iy2pgBIYqssNdNPvkGR5x
 fUQhmVAU4AtM52L5o6v4R2o/ETzkPZv7k7VLeG96CshZO7+NB0tnPFMSloaQCb3bkT8r1uy5b
 1MIJD9mteiZ8+Ru8z7CQ2bUKfeVr8C97KVWaUmzmkzu8ZpOy7S0nuTHj7he6usSrgbcTIy5DY
 Te+nd9CR9P1XSz02sgpBYVkPW/lGE/sfa5ci8+5WHiU3Rtp/+qXrR9sbzF41MgWSuewbcoPTN
 zb1Vvv//Tl9dfkffKfqKufJCXsVk59NuQmPhn328+ismRZ2Zvc6tK60DlhlBsAfcJrnu7b0GI
 a7qUp5bj3E0MHGRoQL5akHwOG3J4QsFafCvzbJ1Tfr1e7ol3RWEwjcrlaMmh2rqQ73ZvdDNia
 /ioDsDEGVuXTawHD/Sbs9pHBkld6O5Dl5QlqpcCW8lGduBlnyjN/Jxq9YcHYa/TWLjGH/SfG8
 svtmbu1g4dpKj7NV7UUnT7BAdNXFiGxO/ZmrIavAFpkxoUUm9pYQM1cdtOieU38FwdeSJQ9y7
 eUbP7Zmkcgs8vrXQFGfYHnUxw4gUZaeBxTyp8pI7VapHa3IUGiPAJZIIr8p61MRbNmi8e2BC9
 qghQChqCl+BCUlmVyO8L2sRUugHbzptCImcdtNuN6k+bh6e1dZEyl+KQ5kIv9kR0u3Tn1Hz9+
 Eyv9v/Seq+vXEB5tQiJM00bq1vZhGo/eNgX+VU2KbIQyfafOcQrUXDP7qeNLFshDdjWYh3EEz
 dAdbZugDLIVk12FQVOxYm6W7c0D4lUqB2tjeKsy4IIKtjcZiuzZV3aXoN6l6JGrgx0WVJncYj
 pLo4SaYWrdBcDlrkmME+6XICFd+0WsoY3ZdrIFG/mRMtwtFg3x91VVNI03D6/eOruanNdM+/z
 yph8nKg3e1Fy7qicgGO6vsx80mP86mtyypvDZqxq5bVI9S+iTufsEo95ZFJKbO6PEMMkrGXNH
 RXQMSpnX2LDL4biSwsdpBD1e/Rwo=

In polling mode during normal operation, as well as in event mode with
hashtable when an overrun occurs, the hashtable is fully re-synced
against conntrack. When removing flows from the hashtable that are no
longer in conntrack, there is no way to get the actual end timestamp of
the flow from conntrack because it is already gone. Since the last
conntrack data in the hashtable for these flows will never contain an
end timestamp in this case, set_timestamp_from_ct() will always fall
back to using the current time, aka when the plugin determines that the
flow disappeared from conntrack. That is only an approximation, but
should be good enough; and certainly more accurate than no end timestamp
at all.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 93edb76..bddc9cc 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -911,6 +911,7 @@ static int do_purge(void *data1, void *data2)
 	/* if it is not in kernel anymore, purge it */
 	ret =3D nfct_query(cpi->pgh, NFCT_Q_GET, ts->ct);
 	if (ret =3D=3D -1 && errno =3D=3D ENOENT) {
+		set_timestamp_from_ct(ts, ts->ct, STOP);
 		do_propagate_ct(upi, ts->ct, NFCT_T_DESTROY, ts);
 		hashtable_del(cpi->ct_active, &ts->hashnode);
 		nfct_destroy(ts->ct);
=2D-
2.49.0
