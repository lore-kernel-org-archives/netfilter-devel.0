Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1889380FD0
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2026 11:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785844325; cv=none; b=qFKASBVtS/6z61vIkob0TKcLJlAVrXnx7YWxqTl8vHJf21eDG3Hb/rUuXlTXRqS7LkIjp2CSUvsEd+Ho3UxDyjgu4uIq6MT8tHoRLbyR8eZhBVgG0gLvRIa4GHeU4ewlKIZxVLO4+h1eqUbXm+La31Wi4OkNZd1XUTLaNKW+opw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785844325; c=relaxed/simple;
	bh=7odbemieTevSei46wco1gTtKdKjlDLo97GdBpSK23nU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=pYwJswW8gM2KRJOq0yv852oSTTbubO+68Bdgm/8Y583P9iXISJVz2hphiSHFgbkPiJSo7lsBeAzk8hZgzrJ4jEDiv0jSS3nxtzk4ETEnvPpYjsN6QB/k6msVSyaerO6O7b93YSYs6wLRDovx3s4KRt/sToMzmkrGWfxShY/19/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9fdc2870fso2769968a34.2
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Aug 2026 04:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785844322; x=1786449122;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xziqI4y8zX7vEA5aGNXYe+h/nET2zFHHJwmXIIO5aDg=;
        b=hcfTy1iwU/aLBm96SFb01TyasL+76Mbvkt/TruWGC7qHb1RKj9PjQzB6FJLPLC+fpf
         QFKiihvGsfRTpSm7VUL9T75QhMAWyZGhxJTgtnSX11lnKgKCA+PdPhR0JDzE4JS7NKPp
         GodK9o5exkWCqUMC2EFKudFN8h1YUdwkPLt8CjUxXOh7zUKCXtDIDnf5D04W9jsOFmdt
         TEkBo5vqFvKn7cm0hGL5R8RsUYLLKhLXGB+oPMPs3zP5eQzySP50H6DQ8fbK98cfATqr
         FqxFahjKstWLMG4PvZEj3HuCdqrpoyxYWF8WnMt5dDr90PcgWSrHM08CDCAwQZxLHDNp
         P3kA==
X-Forwarded-Encrypted: i=1; AHgh+RqrDxjQDPG6XlXiY2PFETGG3sBXX1p+8KYLwS4+Yd6bDc+IawZsJkP6pbd4rKYEDbNiiKDTvvKHh8O1LCj9JWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEFiBx65CU+tR/bjdTl/ngZA8MT7ov85Nm3Z9Hmqhu0qM+dKvY
	92lvwmhLJDz2xg/Jym4Ukf+D66qmkpc/4Obf56Fozax+BOOZxV5N7fbbD9F+7v43VwJWPADyPw3
	n03J9mZJOVUJnIp1CFsdNmwDQq2jZ/SoOaDeq5X+3LgAOoWnVMAdpe9sNxKQ=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:338e:20b0:6ab:1d3:bbf2 with SMTP id
 006d021491bc7-6ae43331582mr13986984eaf.25.1785844322718; Tue, 04 Aug 2026
 04:52:02 -0700 (PDT)
Date: Tue, 04 Aug 2026 04:52:02 -0700
In-Reply-To: <6a71b141.9511d2ce.1fc5b9.033b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a71d262.40259c87.584f4.04b3.GAE@google.com>
Subject: Re: [syzbot] [netfilter?] WARNING in nf_flow_offload_ip_hook
From: syzbot <syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	eric.dumazet@gmail.com, fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, sdf@fomichev.me, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit a890348adcc993f48d1ae38f1174dc8de4c3c5ac
Author: Stanislav Fomichev <sdf@fomichev.me>
Date:   Mon Aug 18 15:40:32 2025 +0000

    net: Add skb_dst_check_unset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135ab649580000
start commit:   075b74841bd0 Linux 7.2-rc6
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10dab649580000
console output: https://syzkaller.appspot.com/x/log.txt?x=175ab649580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=76d4e3a055aec3b007ec
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14725db9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12581c9e580000

Reported-by: syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
Fixes: a890348adcc9 ("net: Add skb_dst_check_unset")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
