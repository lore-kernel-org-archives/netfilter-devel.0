From: tingwei liu <tingw.liu@gmail.com>
Subject: iptables domain match
Date: Tue, 3 May 2011 17:08:51 +0800
Message-ID: <BANLkTi=2XpuuqMZgwVggH6-RPH_XvywGyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40974 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1ECJJe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2011 05:09:34 -0400
Received: by pzk9 with SMTP id 9so3411622pzk.19
        for <netfilter-devel@vger.kernel.org>; Tue, 03 May 2011 02:09:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have written a netfilter match called domain.
Such as: iptables -A OUTPUT -m domain --domain ".google.com" -j DROP
                     Then it will drop the dns query which domain like
"www.google.com,news.google.com,mail.google.com,..."
              iptables -I OUTPUT -m domain --domain "map.google.com" -j ACCEPT
                     Then it will accept the dns query which domain is
"map.google.com".
I known this match is trival,but I want to know how to submit this patch.

Thanks for any response.
