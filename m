Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MriyKu7l"
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101BB12D
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 17:53:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6cbd24d9557so2111711b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 17:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700963637; x=1701568437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zcI+0Muoh1PyNrS2pEY9GIkB7g3gKX9Svj27SHH6qc=;
        b=MriyKu7lUCIr0sXSDuHsENQ2U/S/3549ajoNH7suEWFBhIv0k3mRn/GT230KCj2AaS
         BJjuhe2INeYlB36fjNdDnXrT9NrBUXgh938tUk7s50d2A9gUwOR+bW+YNrXQaYd3Ja/D
         mYMeFgSB2686jyRiGT8bXmUvnOAuO6mP7kg/GzDQLfEvWzlsr2nmRpQqVQbefwnNZ/Y4
         mSSwQkdfmmKGCCzzWQR1iU7Vgpdan2Fw/Piijr4f4UJosV6YjGUyySgRBfTK48XrGIyi
         j6Q/4StA7b+dkBx/2Sld3QWTLwwHCpnU7OU8ltgTAovYlwIOKUf9YKV0TKeYHOmFK+md
         scSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700963637; x=1701568437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8zcI+0Muoh1PyNrS2pEY9GIkB7g3gKX9Svj27SHH6qc=;
        b=xPVv/fQfCPC6UrvUfrVN47LcUVDfxpO2Urd2v0MJ9nCx/3JD8yUEAo0Xk2323O/iNN
         bQCleTxJKd06tvsx2Q6W7WRwh21ITdnh5nZ5N37wziiOBlcq56mgTWK/y6Dsuudz7HTF
         gOD3oc/SOsN/yOqEL8j5Ttl38n4cCWJi1RSJWvMv0Wggjvyowh5j2eazY4x2k3BCFcLS
         xBrxHs/82FdTVB8Jy4/7F4PCt7rdcYrQ2lt3fdHrYTA/vaa1Da1Hglwl7vGQoqAnmd/+
         pqLuxNMNACwaKKqAor7fAGghcYAwQnSdygGMBxqUPTLpXi0j61gDQb2NlmOKxW9ASA67
         i/Mg==
X-Gm-Message-State: AOJu0Yzom+G0RC07Ir+H3+IKTj0++XY6M3g4w7jrbJN7cldO9e06dUZW
	O6nEygcKffCrKQo/LG9cRjiALk7enrs=
X-Google-Smtp-Source: AGHT+IFYwMWBfjk3/HYUar/1RRCPHicLC4Nl8fG7VTUy9ownT8kBMSR7DMoNAYdd0WtSCpSwOK1CkQ==
X-Received: by 2002:a05:6a00:2449:b0:68f:b015:ea99 with SMTP id d9-20020a056a00244900b0068fb015ea99mr9466889pfj.10.1700963637380;
        Sat, 25 Nov 2023 17:53:57 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id s23-20020aa78d57000000b006cbb18865a7sm4893136pfe.154.2023.11.25.17.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Nov 2023 17:53:56 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v5 0/1] src: Add nfq_nlmsg_put2() - user specifies header flags
Date: Sun, 26 Nov 2023 12:53:51 +1100
Message-Id: <20231126015352.17136-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZWBhH235ou6RhYFn@calendula>
References: <ZWBhH235ou6RhYFn@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

This is as you requested, except as below and the sample prints the message
> "This kernel version does not allow to retrieve security context.\n"
(i.e. same as what utils/nfqnl_test.c does) instead of exit(EXIT_FAILURE)
as you suggested.
 Looking at an 80cc man page, I think NLM_F_xxx looks better than NLM_F_*.
 Also the code sample wrapped on the nfq_nlmsg_put2() line, so split it.
 The code sample mixed nlrxbuf and nltxbuf. Now all just buf.
 
 On Fri, Nov 24, 2023 at 09:38:55AM +0100, Pablo Neira Ayuso wrote:
 > On Mon, Nov 20, 2023 at 12:08:49PM +1100, Duncan Roe wrote:
 [...]
 > > +
 > > +/**
 > > + * nfq_nlmsg_put2 - Set up a netlink header with user-specified flags
 > > + *                  in a memory buffer
 > > + * \param *buf Pointer to memory buffer
 > > + * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
 >
 >
 > This can be any value in enum nfqnl_msg_types.
 
 I think not. NFQNL_MSG_PACKET is from kernel to userspace. Have added
 NFQNL_MSG_VERDICT_BATCH to complete the list of allowed values.
 
 Cheers ... Duncan.

Duncan Roe (1):
  src: Add nfq_nlmsg_put2() - user specifies header flags

 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/nlmsg.c                                   | 57 ++++++++++++++++++-
 2 files changed, 57 insertions(+), 1 deletion(-)

-- 
2.35.8

