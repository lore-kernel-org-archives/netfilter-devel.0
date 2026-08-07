Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766CF3D525B
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093085; cv=pass; b=T7zNthGQ1QmHYQnsiRBt4TbEVUzWHVIO27wOn1zAImCCIWpqSjlzthYEOoqGk7yV3z24IH3OBzXRodKNkeJX2biwDwJ1fGvitZQuy1V0a07c3yp8C3h/AONwTFNnnpoboesFDvNm3br+pBmmQ9CC1096Rdr4IK/2UBSUNxerO4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093085; c=relaxed/simple;
	bh=ZxbrVGxBp7yVKwlHa1qQNTWf1puHjwTku4y+NBPxXnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z9J5puYBc2otJj0/LCzQxj+FWq/aCwZVUq2VcfyeUjCyaGHMK06zp/q2FnmvURI/eL1v+9hJpvzkcGoRjWb6R8txCRYTUyeIz8cA5MXftDiP/p3hvnYfkM+LBlURQHbHkXXK2RsGm1Yaza2TVx6/B/HKE0G+P9mZR2/Sd9Mu7FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtUs8bWV; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtUs8bWV"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15e592da74so393497966b.1
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Aug 2026 01:58:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786093082; cv=none;
        d=google.com; s=arc-20260327;
        b=s0J5nP6azS7VsAezeJ0z4gliEBMA4EHwSKd9gKawZ9gA6kRbaGhRpqIiWIYuHScZdJ
         bUfsSs4nVywPdgqm0Rvf9Iv8CQZ1MI5Qzr1/vQtQJOg3fwSuogr46nKpui4mRum3XyAE
         RGRXITe12yvlto9ogALIMa2C23lo13ENr4FgKUH+iSBoqNZj3gIzaKNkPdGazDxSAOKt
         UFRhgQnFRhmlpnZSm/tVVEBzQecX3B6VweQzxDzFeVQIYlNG2AsBeVgBrsgnd5XQXT2l
         1F7qkZlqTyWZZQt2UOocsz3HYiV5Rk5TQ+oLuoaz8VfI3VomApNa+PpZQUcWRJ5yzkgf
         nijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZxbrVGxBp7yVKwlHa1qQNTWf1puHjwTku4y+NBPxXnk=;
        fh=uQN3+KfQx6ufHnEfCVzKS8a6EyO3+8Is1vt0LcqATPk=;
        b=s0+YBGFvU3exTK8qaxwxSErYGfqwKCqyh9jKJn0uXtViNhXYkDiCYfZjvwK7N9Xiux
         Nk414aWOFSbJP6hJ1PlQetlMRD+K4wdQMggMy4e3CoCGNw+c8vwuMIRWFynDizxO1pPb
         /YLnbmRWBaxYrstz1BcHMYd+SbtqalPjskkM0e8wyE8iVyN4uKRbEJisascnw05G+E5M
         XDHZ82WZvtSaC7CAm+YyZmAHG3QBjw+S4wfiO0BFkH8RAGuQi2aJgT/s902yAIvQGttF
         nB0LWDfWvc+DFucrR/Qpu2dg1uf1szt1HsFxi/wgtsdGF5z34CmOwVEIJZbBSAmAM+Io
         pKdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786093082; x=1786697882; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZxbrVGxBp7yVKwlHa1qQNTWf1puHjwTku4y+NBPxXnk=;
        b=GtUs8bWVlQMjERRydOvwcJZjaSSudiVAiqUGc+qf1q2+G5QtVEHhTXDXtBcxGQuEZg
         TZTyr/QiD5YZlEzy0rAHvWes7JUsTtLv/fXOW0FLJvu1HV3UsXHa4FwPfHIvZquARN23
         IC+1x92T16ho40Jp+m3ZlGswS2HW82vmI4thLMISKT31+o1w/Bh4FsLquvDiaXEaWfH4
         sJqWU6DEWy4ihsdLIcxk6toLKOq/n8eXT4H6sftwCfyl1Un4UVDgFlnOIDFED5LF7rQ/
         0mhcub9Svm+r/k2GlrFCTS3bkVeZM4d5JyVzINltqYR+X78t5ngrD0l1zUQuIDtz1nOu
         PMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786093082; x=1786697882;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZxbrVGxBp7yVKwlHa1qQNTWf1puHjwTku4y+NBPxXnk=;
        b=jvPZ0KOVV0rhKLVl+q0DXF6GCKNbGYaIhnP3hjoCxsrEdEFh68g7a5rTsZaxnLkfCr
         nz77sKvWAt0o+dHJILM3g2T4uTVd5U1FeH098SxmcSEMnwYagQeFg0X9Csgf1QTdvu4j
         GY1sW91RZiXxBSS5SUbX1xjwywpmHDAWbQrIMdbKUeQzkpEQfRLUiRhUzfVS4Q6Jtilc
         td5VdwbqqTYApkxEFMX0HszqkpA6vrRz6WLW4wFhmWElRu6SLNIkQgTlaByckEo4j9Qz
         OUR0QK7rFoIXe+RPjFTWSuyio7loD4TQKXykfyuD8cJZDoIeMGzDewLFcfqet70RsvYn
         2q3A==
