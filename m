Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F5E52F88
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473154; cv=none; b=gNyOeyxDemxO54hzmK4naVnmV7MTwLLF6iIzTqLbgeUZKOqTtGS5xFqLBCSeCC2JaQJr5VsHnYaG/FAGw5/6Z+bsWK31OiDUOhFRNGRgRn633JfRGx1soCvzQ8BuPzSYtPHiWK0KA681neyJbq1BjjUHQjqax3eNmhKh6OQV9Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473154; c=relaxed/simple;
	bh=J7V87TJ/DrDLNhu9uuZqUq5UrfBfO+a/EH4DtXf5uXY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Ud9WKjf26EPB86LRJ+ERziA6O4AfCqHtNj1fZlMmn9U+Gp82bl8DhHayTy7TTM7SEFOQSsJ9RjXTj/HU6ILJHlOLO/AThRXtZA3Myjut6TFPR14nfLjNu4UdFnqHRaZFCdrY2BoXZIywPbOudhzb4ygFroD97qqL2FLt7CTlfw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=AuYebpec; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="AuYebpec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473149; x=1742077949; i=corubba@gmx.de;
	bh=6d2TacHA6AQKjWfvGr3+sNNgQpVHbJ7eTzU0Ucv/jN8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=AuYebpec5W40CRexkGbolEe2V/UrZKwveHFDP3YaMo61BWoIhoB/PZEp7lVmsC4H
	 DKQxMDgvIxWsrN/bh0IqdrWLrhigkSFk/Wd1345viBNImvJvsP7ae9p7w8tZAFFPW
	 n9PERXQLR0kjxbg2ypcG8adu6wAU+hdOijJsnWootTdYxgS8tULJAmDJy3FTGM/Mg
	 d0yW8Ze35R/wxh7vc26R30Mze1lRoA0XCw/MlKgrnmiqKESNlbujrM5pku9TJu3Me
	 gCd0FiBZpVa1jFTwWnRR0auz0aBFbCcCSzG3G6zWKu+s22Y5kY9LmSjApF6lsQciZ
	 YiOoFrW45aEsDTK6KA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N3se8-1t8sFJ1m4m-012cJu for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:32:29 +0100
