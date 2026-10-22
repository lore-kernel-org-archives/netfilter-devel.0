Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792689606;
	b=kBCdXroL4Yyn/BGb0/9qRDS4hTpDSi4Mjhi/iXk3Shi8/qg6bIXIOO53XmMVDP9FT6rk
	 f1WCY+Rl12IAwuZAqsxT7kYIS8aeBn60oCd3/JTa5k+DkFsDhfDGj68kfDGYRJ6dK93Re
	 cAIm8NVyg1KucwJ2Q1GXSbkzDmjg7YZGYCMkAdCAlRATIpbVChuFf5kr3V+jdroXucwhq
	 pnyA3cBVTcJsrzpDdgxoMAUGym05r6FY45EFws/OyhE5R61qu3d/vHBfewRONWCjA1Phg
	 fFaf1i5PXot62IRiBOpvFfDT7XHV2M7SmMKSYju4CJS6yC/I7FSKFI6pc+xpQRmDgfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792689606;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=4UT4wBei7lo5P9ke+g//ajLXiPvxYYsQ7T5yHwgF27o=;
	b=QDl7NIC1d049ZbaqZuV9M8IUk53m6lt0a+D+INra9LnHiWF7h+wBZz2QM4sq0zaztgXG
	 HXmpJmWRvtIBdcpyWcci2tQnp7w63Tr3QFyXqD4saJuhpZIjD3RliHZHV3wHu8P0rmFmB
	 OUYdMIwrAV3iT2OPvp4nmaZM9A5O70Xtn/yfUEEBxaCYEpYVabLYNUydTfpNj98y3jClA
	 aZdv/RzNEFGLvP0BReRpQmHIGY3aoSY7yOVTEsuzLKIMpKrSLrqbUV9pjZnuqutRCvgNZ
	 /MAGWeKEvrBqzqjKKWgG238ULDoTlSY3MjhNc+ZV0sETh5UTwncI9oSq0R2UTlXO4Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4583B606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4583B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-5384e381fbbso102162b6e.2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 10:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792689605; x=1793294405;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4UT4wBei7lo5P9ke+g//ajLXiPvxYYsQ7T5yHwgF27o=;
        b=MKhYDKIM6R1EfnTW5bQmitdVvOrNm0XFRmxDrBKRYDJDeq/baJSThXPWBuNhqHXIp9
         FR4NiFIdpLsrWS4TtbIDHT6iG8aQTdo0j8XS9LcGaZpibfCATupkc8ONWN4L4Bm9V5EQ
         axCncOLD2APiuJIsFcnPeEw56ATk46xkX5t2QPH3KtOFDKhQEitclZOUfGFFsT2R/MW5
         25FwN5z4slOBT+TmIHFFluTHAl0E7reOLqGRCEsBpdBHl6AU5QqLHmY7LJx+nfH1yI+t
         xVl+jqIB4B44oEIWoMk9sA/a7lMWnUKn1dL2wyNQnZyfBrjvZziYEAcCVjarOd9e5D2M
         vfKQ==
X-Forwarded-Encrypted: i=1; AKwUvByxKY64XIhspCQCv8pzdYpyL5DgAusfwkRxGObSJXvw7uMX71MDpDNnwbnHNn7a7U+tOTPMo0Vwe7fSAm08lOQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYI1vuIpnqgGCJ3LFciIcwFhoJAR92RZDBWT9eXy0sDN2ycDBFbd
	/+jutPeRDs+xfDsmjSs2fxEpnQCzJQA2GbisPa6kU5yPebxrz4vg0+PAkpoguXbglataxFo+hOP
	X8+grTgMzTvWBfBT4aCe7Wfnd7fPBrNVZ3NSFiyrLUDM9gsNNeAcKdQcUT0k=
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fe1:b0:4f2:f229:1895 with SMTP id
 5614622812f47-5535c2846ddmr5380130b6e.43.1792689605345; Thu, 22 Oct 2026
 10:20:05 -0700 (PDT)
Date: Thu, 22 Oct 2026 10:20:05 -0700
In-Reply-To: <CAO+rqLgLRszT2U_x49hYVULuJ6Lm-80EdokzQUyNO_mECKEvKA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ada45c5.d1c214cc.659fa.00dd.GAE@google.com>
Subject: Re: [syzbot] [netfilter?] WARNING in nf_flow_table_extend_ct_timeout
From: syzbot <syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	edumazet@kernel.org, fw@strlen.de, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, mike.michalo@gmail.com, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/main: failed to run ["git" "-c" "core.hooksPath=/dev/null" "fetch" "--force" "675adff2843877c2da27b36b2517f827bc9915ea" "main"]: exit status 128


Tested on:

commit:         [unknown 
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git main
kernel config:  https://syzkaller.appspot.com/x/.config?x=c4b098695335c89f
dashboard link: https://syzkaller.appspot.com/bug?extid=521f7e7e2b974abde99a
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=115f4d0d580000

