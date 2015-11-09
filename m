From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Fwd: nft synproxy integration
Date: Mon, 9 Nov 2015 18:25:54 +0100
Message-ID: <CAJO99TkObg-JWwLaEAyAD9Z1xPsKR6YXFqVx2wcqVtAmW92+1A@mail.gmail.com>
References: <20151109163015.GM8098@macbook.localdomain>
	<CAJO99T=4fjPkBTFEYuibGsHe=BfM0KRbhYkP_E_RPa49SUWeHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35555 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbKIRZz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 12:25:55 -0500
Received: by lfdo63 with SMTP id o63so11333097lfd.2
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2015 09:25:54 -0800 (PST)
In-Reply-To: <CAJO99T=4fjPkBTFEYuibGsHe=BfM0KRbhYkP_E_RPa49SUWeHg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2015-11-09 17:30 GMT+01:00 Patrick McHardy <kaber@trash.net>:
>

[ ... ]

> Any thoughts about this?

Could it be possible to automagically insert an "hiden notrack" for the same
packets the synproxy target matches when adding it?

Ofcorse depends on what this cost really is in terms of performance, but I dont
like the idea of sacrificing performance for a little easier use.
Atleast not for this
module, where the whole point of it beeing able to deal with big pps numbers

-- 
Bj(/)rnar
