From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Easy network (config) breakage with 3.17-rc1: NETFILTER_XT_TARGET_LOG
Date: Thu, 21 Aug 2014 12:49:33 +0200
Message-ID: <CACna6rymZjgex0p1snf3e-GvK2xHrQST3roGiA3F__y3DvYhKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44218 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbaHUKte convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:49:34 -0400
Received: by mail-ie0-f175.google.com with SMTP id x19so4471642ier.34
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2014 03:49:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46ew days ago I updated my 3.16 to 3.17-rc1 (both self compiled) and I
was using it until I noticed my machine doesn't respond to pings. I
rebooted to 3.16 and it was working again.

I bisected between 3.16 and 3.17-rc1 but it has failed. After all I
got 3.16 not working anymore as well.

It took me few hours to find the one to blame:
CONFIG_NETFILTER_XT_TARGET_LOG. After moving my config from 3.16 to
3.17-rc1 CONFIG_NETFILTER_XT_TARGET_LOG got disabled because of two
new dependencies: NF_LOG_IPV4 && NF_LOG_IPV6.

It would be nice if you could try to use "select" instead of "depends
on" in such cases in the future. I bet fix my problem would be trivial
since the beginning, but end-users may spent hours or days tracking
such things :(

Please, treat it as an advise/request, not a blaming :)

--=20
Rafa=C5=82
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
