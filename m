From: Florian Eckert <eckert.florian@googlemail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20=28fix=5Fled=5Fparse=5Fdelay=29=20value=20will=20now=20be=20set?=
Date: Tue,  6 Aug 2013 15:26:01 +0200
Message-ID: <1375795561-11839-1-git-send-email-Eckert.Florian@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Eckert <Eckert.Florian@googlemail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:64186 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3HFN0a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:26:30 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf20so151137bkc.21
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Aug 2013 06:26:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libxt_LED.c |    2 ++
 1 Datei ge=C3=A4ndert, 2 Zeilen hinzugef=C3=BCgt(+)

diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
index 8622c37..fd1e726 100644
--- a/extensions/libxt_LED.c
+++ b/extensions/libxt_LED.c
@@ -63,6 +63,8 @@ static void LED_parse(struct xt_option_call *cb)
 			xtables_error(PARAMETER_PROBLEM,
 				"Delay value must be within range 0..%u",
 				UINT32_MAX);
+		else
+			led->delay=3Datoi(cb->arg);
 		break;
 	case O_LED_ALWAYS_BLINK:
 		led->always_blink =3D 1;
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
