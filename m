Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75B71B3A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2024 07:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724743479; cv=none; b=mPXLKfdzCHkG87s5XSbIWTKUm7r5KCHyHjfqGzqBo4gbcWwOltBMXSAZ0FwxAgeLQ2yUYPUJB9S8MUmY85q8308CfieDBu7iqkuwTe171DFrXnYTCBey/d5XH4jwllvK7SPy7ec0sC6CaQz77oEddjnGoQNppvwQN1hu4ySFjAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724743479; c=relaxed/simple;
	bh=kVYmOR1pZ/Zww7mMTzJCqClaBgKomur5qUMo0vkgzSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1/7UHtCtY2fD6I7bXxCesHIcanzgLD1AfzJ4QPa+4kU0YMtr/6Fx8joQ/CSQJgBW1nMz8Y28+gDIMGT0mL0BmdY5Mw489gi34zmeLKXY55xxU5OvJXIuzW0EBuU+0kS04Xyh8XR+PahO+FBDXJyFTVgzXUkcrNmkMC+Dnn3mcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfkeRfIj; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfkeRfIj"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8682bb5e79so681635666b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2024 00:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724743476; x=1725348276; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kVYmOR1pZ/Zww7mMTzJCqClaBgKomur5qUMo0vkgzSc=;
        b=WfkeRfIjkrojaZzgESfv6Nv9HQ9odZxDVic0jtG9dW2ekrCO7DFOQWlg64KRsrqeFZ
         erJOPX4ViKcRgfWDtK1enRcfeXKjtsWzMWjJBxFENnD1JpQl8KziDBmkKIeljCzJjyJA
         liq7vVxdoVrTM7FgJKGNCJWueQwsfMRVAJsQIWseuEsBWRAyTuXFuNuPmAIadj8Yw1Tk
         uqwOFpdngTabWmZqxBCLjhRr4WisYKw57TkglL+ykqIs3oBP4VwNz/nVJPtcC7f1gTLX
         GiP23MuP1nuaZsJvhQCcZDyaDXo/SN3anflITHPbk3JtNogTbdF/nAjbxGbY2PbtUtsF
         myKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724743476; x=1725348276;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kVYmOR1pZ/Zww7mMTzJCqClaBgKomur5qUMo0vkgzSc=;
        b=qoavqITbpqyWu2dmFTI9kLc+MohRX3fKW3cBvaFgKUrNUkHThJvuHxvVWI7reYn0PJ
         J2DWI4ri0HUJ9ixGTM6D7DzthyQy/wnGUxxKu/qm7FmIHSUcZq16m6vl+5dfOpB+efui
         SRX6pv6evfKKN2v5wIEM/LP4u+ahwGtz+dki0sqDlcpAemTHlJgmJbu78JpkfHLsGQUS
         /Z4Nq21kLK8NlpS0NmVVL00yEieBCCW6cw9x33JufM36OaUb11tWPx8Rx1VtRt4a5UJJ
         0sQJZVQF1DUeT6pyspPiC2AS8NledTpjZJR6MY+YcbFZen8WPdkQtgBJlJMQtKlmT+JP
         +HrQ==
X-Gm-Message-State: AOJu0YxexZ/SHzDDmnlg6Q3FUselGixewb0UEpPmWdvyt9s1TQ4b67NW
	3EPL5mPLXqOG9+a7ZgpCzilBKxBJx4BzHfE9epTujTiw3pEKCIs/7a7ZxnP1XvOnyrTPxlWxbVZ
	jjS9EZO6lkL29XTMQKc1zKFKBcuJ3W1pB
X-Google-Smtp-Source: AGHT+IHP8/7GsKtz/kLqvziIy548jOqBVuMM/gBf7rjeLjfl/PbhX07+j3BYdqolcqVuBPtPERqErNP1MMhYPNGiRZA=
X-Received: by 2002:a17:907:ea3:b0:a86:a0ec:331d with SMTP id
 a640c23a62f3a-a86a52b73f5mr844629966b.18.1724743475980; Tue, 27 Aug 2024
 00:24:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826114400.153251-1-pablo@netfilter.org>
In-Reply-To: <20240826114400.153251-1-pablo@netfilter.org>
From: Jorge Ortiz Escribano <jorge.ortiz.escribano@gmail.com>
Date: Tue, 27 Aug 2024 09:24:24 +0200
Message-ID: <CAM8zxMPTpicDtQgg-rC8a=iFSSaQTo8POana+zVWovBcH7061g@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: restore IP sanity checks for netdev/egress
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Could you try this patch? I think this approach is safer.
Yes, I agree. Your approach looks better.
I tested your patch and it works as expected!
