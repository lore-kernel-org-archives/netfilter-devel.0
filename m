Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5413FEE
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 22:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761777937; cv=none; b=Nmcs9ZO8eEc7qis+kQtrwab1aIGxxK6jJZuTMZYThxwvsHRTpuu88e2w87Dl1PyqOtbWuJ5xJlHSWcbT57MIrACfICkO7Fx+iEhS64YqPUEd/DSpIjwGBeSABkIwADbg5G6ywE7HrXnnOGDPid+S+noUXH2C5XDPrjxh9zcJiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761777937; c=relaxed/simple;
	bh=fx4tbyfbxfqROrwuaVQPKZ47kjPCz9YraW90Cy8j13U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvSMG5kvykJ6xUa5ib+PxEqY4C8OhH9WPh4WbjYuIg8lsHCsCaGNOIsmD7KksXeotf/oBCamExFOoV4KJk1cf0QJaRiYgeDjus8KSC75u0DptdQJOq81GHVBPQywfPDnRruCfoeuaHY23Kc9CdM/NTnejwKZrrjS8o55FvhGS3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Am0h8Eih; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Am0h8Eih"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4270491e9easo326324f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 15:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761777933; x=1762382733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fx4tbyfbxfqROrwuaVQPKZ47kjPCz9YraW90Cy8j13U=;
        b=Am0h8EihsX/uKThD56v6xRG/srpmde8EffSTuKlbapyawfAfLZZsk/hJEMf6XzJ9GE
         XgmGHGSigZNu29egUxflreklZDP/0r80Ej0GXvLuN0GkqUIq5BcShaQ6gl5odxCrYxzO
         xni/NJQlf/XAPV3iCul/MdRxNCxxqZFH0Zmnlla3Vszq7rJ8w7lYw8PIOjEZ/hSI94NK
         T+ucBxAPuJOx4QeTFHP3w4PUO4Ww3MElFm3ip6IV4x4V3jPIvsALdxUexfOb/6MIBNZe
         pMXqPK3UAaw2D0sBDOouquc4AWKdX4Khrymuth98b0ZoXZRYNsRYwsgA1OcXReVGkguM
         sYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761777933; x=1762382733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fx4tbyfbxfqROrwuaVQPKZ47kjPCz9YraW90Cy8j13U=;
        b=RVEnijRbPSr2yBDATN1E2ab3U4SRs96LbUijdyLb85q1Jtz/r3QvscwDpYVuGceF6w
         vKOR9lOCP3TDszjn9P/qtvSfIXUwhew52ffZ0OAU8xJhrw4HUMbgHjfNVYvKZiUNoUz0
         j2QfREprGoD1L2h49B/v06cNbSEjd0o117xJ35J3b216WdLciWgyLb1LU18fplGPZgr2
         Z5hmjMB2/wowhg2wnOhrWZxwIkRy7zCSYCYJOmyzliT+iVYJXSHCNgNlsBz5gxdEm3f1
         vbeoOnPolgOgwZ0DY4aSr0y1kf6zyoIJULF86J/xuCzgBe3b8TwphSrqTh5tMalyBbe+
         yfjg==
X-Gm-Message-State: AOJu0YyuZUIZ7eAhcKGpuCmna10ZGNeVlkReJr5wyjgoQjWI6F0IMa1H
	uOGY5MsYGPURuVFNtkV6qo7fvElT86n+9CfKN+WsU5ud9fTGyzz4Q+2Lnnc5BA==
X-Gm-Gg: ASbGncvIaeOIZvC3teLb5gcxI7ny8t/Opd7UrkF3NvWQPNrhGLlxUkkqmkF6OKT4jCZ
	DOL0g13Cj3aQeQX1/IVhK/nZw7/72RNcS7fkuH9KWTzKTq6oLvFRg/uG8u1g+s/E3RWqff8BtO1
	sOgOB6j3P7Jua4wqLz4DV3+EIrctOG3Vh/wHeAQYrLeceZQK3NVLKPw1vQ1IMWmY0tDRwvYEWd6
	2KIjbM7fr1E9eeIB67fvwRWmI5bA8+56cFnQVfa62mllMDy7fjyEPkJCI1PmeiiNYxRn6xsypc+
	QA4JsxOV7Cczs0Dy6j+Hjt3eMtS+YhGGAsc/HdB36xw+le68DwJxeX1vohiCBf0bwx4W7arPAts
	5npOVpH+MvaSzdHIykltMb/0CkkWGOZ6xt20hihJpR+5sgS/loUEXFJ8iQZT7wrFbwbp1+4orYL
	4/7VymwT35vLJ7o1Ikt7aOUdQTsRxfqnWjZYgTTC+2hNEVBg==
X-Google-Smtp-Source: AGHT+IGflYFa94z25OEZp3F4S1UqmyV4iiUnVETjMh2YUvyOZVPSs5qcul0hJiJx5+ovEh0me53GuA==
X-Received: by 2002:a05:6000:186a:b0:429:58f:400 with SMTP id ffacd0b85a97d-429b4c9d05fmr932319f8f.50.1761777933308;
        Wed, 29 Oct 2025 15:45:33 -0700 (PDT)
Received: from pc-111.home ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d5773sm30600955f8f.27.2025.10.29.15.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 15:45:32 -0700 (PDT)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: 
Date: Wed, 29 Oct 2025 23:45:02 +0100
Message-ID: <20251029224530.1962783-1-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029003044.548224-1-knecht.alexandre@gmail.com>
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Florian,

Thank you for your reply, please find the test case below.

I've added a shell test in tests/shell/testcases/json/ that verifies
the handle positioning works correctly. The test has been verified
in a clean container environment and passes successfully.

Thanks,
Alexandre

