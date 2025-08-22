Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A42F18E25;
	Fri, 22 Aug 2025 01:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755825479; cv=none; b=aJmszj3H8bGl/Wxrm5HF8oa0Maqi5haDTAczl+CEgiLZzzy46GkvryTCCaDlPA46kABImgeUnYOp2/NJnSAL/U1GFhUw9nSoSjg51hjuvBotrSMRG3KSnJjm8UdpMLfma3PtJcEKwFo+YYhE2huPUFj1Uq6/ZP3FFVw6D0ksSVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755825479; c=relaxed/simple;
	bh=Q9i9infuFQRRCTjk8mAeyYGlzN4rE31wbX1M3ubj3Qk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pq9ia9+XpRDi59Nmz24w0VmKL776WGXNd3JCex/Hi3zALzIwd+nCSa6hg1YV2QYpkSx6w1Nw3UVzhkPErKYaqBwsphMRpV4n3cLCj2dENKYw1+M09VdHa1dT5tXk0mU/0zM+KvcuhOo3H1KMRkqt3q9L5YVNm6cdBbbFwiIfpcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O0BXFAmL; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O0BXFAmL"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e1ff326bbso2076229b3a.1;
        Thu, 21 Aug 2025 18:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755825477; x=1756430277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5RA4Bqgw7+YqLOiIWyOEBa9Bj4DKQ61R55KpzeIn1U=;
        b=O0BXFAmLbkiKcCzxXQSmikU1O5IRVbRD+G6qFVkJDSZvzb8fwlOJHr/xVgctIM7qV0
         4UqiM8bE3+uFKrZfOPHqYnPGxbhP5LXI4lD+Hs+ImlFOQQjLa2oXr7MVv7lABGjrJRFt
         eg0lG9NWfnhy29wEaVc/6vDoheAS423XG6++VX82NhzAFQJz+rk95sLOAHi8Lvv3kYqI
         +uDOpMKOO6fiHobnoonLKuLsfVxDCKRx9q/5hT6h2b52un+JoOEBIXMeRSqZThMRmrcY
         oKyjt6tQxdZ1UrjiNq/3dsqUTVO34AnClGl4TGr4sBR5AGXhWpmt8RDWNiDG5ZJtq59g
         bh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755825477; x=1756430277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5RA4Bqgw7+YqLOiIWyOEBa9Bj4DKQ61R55KpzeIn1U=;
        b=hkXk7YkMJg5vggSrYpcD+GWg73+2NXqEm0HXD7d3cZIy5wGShi0HeDrFdeUZeO3X/G
         NzcFM3jy5pCRbx1ElN2kiQSk7vkhhkTnk6/ZQBCM2AsF8hiwmWd3u1rZnWCt2t+p03G4
         Q+R+DvdYfCT4RGzvGebsCGHoe04RuxPQFOGHjKwoEtCRJ7LUNmoycHLD+55wf6HwZdG4
         is2ee6zDs0XY6m0hL39WegOgFwPzHSdfkjXoV+2DoWWDXewFkpY/ijFMxIgbggZ1UAX3
         fjihCK/n/ZS3XvxrKDaDsAOWbH/zDQnRLnw7ax5UQDiPbqrw2rqYUpoBIuBkuYh8KBi6
         +MBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaoygb5QV6LU9awDS4M+jBfbrs3rDKqdCj4ZnZosW5/hOfZs55xfn1li7r5D2rWqaD8NkxBYQ=@vger.kernel.org, AJvYcCXdpDj8aPm6oWspaC7EQF2Si7IdDdKF9fzLhuD2soxLB745C1afQawbW7ahVmLHNaXYH5Ib9XPr8y1nprSvjLo7@vger.kernel.org
X-Gm-Message-State: AOJu0YwgzXyhCvOHVLD1C8tQ94Bkc6n/5wFiPosC+bP3z2nZwtUm60Gi
	Km7gs+5skLOCQBM/Bh3EqaiuNP/n3IkXtoIVPZP9zyLSv4ES/5DYyaVUe6rcNg==
X-Gm-Gg: ASbGncuBu4rlx64vNekOH5QDmb5Yyil6yVV/0TqKdufUcvLN0nSkLwpLRTgQ97sD4mH
	uWwipY0q26NW2nVmte8fWzjjV2s89Cl9sdhhc4vaMFhBokhf9QUwJybhoEV1LKfkqP+zliyTx9u
	afsWSADA2bfC96Fui/jf4Aluv/JJTaY6cbdDcYwddxwsD5XfdPLhSglo7C3hW5RFI3LS/ayyrGm
	qmhRWtVcpSWcFPh88kvBxaUpsDL9zOiNgnvPbxwhFRCSLx5VTPFUfjdbgg5HPCLZ+WcppTU9Zyd
	2RrlY9gheHuvGOGaaoB+LK5rMTi9Dtw0gCZJeRrcrqkzi6kjLltto+YMy2v0WHx2wBlRvkKFgS+
	CuZz8J9WOQ8UrFobzJK6N+1Hn00cLNi9w
X-Google-Smtp-Source: AGHT+IGIiRkrlB7/TkXJFGSO/PQUpNROaef3+63DhKxSnenu+T4BXWOlVnoGK2S7Hd7HICX9p45qGQ==
X-Received: by 2002:a05:6a21:99a4:b0:240:17b3:3838 with SMTP id adf61e73a8af0-24340dd75a2mr1470119637.20.1755825477448;
        Thu, 21 Aug 2025 18:17:57 -0700 (PDT)
Received: from localhost.localdomain ([173.214.130.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e8344494dsm8718966b3a.79.2025.08.21.18.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 18:17:56 -0700 (PDT)
From: Qingjie Xing <xqjcool@gmail.com>
To: fw@strlen.de
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	xqjcool@gmail.com
Subject: Re: [PATCH] netfilter: conntrack: drop expectations before freeing templates
Date: Thu, 21 Aug 2025 18:17:56 -0700
Message-Id: <20250822011756.3264808-1-xqjcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aKbIUQ3a3jqijZi0@strlen.de>
References: <aKbIUQ3a3jqijZi0@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks for the careful review and the pointers.

I dug deeper and found the root cause on my side: there was leftover/out-of-tree
 code in my local tree that could attach the per-rule template to skb->_nfct. 
After cleaning up those remnants, upstream behavior matches your description—
nf_conntrack_in() clears any template, tftp_help() sees a real conntrack, 
and I can no longer reproduce the crash.

Apologies for the noise and for any time this cost you. I’ll withdraw the patch 
as it was addressing a problem introduced by my local changes. 

Thanks again for the guidance.
