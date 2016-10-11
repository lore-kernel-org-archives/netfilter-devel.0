From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: routing table lookup
Date: Tue, 11 Oct 2016 20:11:43 +0200
Message-ID: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f181.google.com ([209.85.213.181]:34187 "EHLO
        mail-yb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbcJKSLo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 14:11:44 -0400
Received: by mail-yb0-f181.google.com with SMTP id e2so11338387ybi.1
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Oct 2016 11:11:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, netfilter-devel.

Is it possible/planned to be able to do routing table lookup from
within nftables?
Thinking then of a routingtable like "set". This would be nice to be able to do
early drop on bgp populated saddr based rtbl.

-- 
Bj(/)rnar
