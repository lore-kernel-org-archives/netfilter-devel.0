Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760F472635
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 09:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748423076; cv=none; b=O782oFlRNTXLMfYCHSRid+gmhaQOVhbD9M+TBkbgEivWgQ8tT+0IVwU9zCkE8TRDyvr7GwtC6o+A96InriWliIYP71I5pu+4lj0tCgadrie4t9YnUJqnYpGAWZSeEXOcO1aSFbRI6AkiHnRoRIg95PbWeHOydQ9l4vtWuIFxfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748423076; c=relaxed/simple;
	bh=3uDmyrsp6xjEBa0Qb+3+OQwDROzBufrRyvKtii9ulWE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=h/sfrk/GJjUkfLvg6+lJgOLAgMKQ4D86A4XCkYhXL96iDn5cPhQxDgu5gB7JL/TD3K5UAw36IUnewMXND6cE171szWiSy5Sm1+N0TNNFflZLRjVr0FhWsQbfyzJtNLse0CiUvpRLzEtzwS5RL5XlQI5kFHigK0UfYSonZDVnk9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X2CudUft; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X2CudUft"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6f8a70fe146so75760776d6.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 02:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748423073; x=1749027873; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d2bmT55A7QwGYJxK5ynm+7d2vA+P4sXeGsJtAbZlYos=;
        b=X2CudUftpyRMgdsWzPcHAV4pXGQYDm4QS1LdGeMol76yhauwZwPwlXxHuX/zVp2Ub9
         TenS9NsZiquSb97jAf2d9Nrop9pRU4mzak1KJjfTs6mjTWgQ8D9XidBfwNjwi+IYSMs6
         gkXBZ7w9X88umQTevKAr5oz/YK6dytdqIt1+QLehGEv1m0HihjiEGN9fYzwtjXXw9JP0
         GlZSZiEDQw5GOJtuAa1f0xeCZS+tp6RYsok7vkamtOVuWPe4VcNlpkqd70pZEg8tJmaB
         jlSysKtX3orVwHu7N3AqQe3vrci6vCP5cSvczxHekQFI+Rcvm0EBJFoUzaglCzPl+M2R
         nv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748423073; x=1749027873;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d2bmT55A7QwGYJxK5ynm+7d2vA+P4sXeGsJtAbZlYos=;
        b=m8g6SmfAt61Sqp/HgJUXr494IgmFeOAZU9Up8yoaVMjsEJUmgCVVDi8bQdLaTCHoYx
         xSQqSKvYpO7qTuJKPogBqThGEaEpcBvucn2ScpbJc6fvwq0g6990Iw8Nn8RDksf2pJQT
         EDuPpvT4mzYjeDGOFqd3uA6TlyYze0MkZfTagyfPXAvMl69dxCdADo/vqYwMlTDO7VtI
         M5Q75J05VQJrSkkahiK8H4dtqZedXWbW90R/Hr5vE5XlAW+qE1uFeYrFLPbGgfYkqsJg
         27lEZXjGdFSJGRpToCC7wKiW6A1/SWsvV9Q1yEKv1IwcOjiF8Hoc27ENmPHQazwxi2i6
         TwAw==
X-Gm-Message-State: AOJu0YzZGp1R2D9ZBSlx0fftGvAqpGluOmwgz+6e059a8r/CbprgHLQu
	C3RlY1eDcTIXKEDKBeTVxtYePVW15StwOU6oI38TACCX2zefg5+qCYyiotYHaOXN/J8Z66MTpjq
	ycuBgT8tGDL2FXrOVp8ETqSlJ4HrgR5s=
X-Gm-Gg: ASbGncsjZLSb59O+BJdmVaBYGEc1PsLWKwGjOGTzxDOH3iz0s8G9P1LJv6UtoV0rSsx
	yNvZPuNASMXhUn3/39/erpCuvaben/21zmQ6Bcd9yCYrrph6IsHyNtvlob+1cDvQkv2wVeSDYWy
	ArAQuso4c+18QbHhpjBD8gt4KzfNGLtRAd61vx+5svJqw0
X-Google-Smtp-Source: AGHT+IEIM3zNbWihCSRC5O2TUlvQUPeM97D5pVxSaOSX/F1y3N7wJ9wwyuG62DcAJVj5t722EahoKT38u5kBx/nRfuw=
X-Received: by 2002:a05:6214:2482:b0:6f5:38a2:52dd with SMTP id
 6a1803df08f44-6fa9d31baccmr283212756d6.31.1748423073167; Wed, 28 May 2025
 02:04:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 28 May 2025 17:03:56 +0800
X-Gm-Features: AX0GCFt71AYj8M_avcs7ErH_C3hcMUN0QV-z_xowbxFLIdEgNTRwJC42GbppsgI
Message-ID: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
Subject: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Hello,

We recently encountered an SNAT-related issue in our Kubernetes
environment and have successfully reproduced it with the following
configuration:

kernel
--------
Our kernel is 6.1.y (also reproduced on 6.14)

Host Network Configuration:
--------------------------------------

We run a DNS proxy on our Kubernetes servers with the following iptables rules:

-A PREROUTING -d 169.254.1.2/32 -j DNS-DNAT
-A DNS-DNAT -d 169.254.1.2/32 -i eth0 -j RETURN
-A DNS-DNAT -d 169.254.1.2/32 -i eth1 -j RETURN
-A DNS-DNAT -d 169.254.1.2/32 -i bond0 -j RETURN
-A DNS-DNAT -j DNAT --to-destination 127.0.0.1
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A POSTROUTING -j KUBE-POSTROUTING
-A KUBE-POSTROUTING -m mark --mark 0x4000/0x4000 -j MASQUERADE

