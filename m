From: David Miller <davem@davemloft.net>
Subject: Fw: [PATCH net-2.6 1/2] [IPV4] [NETFILTER] Misc Cleanups.
Date: Sun, 01 Jun 2008 23:45:49 -0700 (PDT)
Message-ID: <20080601.234549.229050768.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Sun_Jun__1_23_45_49_2008_086)--"
Content-Transfer-Encoding: 7bit
Cc: ramirose@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55698
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbYFBGpx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:45:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----Next_Part(Sun_Jun__1_23_45_49_2008_086)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Forwarding to netfilter-devel where this belongs...


----Next_Part(Sun_Jun__1_23_45_49_2008_086)--
Content-Type: Message/Rfc822
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Return-Path: <ramirose@gmail.com>
X-Original-To: davem@davemloft.net
Delivered-To: davem@davemloft.net
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by sunset.davemloft.net (Postfix) with ESMTP id E1AD0C8C2D5
	for <davem@davemloft.net>; Sun,  1 Jun 2008 23:38:33 -0700 (PDT)
Received: by rv-out-0506.google.com with SMTP id f6so805787rvb.53
        for <davem@davemloft.net>; Sun, 01 Jun 2008 23:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:message-id:date:from:to:subject:mime-version:content-type;
        bh=JZrb8GF3FrxUrsqwaBXMYI9vOkGQnAD54a0nhzGDNr0=;
        b=J9rNzpCsI7nN2ytM4APDJ6SHIMQ/KT0WxscpRxq06lEzKAAJHzRr/1wHaP+nvGSk0IuuY+CIKMxZ1Z9ZBNKtRkZA2O9sPq13Z78potBNvGAsPPSIuqdKgVp4dy4JvNLLbUpDr9hC143kCeo0KIUELZLjEB3cxKm77raM9U8ajOI=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=rNiotQ6GMEgwd8QMZjuOgTXRHV+kMV7hMI8m+p31RsTmB28XGfUPauegOH64i0W3bpVMyH1oh0zAoKUi6T3RaSbZMEWXgPSEd+VlyJtkEjlaO9LrLxqEU2meoI6MjD7mcY7FrDfun8Bdvp09yLWTNi922C3ZgSr3F/ESUfY8N94=
Received: by 10.140.166.21 with SMTP id o21mr4737318rve.167.1212388716643;
        Sun, 01 Jun 2008 23:38:36 -0700 (PDT)
Received: by 10.141.176.19 with HTTP; Sun, 1 Jun 2008 23:38:36 -0700 (PDT)
Message-ID: <eb3ff54b0806012338o74a3428fp668a84ea665adc30@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:38:36 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-2.6 1/2] [IPV4] [NETFILTER] Misc Cleanups.
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_9878_8040758.1212388716650"

------=_Part_9878_8040758.1212388716650
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

	In this patch, these three fixes were made in net/ipv4/netfilter/ip_queue.c:
	
	1) No need to perform data_len = 0 in the switch command, since data_len
	   is initialized to 0 in the beginning of the method
,ipq_build_packet_message().
		
	2) We can reach nlmsg_failure only from one place; skb is sure to be NULL
	   when getting there; since skb is NULL, there is no need to check this fact
	   and call kfree_skb().
	
	3) Add #ifdef CONFIG_PROC_FS when removing the VFS entry,
 		 proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
	

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_9878_8040758.1212388716650
Content-Type: text/plain; name=patch1.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyoweo40
Content-Disposition: attachment; filename=patch1.txt

ZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9xdWV1ZS5jIGIvbmV0L2lwdjQvbmV0
ZmlsdGVyL2lwX3F1ZXVlLmMKaW5kZXggMjZhMzdjZS4uN2JjM2EyOSAxMDA2NDQKLS0tIGEvbmV0
L2lwdjQvbmV0ZmlsdGVyL2lwX3F1ZXVlLmMKKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX3F1
ZXVlLmMKQEAgLTE1Niw3ICsxNTYsNiBAQCBpcHFfYnVpbGRfcGFja2V0X21lc3NhZ2Uoc3RydWN0
IG5mX3F1ZXVlX2VudHJ5ICplbnRyeSwgaW50ICplcnJwKQogCWNhc2UgSVBRX0NPUFlfTUVUQToK
IAljYXNlIElQUV9DT1BZX05PTkU6CiAJCXNpemUgPSBOTE1TR19TUEFDRShzaXplb2YoKnBtc2cp
KTsKLQkJZGF0YV9sZW4gPSAwOwogCQlicmVhazsKIAogCWNhc2UgSVBRX0NPUFlfUEFDS0VUOgpA
QCAtMjI0LDggKzIyMyw2IEBAIGlwcV9idWlsZF9wYWNrZXRfbWVzc2FnZShzdHJ1Y3QgbmZfcXVl
dWVfZW50cnkgKmVudHJ5LCBpbnQgKmVycnApCiAJcmV0dXJuIHNrYjsKIAogbmxtc2dfZmFpbHVy
ZToKLQlpZiAoc2tiKQotCQlrZnJlZV9za2Ioc2tiKTsKIAkqZXJycCA9IC1FSU5WQUw7CiAJcHJp
bnRrKEtFUk5fRVJSICJpcF9xdWV1ZTogZXJyb3IgY3JlYXRpbmcgcGFja2V0IG1lc3NhZ2VcbiIp
OwogCXJldHVybiBOVUxMOwpAQCAtNjEwLDcgKzYwNyw5IEBAIGNsZWFudXBfc3lzY3RsOgogCXVu
cmVnaXN0ZXJfc3lzY3RsX3RhYmxlKGlwcV9zeXNjdGxfaGVhZGVyKTsKICNlbmRpZgogCXVucmVn
aXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyKCZpcHFfZGV2X25vdGlmaWVyKTsKKyNpZmRlZiBDT05G
SUdfUFJPQ19GUwogCXByb2NfbmV0X3JlbW92ZSgmaW5pdF9uZXQsIElQUV9QUk9DX0ZTX05BTUUp
OworI2VuZGlmCQogY2xlYW51cF9pcHFubDogX19tYXliZV91bnVzZWQKIAluZXRsaW5rX2tlcm5l
bF9yZWxlYXNlKGlwcW5sKTsKIAltdXRleF9sb2NrKCZpcHFubF9tdXRleCk7Cgo=
------=_Part_9878_8040758.1212388716650--

----Next_Part(Sun_Jun__1_23_45_49_2008_086)----
