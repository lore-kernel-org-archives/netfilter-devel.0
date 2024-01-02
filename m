Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACC8156C3
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cV3nnp9W"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-204f50f305cso3099397fac.3
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jan 2024 09:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704217860; x=1704822660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ek5NK3MU0vhhYJ0KKhWMvD4nX+kkA9szRj/pxp1Ya5s=;
        b=cV3nnp9WNpnHpIKU4fPGFZd4b5fNfFwzVPcL5Y8q090ojwlgx3jv1ikrnXOV1P2HaZ
         A/u5RGfmU0OFW/st37EwqCtcaLndWVsilvXs7A5FDj4Sjwf6o0Gp4RVXeo12dSI4nsTp
         B7OG99UsJUyAxTXZP58JOYUew57KC/kTkX++olPLLsZi57mCV12A36yPJ7e9zoVwLq4t
         rPpZ8kD3EuCWtdPt1EiSz10FcEu3tvcabOludgnNCGOl9ZR9ks6gdVsZ5eF0UTPV9HJC
         L1pV5SFUzLV+HmNi/bFe7cIFDowrhFRJfZjTsKUnw8mk7+9Oi7xhs9Kt2rS2N+9o6wV6
         SOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704217860; x=1704822660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ek5NK3MU0vhhYJ0KKhWMvD4nX+kkA9szRj/pxp1Ya5s=;
        b=UwqCElOPsJ0DTfhlDg+Ob3AE6qYVyZjAHGv5Yg3wt/HHxJntkXFdUsVRLTkTlupeIq
         ZAyrdt11/hRkwey3tjKOs3QfOlKVkP4xCzpqZ1Bb3DG+ej+feGJi33T3w3Cuh359RZsy
         rP0Hb6JMkInSnU4QrKrs8BfsELzDUHusxuQQbsgkAbJ7GEPqxsftfhwNEu9Ggg9RE+mS
         Vu5UV/Ud+OxKb3WFTE/4TKm8dEl/MMXZwCNJ1vLAOaG3bjo2+L0OI/EKM8fE3V1X20Em
         J9vYo2ELI7gjg/u071uYa/DAPdHTd7Hb626GzNVUuJ/mXcz1toGgObMEKSyb/lH3QxIX
         ff/w==
X-Gm-Message-State: AOJu0YxWQSp4gBlNVh/6vrr7TnjXHP3e/bh2Lhx8T9gFjBaQmJi1Z+Qf
	rjmXUmnQYiLsksiRux/8Qdm4ozHnE3s=
X-Google-Smtp-Source: AGHT+IGzxAajnvpUDzqmy4RajVIj5zUIFs8LCsXW1HXOkuZoMWlY2B208lS/YBbdFs2eD8lCtdS5cw==
X-Received: by 2002:a05:6870:4190:b0:204:4c00:e9e9 with SMTP id y16-20020a056870419000b002044c00e9e9mr20451718oac.10.1704217860244;
        Tue, 02 Jan 2024 09:51:00 -0800 (PST)
Received: from localhost.localdomain ([2602:47:d950:3e00:e8fe:1b15:70d1:8f48])
        by smtp.googlemail.com with ESMTPSA id dy51-20020a05620a60f300b00781b99ab724sm2003656qkb.108.2024.01.02.09.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 09:50:59 -0800 (PST)
From: Nicholas Vinson <nvinson234@gmail.com>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	nvinson234@gmail.com
Subject: Re: [PATCH libnftnl] object: define nftnl_obj_unset()
Date: Tue,  2 Jan 2024 12:50:58 -0500
Message-ID: <20240102175058.24570-1-nvinson234@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240102132540.31391-1-pablo@netfilter.org>
References: <20240102132540.31391-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I manually applied this patch and got the following build error:

    error: use of undeclared identifier 'nftnl_obj_unset'; did you mean
    'nftnl_obj_set'

I think a declaration for nftnl_obj_unset() needs to be added to
include/libnftnl/object.h. Other than that, this patch looks OK to me.

Regards,
Nicholas Vinson