X-Forwarded-Encrypted: i=1; AHgh+RrG8emSBEFDmUiuQ6mAyca24C1yxIH9GTR4XszhZp4PDsJz2+nTJWtPonFlEF8oHin5/85WNe//DDoBIch3aqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZIs6Vld++sNBCNMh8rE+CTrC06xDT00KdopxW1w5y71WbPytl
	lxo3TDrKIFQWv1zILfuyTI7hq8ZO4sCeN6UH3mlELfltLj18g8Ep4Lvvb0RNSuW5TzUi8BuvD72
	GxGoMoxm9rUrTzHTPigDkfH6ViqyynQQ=
X-Gm-Gg: AR+sD11xjawqLcgXLLq27QHf5Ah3Wkf4MLuCsjqys2naT1w/e+gcAF/03Ws4VzY3NoB
	Yo94YzIABKFS/eFZmAfgKA8tcccRRZJpgm51jKh3Lq1U+nfTPKar41m+T4sxoqaASPiMwMEGjk6
	PtdBX4FV3Pxt4HKqS8VKEWL+HLXE/CQKpzyGxpSoMp1gf34G0CCP+TkgRvH9I+xej8q46PfbKtl
	6kMeTFO0g+nqHSfNd0spHXSDmkfPA/o3aNICzW1Ce5E6sTEvoWWx3OnX4HO93sqaOWCcnwRMIHM
	lrmCo6HRRb43xSZyqmVNGvsH654I3+Gv74IP0DYALoI=
X-Received: by 2002:a05:6938:a093:10b0:c16:66dc:3abe with SMTP id
 a640c23a62f3a-c2051ec5e07mr650524766b.28.1786093082291; Fri, 07 Aug 2026
 01:58:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724110111.18783-1-running910@gmail.com> <amyC7_3bbwJpXIPd@chamomile>
In-Reply-To: <amyC7_3bbwJpXIPd@chamomile>
From: Zhixing Chen <running910@gmail.com>
Date: Fri, 7 Aug 2026 16:57:49 +0800
X-Gm-Features: AUfX_my8tPdK2QqmZAQFkJZ_YeSAMJRe7w2lCGZIQ9CKHeSLIi7oH4wDjrLrac4
Message-ID: <CAMyuFdU0m_VZU+cDAJXROZTqJk8HE75mu47ttVManC_osg62zA@mail.gmail.com>
Subject: Re: [PATCH nf v3] netfilter: ip6tables: set hotdrop for malformed
 extension header matches
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> This patch should target nf-next, it does not fix any real crash.
>
> There are also issues in this patch to be addressed, see:
>
> https://sashiko.dev/#/patchset/20260724110111.18783-1-running910%40gmail.com

Hi Pablo,

Thanks for the review.

I have retargeted this to nf-next in v4, as suggested. I also carefully
reviewed the relevant code paths together with the sashiko report and
updated the patch accordingly.

I have just sent v4.

Thanks,
Zhixing
