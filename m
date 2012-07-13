From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: pgsql-ulogd2
Date: Fri, 13 Jul 2012 15:13:03 +0100
Message-ID: <50002CEF.508@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52929 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2GMONK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:13:10 -0400
Received: by eaak11 with SMTP id k11so1087179eaa.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jul 2012 07:13:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I just came across the pgsql script for the ulogd2 daemon supplied with the latest sources and since I intend to deploy it (upgrading my system from syslog-ng) I thought to ask about a couple of ideas I have.

As I see it, the script does not have any security/permission policies created or implemented. Is such feature planned? 

If not, I think I have enough PostgreSQL experience and could alter that script to include such implementation, though I might need help with the NFLOG/ULOGD2 part as I am fairly new to this.

The idea I have is that the ulogd2 daemon should only be allowed INSERT permissions (nothing else) to the log tables, so that even if someone is able to hijack the ulogd2 connection to PostgreSQL somehow, they won't be able to see what has been logged, let alone alter it or delete it.

For certain views, I am sure there is a need for SELECT permission and for others there would even be a need for USAGE or REFERENCES privileges.

I tried to email the author of that script (Pierre - chifflier@inl.fr), but my emails are not getting through for some reason. Thanks!



