From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: feature request: snat to @random_ip_from_this_set and negative set lookups
Date: Tue, 2 Dec 2014 21:46:53 +0100
Message-ID: <CAJO99Tmjm7UPE6V4ieiqEckh8DPKVLXB1c0Xg1WcWYZww8TMvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:51644 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaLBUqy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:46:54 -0500
Received: by mail-la0-f42.google.com with SMTP id s18so11544335lam.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Dec 2014 12:46:53 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

I am wondering if someone would be willing to implement the following features:

snat to @random

also, negative set lookups is something I am looking forward to:

ip saddr !@ignore_these ip saddr @drop_these drop

-- 
Bj(/)rnar
