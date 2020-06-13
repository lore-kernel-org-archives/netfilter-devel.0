Return-Path: <SRS0=hyDR=72=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440FCC433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jun 2020 20:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1FE5207BC
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jun 2020 20:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sbcglobal.net header.i=@sbcglobal.net header.b="gbCJy5Gu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgFMU3P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jun 2020 16:29:15 -0400
Received: from sonic308-12.consmr.mail.ne1.yahoo.com ([66.163.187.35]:41019
        "EHLO sonic308-12.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726442AbgFMU3O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jun 2020 16:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sbcglobal.net; s=s2048; t=1592080153; bh=MzT4MrYKGG/TnJp/WrLwRI9l4ZHwYZszf7JT0OkKBcs=; h=To:From:Subject:Date:References:From:Subject; b=gbCJy5GuHM5+ePM0JgNTVeHSim8odtVk8laY+P6btBueJ660fF+o5UnXUCogN0YqnHC4AVydH7vs+clJInP6rGWOzJYL5OUmLBb3WcOAVNXorjGwYQBjTtbiPT8u4gKz93p/XOf3KzXka/p29EVq4OrrCsionkkL5PadxHSj/x0AN+nfBOWGa8nkVy0sr/fC8u1Vi/fn4aHVPeFgsrm97kxSfWpL6T+7hWu5cwKNUEMPgy8PqxWZUel7QDMjz4E+AzdEUJtCH7HnA+t5cJKV/Xup5fF8b/KaY5dFjpYAOPImOsi/2b7jpDWmqO5IaJlu4tpy7zQcB1oBM+7nZJjWiA==
X-YMail-OSG: Na_U5zEVM1mXXJ8lgu7.2X0pPRgqoyQl1K8NURKBkroBTrRFwTKLQarryON2yT_
 Tyr8OIC9GMgLyhbCnZDS4dKOW9slUbm7Moggiiui4sDLbseUJIph3v.egUskX6ZpzSEvNiKYdESh
 8pgOwsxiDGP28oaKqiVAvktQHVZmywMUEgiptKJSgMbEbs42L9mf97qbe2UJfmSHeh72mjz9Aj8V
 .ejcoYS6ti8P82tkD0jvQpq8pW4B5cQHXsoD5JOatQB5kb5YOi1CDjLy8uy5Mzyp3N4aFM2gZjD9
 gYFKyvhbpLXZHgY7vxaIoSNITPRkE_LtyyYsLjK76UNN60hMis93NgClggpczVTLJl2Moo7Y37Dq
 ivhex_1dWysvE8j2iJcDaMvgVewrmkUuOAZHoJD1t5Lk4HyBmwckXX6t994DbbZ0PNMngdig5Hm5
 d8qdehLTZiU7OyNgy6Pr9rQeGuA.SOcoTSV320jHjP6zeIOlINwxCvSplCm6GekllOcVgKI87Ymb
 9ufpYBt86uo5f8M4mPWgafEkh3ZJbY19L6YXYfnN5PG2EvAlrzAXUFpdT761N9I102TKEN3PUCJ9
 Hwheuj9CkcAiZCdRTZJ2.pXDTbT0.KOPViqjm5LOLqZxh4qbHfSbLr35ef6v4PNgnNV3RXg7Jo51
 m2cLJAlJo9wMemtiMn9ZdcYUfMSoP.j1wBvW56ES3xU9M1ymZtWAZIHThoyUiQgfN0zANhN1avHd
 ou7LDZEvT_Ka2ZgVG3GnmOhNSWss9Tv58gtDrYqzwOcCHwZKjWUMpkD.h7qwIKcYyWRw05Cf83fW
 ghQa45sIYbzcOESh9XPfwZEOIEh2CgjEG5mN2.uLJa.lEEAOjdr3MrcfdcEPkB.C68oTsU6LLgod
 V0MT5mYb8AX4YS28ZvkJGTsgvQ5XJTOUGQL2EjBR_WX4Rh7mqxR1rgaOKimL2ycgJbfD66jvWsY5
 F1b1J1hSUekzSw0HAQa1n5G.U76fsJ4.EowqiPAZDJO6iYU7Y5G8UwLmK.MXffFrTIygJx9pLKdt
 A7CN2kXvDQkl6qxtoh3ydCPLSdSxHyR4.Qr97ktH2K.gusKRs2mGqTIoaTZvHtp.UNmSDO2lnO1z
 YWwJvwsSJP4uowkG63qpjNcaBkaMCpwQanuShdW3ViTO1CXdCoLFcdeVfndCs514pGxpbsC1kNaX
 IXbAXM15flrU4917w9XOKSMvu2sxHXDIq3op5A9iVqVe7Q6ldEWvlNa1ISkaDe3TUZ08TgM_F_6c
 eLZu2AcAsXchhkv.LO27DJEhY5icGwgKMyxSAeCh0Z0EmDqhRjLtEtKDh3XldpCGJcgQOZK8CgV4
 RfkSwCf.uV3kV8NP7xjRmce4R5MkI2ggGHb51BHOMHkD.n0CJ82xUd_FQODmC_S8uJJ6f4N8j8Jn
 Iai36FH1z3A--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Sat, 13 Jun 2020 20:29:13 +0000
Received: by smtp420.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 486b4269369d8d6769e424b57e02feab;
          Sat, 13 Jun 2020 20:29:09 +0000 (UTC)
To:     netfilter-devel@vger.kernel.org
From:   "SBCGlobal.Net" <s.egbert@sbcglobal.net>
Subject: Vim Syntax for NFTABLES -- Beta
Message-ID: <eb966605-d7e5-ee15-133f-d4d4faa0bb82@sbcglobal.net>
Date:   Sat, 13 Jun 2020 16:29:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101
 Thunderbird/77.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
References: <eb966605-d7e5-ee15-133f-d4d4faa0bb82.ref@sbcglobal.net>
X-Mailer: WebService/1.1.16119 hermes_yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.6)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All those who are using Vim as an editor and would like to see some form 
of highlighting with their NFTABLES configuration/script file, I have 
this Vim script for you.

It's in beta.  But it is very comprehensive.

A small preview of what it looks like is this animated GIF link:
https://raw.githubusercontent.com/egberts/vim-nftables/master/test/nftables.gif

Everything is at Gihub: https://github.com/egberts/vim-nftables

Any questions or issue, please file an issue on same Github link as above.

Thank you and enjoy.

S. Egbert
