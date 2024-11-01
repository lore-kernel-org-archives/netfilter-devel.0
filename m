Received: from sonic306-8.consmr.mail.bf2.yahoo.com (sonic306-8.consmr.mail.bf2.yahoo.com [74.6.132.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BD014F132
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.132.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730487202; cv=none; b=MczMdv22+3+NEM3hZBLFTEY3IyizOsDdiGgKWs9ecGhVtrsg+fFwBna0DHKheJOWTskYR01otNgn4zpve3se72qU/9VMHZPi2SyVOSgb+cw3dkPZ/ztBQdq21RJY0kQBLMCxDYHvC+wNciQV+bj2OrPpLRXWbadUMPSiBz2x1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730487202; c=relaxed/simple;
	bh=bN8gp4j72EUevDhsxd4gzbwq9leOjFY972xpGM0NYJI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type:
	 References; b=nyf5pirs+VWGh7ilCUQBoasAtayZKLSCWNVW+8BjdKZ34f08VoP3OKkpvc0qZ2kVntd5/CMYV9PowGz1pfoRLcZf8qvMcpswZVlud2WEh4G9ntLv8qoQraeYTwPQIcQDSEcWeuDhxWBAe+f4gyYhplf2ZsdeqlMhurhLleaghVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=k9f2EBzW; arc=none smtp.client-ip=74.6.132.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="k9f2EBzW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1730487198; bh=wRBStz0H1vyrUwZM4QNQCXlCE3wbJ4brQL8yJ3xO8rU=; h=Date:To:Cc:From:Subject:References:From:Subject:Reply-To; b=k9f2EBzWoMLkA4OYwZedPA/bJ+g+wO3OyR7d0qRyUtG0WThjOiezx4McKKjIRcIIM+vvxHnG7QMBPYHDh2N2hfW7drbW6h/2f3G/+XaFH+VNkjNPp1Co/iu2pB5lENLdsGLfarfUXNYpuSv+eRm2PTbN7C8MKzfP+ZfEOVFONnMQu2JssJwQ3nt7mphars5ulpXSVlNAMDmyF8JlP8Gm+csO0VObbBxQhiAVHko1Sqxs6XdXlGSv63RhKlnM5QBq7mxUxaDbgy8MMnOK9KTWsOet2IGHCNcfULlvUROeGz4bGiRj2Mv6nF0jld8FxvcaU7I6NrudPlIHen+HWtNeiQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1730487198; bh=d2wGX6MwIL23MWKrFgpl7dX4kmpQhvgYbqIVX0EgQnf=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=J22IRSnOefyop9De7UaEhFvvQC/iacb+HxoDtHTakATELVpB+Wv/htEiaCLb/sPIUXF1IsCw0p3ebCq2RK11cmoHFvUqx5rEti/FxcWE4jsOmGLod2A7wwFJsbagJv6Qjaj7H5ixMVA6eSK4u6UZffj+mU3fPvg+yz2d/jvEvNJw/8PwCEifSbWFgN6sdaZRVOI8FacU01Wt1ZpbiCi/cexnMNyM0Lt1xzunmHxyP6tQlLhisZQvIfV5SAbM4GRkgoNOExhLaiq0rkMnM9I869Dk+QWID75S8dp8tru7osSpu5OkpjTahmAHKlZhuJIYHFYus/CdJLaLaQzdq4aSNg==
X-YMail-OSG: angl1LYVM1lMFDIxGOPhHR8TYPqk0ZEY1C5CvGfdV7I1EuIBS2dam1DQvkBpK8F
 pTVJsqXGBKc0PLNbxHGnJbNlQDLmAb5Bx.wkPFzy8p6rg3GlcWBBmNXCsdebbWHU8bjGRvb1Du6U
 LshHdrHk_xcuWSd_Mt6EpNG.b2MGfoRKNmlLLr_CJGX8l.oEmB5PVmF3.8ukKtTjkP7fiUvs5VIP
 mlMJREN5QSYeqlhKMfGwegdl.hEIjtozKStypEOQsCKExwvD0zSceyaU02r6Iu3j1qZVTJCK3373
 jHEeQt47woZQMsjGGEj1CS6cI.8Jo_9V2ToD7m7.pmylt27AohndyQxFqUd28ZiVrDsRX7Cghm3R
 6utbN88x7Csq2cHGu7U8Is2QYx9Oe9s_Wrn7uX0rPbq4rDwkNI36Wh.Kbj_9R_FPt2e9Lm3GBqtS
 5ZoDv56VCHvLoGV8Fz9DAWeuTnhZX.6QI4KJ8MiHeCDZkiPTU9a8iqUvdqTFYIcPfKDAEMqPas7R
 DwYGesdYZeBldUM.hgLHSj1tEkxuOs9zR3bw2EDw2B32y.g10BE4gK7eTi2TaZLcq1DFiDuykuBB
 Uk0o7t83BWaloqtU_U0EgyYS.rwgjTck2zu6zyj_kticNQ_kEwRGa4OlehdmnDQ2GoOOgE68yX1c
 1YXtfF6NIp9z7.lgQ104c3C87.jRBGHd4lwM5fGrZw0G_7n0aYz9S0zgRzwDavKTxXsVuCSD2zgx
 g6ZVEo_vb5wQr_7OLidilPo8FFMqCTzCi_i5SiNj_9RuEvEjEthNWUdnZ3y9qLuJq_V.dMUUcVn2
 7MZ_s8EnP01_YlZuhruofc0a8cUi_dlXI9xOYoxI5dzhKXgz4SPcfGHrYoZT3.ChXYk8fQwIX9aR
 ZpKgIsrpig9KWqk0UVz6PnKnOdOz_9ZxDBx9.HIRvO5JyQNnTnfsdcUIeJBj_2jqziP9wk.PUYIv
 mew5Anc8gjjl764P8fdT7zQEIhdd22E3ex24DVbsrxCi833HDzwtu3g90rQtC8w6Q.HGK5zuI6iy
 Fxr884aFc6QkICU3E80FWhs.p8KxuTkEXrDvOnAKZbGkenim1A0Z05BRwq6Os4QN5c05DMCAJK90
 xaswHQkyiWm1CIsXPNf2cwWBAFKwd3hqKLbolYP.wDv0rqTpu7YrmTlgDSkk7BL7ps3cNZhR9W7T
 5zyjkuEtFbuHgz9D.9hY7K3uZJA4SSmnn5pqoExSktDPzDL6aGnP__qA7gV.NtxrKovbKgtmnVvH
 0Tj5CF3MaRnO4LXRrOvFIHYLyflcGLzn6DrXy5bIqq4ckXoJAHM5e.CKeYydnPOV_JEKTBJXh7sl
 Zf31qgKNKZ_zM1KBIDc_8Y7OHlP1nntQmof4uy5lVsSICGFuZ4Z4s7QZxliqwq0.kuhhFwo5jSBx
 bnqvqlx.YKG08VvQUtAxMVMIn7n.Z_5Ao41Mb8FdsRIkgcRyWKuM64YebhBpHJC6FwGrbZanaEHD
 EPf7PkGj_Ee2TYxVkjTkMTuz0V_ypeUlVn5PvTjLNqbwumonbjjP2YjD8TqRPNEJKeI1Xz_7pqKi
 8EdSUY02LEIpmO4UrDNKaBq9dj0SeMedm4iTVaApzYwM8FsqZSnjGwWPkq_CbZEWy5zqRo6ATjDC
 v_WaBq1yBNWPdsJORUC5bk9cHvUDkS1ATV97thiDZftRnywcsH2D5dmAtzvzqnCtqnc9s7HVrMDT
 AS4AzWe8lzRj7NqdYqrbEKxBZJKHk5HSNA5A_MxL6ATtXMgpbnUZc6bprygmM8IDLKv6NZ3f0cYY
 yNkBe9JlUpKyAwVLTPlDhrqQ8Su00Y.woVL2bJA4n7DMQLOSg9DulbDV.dxZBqJUhgK5X96.9WEK
 IY4cCkY0dFMVvYP2wtZIl2sVVjaImtZXUk9cFfZdM4wB7U.sfEaFY7HIIizPGP5f_uslxaHHqnaE
 CKLBWNAs7jpzY1rlS5yMpsz5NOTb9bjgy81QIUPkkfMKowC_jt3MUR5jOX6On_bg2OMUplU85LWO
 eb.HXTawyz0sVxJ6qTNPi9VwTv2rtWDqFJIijQ8acsRdhB8Szi3Dg4cjXs5TaMw5eVb6zoQSNA.4
 TSRyMj9lxJ2gZDwu9LHNUhLyvHSArEXBLw41Xma4jYShtgwZlmTLZCQoHP8UcZFa.EQAdnsOxh_Q
 ZcxnzS4zWzKwxwbj91odTq5QQvn.riq04mvbiqGGo2i8hSsohmeEKsuGKUcw9O4M3xBDTHqucQkk
 QPv_BTNkieYcMwEoFOTs5SWpYZ2KZ2.nxaAv8tmQ2SgMExBRJ
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: a1a18b20-a3d6-46ba-890c-12ab0b36a078
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Fri, 1 Nov 2024 18:53:18 +0000
Received: by hermes--production-gq1-5dd4b47f46-xx4tp (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID f7457943832abdf25af6efb5327bb6ce;
          Fri, 01 Nov 2024 18:43:06 +0000 (UTC)
Message-ID: <97463c75-2edd-47e0-b081-a235891bee6e@schaufler-ca.com>
Date: Fri, 1 Nov 2024 11:43:03 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Paul Moore <paul@paul-moore.com>,
 LSM List <linux-security-module@vger.kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH lsm/dev] netfilter: Use correct length value in
 ctnetlink_secctx_size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <97463c75-2edd-47e0-b081-a235891bee6e.ref@schaufler-ca.com>
X-Mailer: WebService/1.1.22806 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Use the correct value for the context length returned by
security_secid_to_secctx().

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dd74d4c67c69..edf08cc89f17 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -663,14 +663,14 @@ static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
 static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	int len, ret;
+	int ret;
 
 	ret = security_secid_to_secctx(ct->secmark, NULL);
 	if (ret < 0)
 		return 0;
 
 	return nla_total_size(0) /* CTA_SECCTX */
-	       + nla_total_size(sizeof(char) * len); /* CTA_SECCTX_NAME */
+	       + nla_total_size(sizeof(char) * ret); /* CTA_SECCTX_NAME */
 #else
 	return 0;
 #endif

