From: David Miller <davem@davemloft.net>
Subject: Fw: [PATCH net-2.6 2/2] [IPV4] [NETFILTER] Misc Cleanups.
Date: Sun, 01 Jun 2008 23:46:15 -0700 (PDT)
Message-ID: <20080601.234615.204287317.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Sun_Jun__1_23_46_15_2008_487)--"
Content-Transfer-Encoding: 7bit
Cc: ramirose@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55701
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbYFBGqT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:46:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----Next_Part(Sun_Jun__1_23_46_15_2008_487)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Also forwarding to netfilter-devel, where it belongs.

----Next_Part(Sun_Jun__1_23_46_15_2008_487)--
Content-Type: Message/Rfc822
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Return-Path: <ramirose@gmail.com>
X-Original-To: davem@davemloft.net
Delivered-To: davem@davemloft.net
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by sunset.davemloft.net (Postfix) with ESMTP id 15258C8C2D5
	for <davem@davemloft.net>; Sun,  1 Jun 2008 23:40:17 -0700 (PDT)
Received: by rv-out-0506.google.com with SMTP id f6so806354rvb.53
        for <davem@davemloft.net>; Sun, 01 Jun 2008 23:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:message-id:date:from:to:subject:mime-version:content-type;
        bh=Y6D6v3MaxyRexbfWsWMXI086CKtSmuyYUIIjj/m7nz4=;
        b=hNZ7WR7ix9rsk3aXWxqz9yww3mWe8NjWY9Dj/ewekjlQWl7ONdyLPo1uk69aJfZ7fQyWLVz/OSKU1aFYVBcNYIevLZf23kH9qpaLqnt32QQPBOnTzzDmUEAAIu8Vgcote2hDyE9bcUrF2+DsNebYYd9VgmRDcoW+oJfRYAl/CBo=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=lQ6aGNwoIv6xIx/fiRAdOEV8CNu5TbKJ98RyIQYiigSd3q5nYxRfLJbGlyYD+w2LsBvgm/vJhdQrW4iKNcHqrkQF43M3z5UfMMkk/HXe165QwaRUunV/ZImph6LEXu8yn7TdnfV5qu52wlBAkQaby1yyAX3jkrtqm8Qn6ThzMCo=
Received: by 10.140.226.13 with SMTP id y13mr4749794rvg.2.1212388819608;
        Sun, 01 Jun 2008 23:40:19 -0700 (PDT)
Received: by 10.141.176.19 with HTTP; Sun, 1 Jun 2008 23:40:19 -0700 (PDT)
Message-ID: <eb3ff54b0806012340v448b8b84p32ab8995e755322e@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:40:19 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-2.6 2/2] [IPV4] [NETFILTER] Misc Cleanups.
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_9881_21176922.1212388819609"

------=_Part_9881_21176922.1212388819609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This patch removes nf_ct_ipv4_ct_gather_frags() method declaration from
include/net/netfilter/ipv4/nf_conntrack_ipv4.h, since it is unused in
the Linux kernel.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_9881_21176922.1212388819609
Content-Type: text/plain; name=patch2.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyoxwjg0
Content-Disposition: attachment; filename=patch2.txt

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L25ldGZpbHRlci9pcHY0L25mX2Nvbm50cmFja19pcHY0
LmggYi9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvaXB2NC9uZl9jb25udHJhY2tfaXB2NC5oCmluZGV4
IDliZjA1OTguLjc1NzNkNTIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L25ldGZpbHRlci9pcHY0
L25mX2Nvbm50cmFja19pcHY0LmgKKysrIGIvaW5jbHVkZS9uZXQvbmV0ZmlsdGVyL2lwdjQvbmZf
Y29ubnRyYWNrX2lwdjQuaApAQCAtOSw4ICs5LDYgQEAKICNpZm5kZWYgX05GX0NPTk5UUkFDS19J
UFY0X0gKICNkZWZpbmUgX05GX0NPTk5UUkFDS19JUFY0X0gKIAotLyogUmV0dXJucyBuZXcgc2tf
YnVmZiwgb3IgTlVMTCAqLwotc3RydWN0IHNrX2J1ZmYgKm5mX2N0X2lwdjRfY3RfZ2F0aGVyX2Zy
YWdzKHN0cnVjdCBza19idWZmICpza2IpOwogCiBleHRlcm4gc3RydWN0IG5mX2Nvbm50cmFja19s
M3Byb3RvIG5mX2Nvbm50cmFja19sM3Byb3RvX2lwdjQ7Cgo=
------=_Part_9881_21176922.1212388819609--

----Next_Part(Sun_Jun__1_23_46_15_2008_487)----
