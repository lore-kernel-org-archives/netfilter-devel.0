Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A85833EE
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2024 04:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712981976; cv=none; b=G29pyK/0eycdxOTlFTQugwWFSzeXJ7Ft7UAOrrbvK5ylOr8QW1Mbd3w82FD6n5yoHHZlkqbnn/+gmNOivmUjURQ/vFx00N0fm1WGzFbxQmYOj0Fj4iH/D1X5R8r1+D5EfBwicZS2YQIFK9UM4slskYIcbq+I48tYLss5QN6ktXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712981976; c=relaxed/simple;
	bh=htwVbUO94Puz8dy523EAR3IuFKG3tY1kAulfSzXxXm4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=BCuIXUtyNfQ/7L0DKJx+d2CKOqBAFtovQLiniKKs0oD7USsoaqFpMRFSkO/FGwp8awvGsAvpjPvMYC6M0x8UqBGgAaZlMRSt8nu7orewM5g9m3m3s4zZMq8t3v/hRTA9puF4IoqJeVyLE/GwrMz48PcOTSoSbd7pd3sE9+TQVhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TPu2LJNs; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TPu2LJNs"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ed0e9ccca1so1435147b3a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 21:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712981974; x=1713586774; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=egO4MCqNXS6pkMNabdTkI0vZx4GJbC6+7HDF9BGwJok=;
        b=TPu2LJNsd8gdO5RI1UHksF+l8UzBecH7h5oGpRrcMSLgnLXEFi81gMEKG2Q40vd/Sm
         uluhzAjdrJ8F4QJbN/IWlGE4yb2IKycsgvqm6UW3Q4RUvr5OTiT9S2sJh4IpSAYJboMe
         GF6+FFgj/wJOu5F5oEVNFr+KS6yYzToMFIQAMl+iBW8P9Vl8zser344YnWf+4muGZo6R
         m5lxq8w8HRvVhE1ohlFmdrvfasisKSzHNN6N5xC2domiLgxeri2T5w63QmkWpq23IMJu
         iMjDylhHBEhTxY/W0kjNyJChPmdRFRwuuCZ8OGfPTWQ3ZcgNdndmd6Xd+oltrz57Xjgm
         GNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712981974; x=1713586774;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=egO4MCqNXS6pkMNabdTkI0vZx4GJbC6+7HDF9BGwJok=;
        b=OVzLOTSxhWXe9bkvks2k2hI0VR9azojlE3bHa9E4aWA3F2PvXg0LKK3Qgk8n7oyuj1
         URh6GV1zDu/TR71n9tyq7Au8/4d8H1BUafbbSQVKtGE7TAkmTfWyzgWVb8f9OXMw37up
         2vB705z+VsTN0VjNCzobG0CvzmxEaJCBvAFCAQdwJT34npo+RTfGt72RDs0zs1Ehb64t
         2YmZj9Bc1tXRcDHNTaM051sI7pjWHzbz7EFbCAdPlCnLDEoZNEXJO6rAB+4pf7S4e+dS
         aYOZPRiuCcuL6l8R1yyvX3cDeJMowH+1jsNKi36245D2hAPdlbzgfvam8VCUF4RTfA0o
         WE6g==
X-Gm-Message-State: AOJu0YzYnvEYQ1TwhGthQG6B48afzkh3j/eRDAkZOJFHj0H1bhHk8htL
	BXXte0d+Upr6guBppSHICqdBJRJBoocFP+7Uqgtbzm7/acmIXfJ6WD2b1/A9Dz/ppxE+BM8X6Ir
	YN3wXKmeZZaSX0qQPR+LFREqp4JTHGKQ7MeRq7g+M
X-Google-Smtp-Source: AGHT+IEghv/KZLZWpJEcdf4XqyuUWNojh9jOBTvIjYSyFa2g/qAGmMbt/OBL/d8rpvphpwKWSdo2db19BjaOcZJFaD0=
X-Received: by 2002:a05:6a20:9794:b0:1a7:bb6d:6589 with SMTP id
 hx20-20020a056a20979400b001a7bb6d6589mr4321289pzc.29.1712981974182; Fri, 12
 Apr 2024 21:19:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: keltargw <keltar.gw@gmail.com>
Date: Sat, 13 Apr 2024 09:19:23 +0500
Message-ID: <CALFUNymhWkcy2p9hqt7eO4H4Hm5t70Y02=XodnpH1zgAZ0cVSw@mail.gmail.com>
Subject: Incorrect dependency handling with delayed ipset destroy ipset 7.21
To: netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Hello.
I have a problem with recent kernels. Due to delayed ipset destroy I'm
unable to destroy ipset that was recently in use by another
(destroyed) ipset. It is demonstrated by this example:

#!/bin/bash
set -x

ipset create qwe1 list:set
ipset create asd1 hash:net
ipset add qwe1 asd1
ipset add asd1 1.1.1.1

ipset destroy qwe1
ipset list asd1 -t
ipset destroy asd1

Second ipset destroy reports an error "ipset v7.21: Set cannot be
destroyed: it is in use by a kernel component".
If this command is repeated after a short delay, it deletes ipset
without any problems.

It seems it could be fixed with that kernel module patch:

Index: linux-6.7.9/net/netfilter/ipset/ip_set_core.c
===================================================================
--- linux-6.7.9.orig/net/netfilter/ipset/ip_set_core.c
+++ linux-6.7.9/net/netfilter/ipset/ip_set_core.c
@@ -1241,6 +1241,9 @@ static int ip_set_destroy(struct sk_buff
  u32 flags = flag_exist(info->nlh);
  u16 features = 0;

+ /* Wait for flush to ensure references are cleared */
+ rcu_barrier();
+
  read_lock_bh(&ip_set_ref_lock);
  s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
     &i);

If you have any suggestions on how this problem should be approached
please let me know. Thanks.