Container Network Configuration:
--------------------------------------------
Containers use 169.254.1.2 as their DNS resolver:

$ cat /etc/resolve.conf
nameserver 169.254.1.2

Issue Description
------------------------

When performing DNS lookups from a container, the query fails with an
unexpected source port:

$ dig +short @169.254.1.2 A www.google.com
;; reply from unexpected source: 169.254.1.2#123, expected 169.254.1.2#53

The tcpdump is as follows,

16:47:23.441705 veth9cffd2a4 P   IP 10.242.249.78.37562 >
169.254.1.2.53: 298+ [1au] A? www.google.com. (55)
16:47:23.441705 bridge0 In  IP 10.242.249.78.37562 > 127.0.0.1.53:
298+ [1au] A? www.google.com. (55)
16:47:23.441856 bridge0 Out IP 169.254.1.2.53 > 10.242.249.78.37562:
298 1/0/1 A 142.250.71.228 (59)
16:47:23.441863 bond0 Out IP 169.254.1.2.53 > 10.242.249.78.37562: 298
1/0/1 A 142.250.71.228 (59)
16:47:23.441867 eth1  Out IP 169.254.1.2.53 > 10.242.249.78.37562: 298
1/0/1 A 142.250.71.228 (59)
16:47:23.441885 eth1  P   IP 169.254.1.2.53 > 10.242.249.78.37562: 298
1/0/1 A 142.250.71.228 (59)
16:47:23.441885 bond0 P   IP 169.254.1.2.53 > 10.242.249.78.37562: 298
1/0/1 A 142.250.71.228 (59)
16:47:23.441916 veth9cffd2a4 Out IP 169.254.1.2.124 >
10.242.249.78.37562: UDP, length 59

The DNS response port is unexpectedly changed from 53 to 124, causing
the application can't receive the response.

We suspected the issue might be related to commit d8f84a9bc7c4
("netfilter: nf_nat: don't try nat source port reallocation for
reverse dir clash"). After applying this commit, the port remapping no
longer occurs, but the DNS response is still dropped.

16:52:00.968814 veth9cffd2a4 P   IP 10.242.249.78.54482 >
169.254.1.2.53: 15035+ [1au] A? www.google.com. (55)
16:52:00.968814 bridge0 In  IP 10.242.249.78.54482 > 127.0.0.1.53:
15035+ [1au] A? www.google.com. (55)
16:52:00.996661 bridge0 Out IP 169.254.1.2.53 > 10.242.249.78.54482:
15035 1/0/1 A 142.250.198.100 (59)
16:52:00.996664 bond0 Out IP 169.254.1.2.53 > 10.242.249.78.54482:
15035 1/0/1 A 142.250.198.100 (59)
16:52:00.996665 eth0  Out IP 169.254.1.2.53 > 10.242.249.78.54482:
15035 1/0/1 A 142.250.198.100 (59)
16:52:00.996682 eth0  P   IP 169.254.1.2.53 > 10.242.249.78.54482:
15035 1/0/1 A 142.250.198.100 (59)
16:52:00.996682 bond0 P   IP 169.254.1.2.53 > 10.242.249.78.54482:
15035 1/0/1 A 142.250.198.100 (59)

The response is now correctly sent to port 53, but it is dropped in
__nf_conntrack_confirm().

We bypassed the issue by modifying __nf_conntrack_confirm()  to skip
the conflicting conntrack entry check:

diff --git a/net/netfilter/nf_conntrack_core.c
b/net/netfilter/nf_conntrack_core.c
index 7bee5bd22be2..3481e9d333b0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1245,9 +1245,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)

        chainlen = 0;
        hlist_nulls_for_each_entry(h, n,
&nf_conntrack_hash[reply_hash], hnnode) {
-               if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
-                                   zone, net))
-                       goto out;
+               //if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+               //                  zone, net))
+               //      goto out;
                if (chainlen++ > max_chainlen) {
 chaintoolong:
                        NF_CT_STAT_INC(net, chaintoolong);

DNS resolution now works as expected.

$ dig +short @169.254.1.2 A www.google.com
142.250.198.100

 The tcpdump is as follows,

16:54:43.618509 veth9cffd2a4 P   IP 10.242.249.78.56805 >
169.254.1.2.53: 7503+ [1au] A? www.google.com. (55)
16:54:43.618509 bridge0 In  IP 10.242.249.78.56805 > 127.0.0.1.53:
7503+ [1au] A? www.google.com. (55)
16:54:43.618666 bridge0 Out IP 169.254.1.2.53 > 10.242.249.78.56805:
7503 1/0/1 A 142.250.198.100 (59)
16:54:43.618677 bond0 Out IP 169.254.1.2.53 > 10.242.249.78.56805:
7503 1/0/1 A 142.250.198.100 (59)
16:54:43.618683 eth1  Out IP 169.254.1.2.53 > 10.242.249.78.56805:
7503 1/0/1 A 142.250.198.100 (59)
16:54:43.618700 eth1  P   IP 169.254.1.2.53 > 10.242.249.78.56805:
7503 1/0/1 A 142.250.198.100 (59)
16:54:43.618700 bond0 P   IP 169.254.1.2.53 > 10.242.249.78.56805:
7503 1/0/1 A 142.250.198.100 (59)
16:54:43.618765 veth9cffd2a4 Out IP 169.254.1.2.53 >
10.242.249.78.56805: 7503 1/0/1 A 142.250.198.100 (59)

The issue remains present in kernel 6.14 as well.

Since we are not deeply familiar with NAT behavior, we would
appreciate guidance on a proper fix or any further debugging.

--
Regards
Yafang
