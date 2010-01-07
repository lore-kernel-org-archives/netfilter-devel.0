From: Erik Schweigert <ejschweigert@gmail.com>
Subject: Connection Tracking able to ignore TCP RST under specific conditions?
Date: Thu, 7 Jan 2010 09:24:36 -0800
Message-ID: <ac5590b91001070924t181b9a48hb3c3850eb192d89e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:47089 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0AGRYk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:24:40 -0500
Received: by yxe26 with SMTP id 26so17865044yxe.4
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Jan 2010 09:24:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,

Problem:

I have run into a network implementation that doesn't conform to the
normal. What occurs is a TCP session will do a:

1. SYN
2. SYN,ACK
3. ACK
4. RST,ACK <---- at which point this closes the connection and the
firewall blocks the rest of the connection
5. SYN <--- The whole sequence is re-done but this time without the RST=
,ACK
6. SYN,ACK
7. ACK .
8. PSH,ACK

To permit this traffic initially I have created a connection tracking
helper, the problem is that the RST,ACK removes the expectation for
this session. So when the (5) SYN comes in after the (4)RST,ACK the
firewall blocks the connection.

Attempts:

I have tried creating 2 identical expectations, but the RST,ACK clears
both as the port/ip matches on both.=A0 Another thought I had was to
create a timer to insert another expectation after a certain time
period (not a fan of this idea).

Suggestions:?

Is there a way I can trap the RST,ACK...or ignore the RST,ACK if I
have seen 1,2,3 above?

Erik
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
