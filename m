Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572E619004A
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542464; cv=none; b=fi8LNqkZHCOOkN95YGyJ745KfwYPyOBXRxWshPqZxE7g+B4ZHpbYBE5C1TEbevBk5ufG+jD8lJ2ndQtuQAR/5+1Xdqs5MenxT71UaC1kujBgXMoO1KcrL2eFOdhJe7yvbb/jzXUBX1KEoigoYwrzQOmLiHc0Hj1pQxxClUUOqxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542464; c=relaxed/simple;
	bh=OFc8DjmEbYuGQq4/+z3qKunvvIzgBdptjKqNTSCg5gY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bb5WFHLGUzK7YGB1ZqkkMp3X/iEKD39NO3THj6sfqNnlGRNg+qPJLZsVDZLHnqHzjdRzj+wi4sE5N3yW0BjMYCVEHVuAivc4zxzq7+MOxHP6T0LQ55kj92ntm1R/r0/lBF/bgGKb0ga9UKoBIlVK+1+NwdzSFno1lO6Mwz3bHYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Z6mZawPG; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Z6mZawPG"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gN2gs3kCmz3sb0f;
	Sat, 23 May 2026 15:15:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1779542119; x=1781356520; bh=UMCgCl3Qja
	ouI+4/X+yWQma/WUGVqMAaEfE1Ozl1Ftk=; b=Z6mZawPGK0d/YKquWcD5VUS889
	3zqqMvzjnPu54AqJu0YVX1QVjxEtfbv2qwVtV8JDwC3LMdVlC/CzXT32TY/vzzfI
	BYIaCgrgsKN1IvpA5UFaWLW6kfdd0Avf1Ainr4BeJCP6dkCMH3w6JvMedpIEf5yO
	F88jbL6YWfNeO6nT4=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id plJxi3-CwrqC; Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gN2gq487Mz3sb0c;
	Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 4C71B1412C5; Sat, 23 May 2026 15:15:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] netfilter: ipset: add comment how cidr bookkeeping is working
Date: Sat, 23 May 2026 15:15:19 +0200
Message-Id: <20260523131519.99953-7-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260523131519.99953-1-kadlec@netfilter.org>
References: <20260523131519.99953-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: ham 1%
Content-Transfer-Encoding: quoted-printable

Sashiko thinks that cidr bookkeeping might be unsafe because the
concurrent RCU reader in mtype_test_cidrs() uses the data without
sequence locks or read-side barriers. However every right shift
(add new entry) and left shift (delete entry) is performed by
duplicating the entry just shifted. Therefore concurrent reader
will just duplicate a test with the same value twice thus existing
entries cannot be skipped.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index d97b783174d6..658b012a154c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -342,6 +342,12 @@ mtype_add_cidr(struct ip_set *set, struct htype *h, =
u8 cidr, u8 n)
 		}
 	}
 	if (j !=3D -1) {
+		/* We shift the cidr values to the right
+		 * by duplicating the entries one by one,
+		 * starting from the end.
+		 * It means the same test can be repeated twice
+		 * by a concurrent mtype_test_cidrs() reader.
+		 */
 		for (; i > j; i--)
 			h->nets[i].cidr[n] =3D h->nets[i - 1].cidr[n];
 	}
@@ -363,6 +369,11 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, =
u8 cidr, u8 n)
 		h->nets[CIDR_POS(cidr)].nets[n]--;
 		if (h->nets[CIDR_POS(cidr)].nets[n] > 0)
 			goto unlock;
+		/* We shift the cidr values to the left
+		 * by duplicating the remaining entries one by one.
+		 * It means the same test can be repeated twice
+		 * by a concurrent mtype_test_cidrs() reader.
+		 */
 		for (j =3D i; j < net_end && h->nets[j].cidr[n]; j++)
 			h->nets[j].cidr[n] =3D h->nets[j + 1].cidr[n];
 		h->nets[j].cidr[n] =3D 0;
--=20
2.39.5