Message-ID: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Date: Sat, 8 Mar 2025 23:32:29 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2 1/8] ulogd: fix config file fd leak
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8am+BlJZDmLA9Pk8V/r9XvmctT9QFV/WeMAOv3ml5zEaLM+gyH0
 vrnBZwHIExArA7rPmUjETQ8tEQbdmrpdLLI4wNifmXWIaGaU/FrW/6QVh6caPVJIddOOSwH
 6qOh3rnTjP+lB3TFGPT0f4w0HyBq7L9u2O7njNDV7QWlSpTFosCCcbdwr45mzhWl4Rmc4LF
 yROO4CmcrZEuoduu5bqIg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yiMxHul5CNA=;Je0bhST1Ekqmf5DRyZBpiivZUyj
 DeMXUVDmDhqj2BQhN/emfznNu6uBxNrMq4uj+UCI8udWu+I/iMNYWNssUNZM249eYPBA+ZdOy
 bjnctl2IdZXOHx6ut2agnUR4gM1UVwwCDLwIyk2hb9rriQRFRtInG6RObRiK78uKyIJiBBBpV
 sU57ml7FrSGdOmDT3O+kPqhi620P8vMLUBk9n4JYNHHJbwP6PKIbn3CG2vREj3mHOJaIzMtVq
 VToADGyLSn44p0rnsSPWhWFv7VUvfhFw4FtDTVVsxZP/n9loHHa0I/jFLVPFCjNp27+n52Ixd
 ojwQUQ9kIXmOWn69ER9RuqevYYdTuIyPwMSjfXUsvNgFFH2RVZqeflh8nuKHcxD2lvoEOKKFj
 er892HAMkWC5a+GA8uqfhtNSNyr8tSpSCM6rvWJB2RmijaOEzA28Mjuov5Zedr2B1RdSPDYvv
 vt74K/l/P26o10577bi1Hb9JBysr52QIKiXyeFSJMIqAoNiBnW9pptu84pbt6eCR5FbYEUM3t
 ObbUVfKdkrRHvHdenxTuqs/KfTb8hOnjG+ObSJpvKMkz53GKsIwNL7f3KIM5RYFepTqHH2TFZ
 vMrOqbXCT00IUtqZ3hBdJDajGo6vL8naG07ALjloobHLT8dHbkpfrly02Tn/bVqgn38mKpufj
 seNVZ8siPbkHuHS8MZchiLjEYTGGIVRNIG+C3r9kIxsc19+CmpWikIdPiQs9kvTnXVbcVamOC
 q2dV+A3l8AWNglAw7qQN19Fzzg4R9VwmwLIb6VVYRmDYMnnspf2w7RlF8TnWi8Hpp8TQnEecZ
 v4C30p+7tu/lseMbmm5D3qd5aZT9oRHa+BN+aufYtAt37ZRhvMyLeboZ/uRWc2LpOdGfHrlCL
 cAulyxB3qePJEDBQjyDCxjh5Atkjpwt/vRgX466xVSwAuXC8pTfibEHIJjvrSACPnQp0s3Db6
 cYcCu5eZjsjgZI7eO8CvYlWJ8iWIURDxO+94kpm8oao9MucLb5QH6f2TPgeJCUtFy2wAm8+TC
 jLprVLS4q9wRxEgxchCNg6zgFmlUV3ti8Ho+wC0o+K/IPnLhfm1e5fxmss4qClv/i6P4dY5Hd
 shOF7XZFoFMUKLd1QXO9pcQNmaj7gKcYBCqOMlSfCy7odfDjCk70pdkoRjVm3bFFj1+4aU7Nv
 1wfRD+agyrrZ1wZ7J1NkqEXV8GGXnXTLyHUPeiBayaPNVBALBXO1EvDi5ICOQDPtvKwP2ivHV
 ErRkVzwJeyny2rndWUDRA4ZU1iIWnjUFWijsXfeZCPXeY6ovynMnjJxZBZ4Fr8ZMvtW2s8Yd3
 DsOBDx8kycyICzGssNYUYXp2veYfLj3Vqv8qfQdHRoYh8WNX60Ime0ApTKPpr9yiIQp2WZH2G
 w5aWgyh3NWE9eHk6J/cx3TEa1wGvSYAynMt573D9Ded2v6i/1ODoPh0VIc

Consistently use the return jump to close the config file descriptor if
opened, to prevent it from leaking.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 src/conffile.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/conffile.c b/src/conffile.c
index 66769de..5b7f834 100644
=2D-- a/src/conffile.c
+++ b/src/conffile.c
@@ -143,7 +143,8 @@ int config_parse_file(const char *section, struct conf=
ig_keyset *kset)
 		/* if line was fetch completely, string ends with '\n' */
 		if (! strchr(line, '\n')) {
 			ulogd_log(ULOGD_ERROR, "line %d too long.\n", linenum);
-			return -ERRTOOLONG;
+			err =3D -ERRTOOLONG;
+			goto cpf_error;
 		}

 		if (!(wordend =3D get_word(line, " \t\n\r[]", (char *) wordbuf)))
@@ -156,8 +157,8 @@ int config_parse_file(const char *section, struct conf=
ig_keyset *kset)
 	}

 	if (!found) {
-		fclose(cfile);
-		return -ERRSECTION;
+		err =3D -ERRSECTION;
+		goto cpf_error;
 	}

 	/* Parse this section until next section */
@@ -175,7 +176,8 @@ int config_parse_file(const char *section, struct conf=
ig_keyset *kset)
 		/* if line was fetch completely, string ends with '\n' */
 		if (! strchr(line, '\n')) {
 			ulogd_log(ULOGD_ERROR, "line %d too long.\n", linenum);
-			return -ERRTOOLONG;
+			err =3D -ERRTOOLONG;
+			goto cpf_error;
 		}

 		if (!(wordend =3D get_word(line, " =3D\t\n\r", (char *) &wordbuf)))
=2D-
2.48.1
