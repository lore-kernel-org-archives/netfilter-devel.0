Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1723ADBA4
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 12:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501705; cv=none; b=UPW0uxVEsA1zd8oi/8M1DNt3ZyD0gy3roVwnsBvEfrlfofXAbrBAwV+mtJRCrEJbx9jucc0dNjFV+ljoB0WXFGgL2ntyT+y9+K4kWBtUNBv+AXbSJMwUgyedReAFa4NGbsJMCGdpt81BScA75LEm8CY1v6r2pi1QoldZg2/XFQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501705; c=relaxed/simple;
	bh=/A+ChuDCuT6avA4SAPrFvWymcJb5hUP0VhdtyEVtd+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG6GF9TD5D3e8mU2H4IxlzHZncxKPVkLJKkhsDQxUZA8g8LRBvK2Bnp/D/iPAeH3r9gfWBxAI6Xa6qJgL+J9zYYI6mDXCPWwE17mOMzbS+PlQ/t2zQ/ZCkuSCRxXMHfTExtpTBVsIdhdyFYvbtGXJddaZYlcjv5fmR2dln2HH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lKk7K4qC; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKk7K4qC"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso772839a91.0
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 05:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785501704; x=1786106504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OASzXFncVv36XVsM5ruH2oyJ4VEQ1wRUFRfWuUymhhM=;
        b=lKk7K4qC8z7ZVdSposCFq1eyy1kXDynRPeOPcCuET1YYCj5qOPPR4ak4ssQdk4SU8I
         teYRm0VjBE0EtNXA+dQP1INtb8KOpiWEzBFl+trEoCBBPJ/byBbg7oDFATautk2LFgYq
         EGCuFIawzl/Fr/AuioBD+mSFSTONGrSohwfR+BsZx0mG28MoKSZD2KlZnzpGI1fSQPX+
         6Bcbp2dR+fRncVW5lWiNhdm29yxXV+k5zDH246pXvqPzqkIVXYw6FrpeRZD7OlVa/oas
         RNaCuJaaBukrJMLmPCDh2YGHRin5SOZPpRxrfHGAMhjorz2uusmF93WuetJWjYEIdMvc
         IjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501704; x=1786106504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OASzXFncVv36XVsM5ruH2oyJ4VEQ1wRUFRfWuUymhhM=;
        b=cGXSElUDA2BLHVjFQ2dMU0bDqAIRl7Y9buGgjOEsTvgj8s+X6silPZU5y9hEFTV9tA
         szT8D1p4BSPhRmkgy4qvIJb20BPcbK7Fz+YSo5H39GNJhazN1Fjn7YdHCiakflWPoPm7
         Prt4WitcwX1PLEEKAksSdMtJwIEBAkOFh73OM93vED9nl/VtcQB0li7Vp+ZbtnOM9tRo
         SCFThbFFmzOY+wrxl5l+ALD7pJ43GJh81uiy3rtji/0TaNTKauKitrvbk1NSDbVY2FDA
         wZxVqyzg0sxdx3ppnOLI92IkL1VBcaoKOZR+W7j/pDDcPO5e5mcXWARgvDzTzvPG2CQa
         jILg==
X-Forwarded-Encrypted: i=1; AHgh+RpKwvYos+aC/AFcjg1reNg3a9bnK2PKK58/88gdXGa4MAnk7hzkjTuvC86Ip5Ovuvz0hDLVxGA3VqmQYx+Xh0A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxcGPs9VNiN5//RWZDtsB9uiBkOYM0PIEAVlmWsi84bgKB31MK
	JJMJEKJdYSTtNbNN0M0K1T+TLgloIaZkwFvKEJ03RQ4NFY+tazGkH3VfmfoWB1hS
X-Gm-Gg: AR+sD10ohVw8pA8r4QNL3l/sIOhP4tA1+O5+7o5Rp5Zj2w3uz8BC/ZaeQmfbhXHggvl
	0aTbnEHQW4+nxZRAhNsqETUemfurPIciv/Ilif8IqAP/OZZOn+tK48nEZ13VW7mT9bo4dr0NPgv
	eBbxRxIxa5+oO4Cd6O/p9LhbrRFGV3ll/Mf4iB5rB0D6Z60/Adp7UMMrHELN+qy1k26WflHgy1A
	NfNQmQK9zi9wnkRtb3uQraM3cVIcPcFJ/jHU10KeG4EPMnZQxql5FLMkSeD/MNGH14l51jLIWIJ
	CQApZ+dCIARTDeLazB+tIYqV1vCgjfpPKVg0KSMklhQvXxdEVE5XJTvSuD84afobc0KBnHsv84A
	jz3IrXGuKzn7/pNwqLzNzKrkV+/ylUFgYp852ZWGss/7QLVILXjv7tASWS7drCEAoVdPgXlj6EU
	Ltt0B6oEGkWO9555OpjjhUOGQrWSOukwLVqCj+o+kxWB0uUc1kgThsHSfIXRRqOMH+vKqhcruOj
	l20/AOBJAlgC4MjunDIqMBQEx96DfM=
X-Received: by 2002:a17:90b:4d81:b0:38e:11ba:992e with SMTP id 98e67ed59e1d1-38fb14441b9mr1565896a91.35.1785501703821;
        Fri, 31 Jul 2026 05:41:43 -0700 (PDT)
Received: from r912.4v1.in ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e04491dsm8274078eec.16.2026.07.31.05.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:41:43 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] datatype: accept a numeric cgroupsv2 id on input
Date: Fri, 31 Jul 2026 18:11:39 +0530
Message-ID: <20260731124139.2127004-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <amyM0DqEImxfc8gK@chamomile>
References: <20260729173748.1033454-1-avinash.duduskar@gmail.com> <amyM0DqEImxfc8gK@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 31, 2026 at 01:53:52PM +0200, Pablo Neira Ayuso wrote:
> Any reason to ignore the error that integer_type_parse() provides?

No, it was left over from the strict parser that owned its own message.
Nothing follows the call, so it reduces to a direct return and the hunk
goes from ten added lines to two:

+	/* the listing prints a raw id once the path is gone */
 	if (stat(cgroupv2_path, &st) < 0)
-		return error(&sym->location, "cgroupv2 path fails: %s",
-			     strerror(errno));
+		return integer_type_parse(ctx, sym, res);

v3 to follow.

Avi
