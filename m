From: =?ISO-8859-1?Q?Bj=F8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Strange behaviour when listing in interactive mode
Date: Fri, 29 Nov 2013 18:00:58 +0100
Message-ID: <CAJO99TmsBrdOwMCMCwfZHmKTB-2NSF9R09sWmCwKDPEXL2u0qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:56022 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab3K2RBA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:01:00 -0500
Received: by mail-lb0-f177.google.com with SMTP id w7so7090417lbi.36
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2013 09:00:58 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I add a map, say:

add map filter ipv4_map { type ipv4_address => verdict; }
add element filter ipv4_map { 10.0.0.1 => accept }

..

every time I "list table filter", a extra ipv4_map element map appears:

the 3rd time I list, I see this:

    map ipv4_map {
        type ipv4_address => verdict
        elements = { 10.0.0.1 => accept}
    }
    map ipv4_map {
        type ipv4_address => verdict
        elements = { 10.0.0.1 => accept}
    }
    map ipv4_map {
        type ipv4_address => verdict
        elements = { 10.0.0.1 => accept}
    }

-- 
Bj(/)rnar
