From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: [PATCH] libnfnetlink-1.0.0 iftable.c:nlif_open() has handler unregister error
Date: Thu, 30 Sep 2010 10:48:14 +0400
Message-ID: <199131285829294@web100.yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----==--bound.19914.web100.yandex.ru"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward8.mail.yandex.net ([77.88.61.38]:36574 "EHLO
	forward8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab0I3G4Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:56:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


------==--bound.19914.web100.yandex.ru
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

struct nlif_handle *nlif_open(void)
{
..........
    if (rtnl_handler_register(h->rtnl_handle, &h->ifadd_handler) < 0)
         goto err_close;
    if (rtnl_handler_register(h->rtnl_handle, &h->ifdel_handler) < 0)
         goto err_unregister;
    return h;
err_unregister:
    rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
err_close:
    rtnl_close(h->rtnl_handle);
    free(h);
err:
    return NULL;
}


Here if was error after rtnl_handler_register(... ifdel_handler...) need to unregister the ifadd_handler,
but in err_unregister: try to unregister the the ifdel_handler.





------==--bound.19914.web100.yandex.ru
Content-Disposition: attachment;
	filename="2.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream;
	name="2.patch"

LS0tIC4vYS9pZnRhYmxlLmMJMjAwOS0wMS0wNyAwNDozMjoyNi4wMDAwMDAwMDAgKzAzMDAKKysr
IC4vYi9pZnRhYmxlLmMJMjAxMC0wOS0zMCAxMDozNTozMC4wMDAwMDAwMDAgKzA0MDAKQEAgLTI0
NSw3ICsyNDUsNyBAQCBzdHJ1Y3QgbmxpZl9oYW5kbGUgKm5saWZfb3Blbih2b2lkKQogCXJldHVy
biBoOwogCiBlcnJfdW5yZWdpc3RlcjoKLQlydG5sX2hhbmRsZXJfdW5yZWdpc3RlcihoLT5ydG5s
X2hhbmRsZSwgJmgtPmlmZGVsX2hhbmRsZXIpOworCXJ0bmxfaGFuZGxlcl91bnJlZ2lzdGVyKGgt
PnJ0bmxfaGFuZGxlLCAmaC0+aWZhZGRfaGFuZGxlcik7CiBlcnJfY2xvc2U6CiAJcnRubF9jbG9z
ZShoLT5ydG5sX2hhbmRsZSk7CiAJZnJlZShoKTsK
------==--bound.19914.web100.yandex.ru--
