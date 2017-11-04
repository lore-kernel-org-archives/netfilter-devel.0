From: Tomas Mudrunka <mudrunka@spoje.net>
Subject: [PATCH] parser: allow classid as set key
Date: Sat, 04 Nov 2017 14:58:31 +0100
Message-ID: <82fb1bfd1c56c2410a59c3c207393fa5@spoje.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_e8893ea5d6fee56e6955924bb3469dfa"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.spoje.net ([82.100.58.2]:47762 "EHLO mail.spoje.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756662AbdKDOFu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2017 10:05:50 -0400
Received: from localhost (mail.spoje.net [127.0.0.1])
        by mail.spoje.net (Postfix) with ESMTP id 86C6944118
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Nov 2017 14:58:33 +0100 (CET)
Received: from mail.spoje.net ([127.0.0.1])
        by localhost (mail.spoje.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aNNZzzzZuVsz for <netfilter-devel@vger.kernel.org>;
        Sat,  4 Nov 2017 14:58:31 +0100 (CET)
Received: from mail.spoje.net (mail.spoje.net [127.0.0.1])
        by mail.spoje.net (Postfix) with ESMTP id 186D844114
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Nov 2017 14:58:31 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--=_e8893ea5d6fee56e6955924bb3469dfa
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

Hello,
can you please include this patch in nftables?

THX.

-- 
S pozdravem
Best regards
      Tomáš Mudruňka - SPOJE.NET s.r.o.
--=_e8893ea5d6fee56e6955924bb3469dfa
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=classid-map.patch
Content-Disposition: attachment;
 filename=classid-map.patch;
 size=766

cGFyc2VyOiBhbGxvdyBjbGFzc2lkIGFzIHNldCBrZXkKCkZyb206IEFydHVybyBCb3JyZXJvIEdv
bnphbGV6IDxhcnR1cm9AbmV0ZmlsdGVyLm9yZz4KCkFsbG93IFRDIGNsYXNzaWQgYXMgc2V0IGtl
eS4KClNpZ25lZC1vZmYtYnk6IEFydHVybyBCb3JyZXJvIEdvbnphbGV6IDxhcnR1cm9AbmV0Zmls
dGVyLm9yZz4KUmVwb3J0ZWQtYnk6IFRvbWFzIE11ZHJ1bmthIDxtdWRydW5rYUBzcG9qZS5uZXQ+
ClRlc3RlZC1ieTogVG9tYXMgTXVkcnVua2EgPG11ZHJ1bmthQHNwb2plLm5ldD4KLS0tCiBzcmMv
cGFyc2VyX2Jpc29uLnkgfCAgICAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoK
ZGlmZiAtLWdpdCBhL3NyYy9wYXJzZXJfYmlzb24ueSBiL3NyYy9wYXJzZXJfYmlzb24ueQppbmRl
eCA3MDE2ZjViLi4yOTE4ODc1IDEwMDY0NAotLS0gYS9zcmMvcGFyc2VyX2Jpc29uLnkKKysrIGIv
c3JjL3BhcnNlcl9iaXNvbi55CkBAIC0xNTQ1LDYgKzE1NDUsNyBAQCB0eXBlX2lkZW50aWZpZXIJ
CToJU1RSSU5HCXsgJCQgPSAkMTsgfQogCQkJfAlNQVJLCXsgJCQgPSB4c3RyZHVwKCJtYXJrIik7
IH0KIAkJCXwJRFNDUAl7ICQkID0geHN0cmR1cCgiZHNjcCIpOyB9CiAJCQl8CUVDTgl7ICQkID0g
eHN0cmR1cCgiZWNuIik7IH0KKwkJCXwJQ0xBU1NJRCB7ICQkID0geHN0cmR1cCgiY2xhc3NpZCIp
OyB9CiAJCQk7CiAKIGhvb2tfc3BlYwkJOglUWVBFCQlTVFJJTkcJCUhPT0sJCVNUUklORwkJZGV2
X3NwZWMJUFJJT1JJVFkJcHJpb19zcGVjCg==
--=_e8893ea5d6fee56e6955924bb3469dfa--

