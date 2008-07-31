From: Tobias Koeck <tobias.koeck@gmail.com>
Subject: concurrency problems in a netfilter target extension?
Date: Thu, 31 Jul 2008 16:17:14 +0200
Message-ID: <4891C96A.20004@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:33877 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbYGaORd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:17:33 -0400
Received: by fg-out-1718.google.com with SMTP id 19so281663fgg.17
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2008 07:17:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I=B4m writing on a netfilter target extension.

Are there some possible concurrency problems (means is it possible that=
=20
my target extension modules is loaded several times or could it be used=
=20
with several cpu cores simultaniously)?

If yes what is the best solution for that (which locking functions)?

Greetings and thanks
Tobias

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
