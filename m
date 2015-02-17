From: AZ <ak47izatool@gmail.com>
Subject: conntrackd refuses to work on interface with '_' in it's name
Date: Tue, 17 Feb 2015 17:36:10 +0700
Message-ID: <CAE5AaEz=TwJKUgWp+uE4XgCjUVA3feqYeovURnNhpHwwYsPQzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:55952 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbbBQKgL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 05:36:11 -0500
Received: by mail-qg0-f47.google.com with SMTP id q107so27304217qgd.6
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2015 02:36:10 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is a syntax error if you'll try to use interface with the name
containing underscore.
The kernel works with such an interfaces, so there's no reason
conntrackd shouldn't.
I propose the following patch to fix this, works for me:
--- read_config_lex.l.orig      2015-02-17 16:35:08.160554333 +0600
+++ read_config_lex.l   2015-02-17 16:35:24.053887237 +0600
@@ -47,7 +47,7 @@ ip6_part      {hex_255}":"?
 ip6_form1      {ip6_part}{0,7}"::"{ip6_part}{0,7}
 ip6_form2      ({hex_255}":"){0,7}{hex_255}
 ip6            {ip6_form1}{ip6_cidr}?|{ip6_form2}{ip6_cidr}?
-string         [a-zA-Z][a-zA-Z0-9\.\-]*
+string         [a-zA-Z][a-zA-Z0-9_\.\-]*
 persistent     [P|p][E|e][R|r][S|s][I|i][S|s][T|t][E|e][N|n][T|T]
 nack           [N|n][A|a][C|c][K|k]
 alarm          [A|a][L|l][A|a][R|r][M|m]
