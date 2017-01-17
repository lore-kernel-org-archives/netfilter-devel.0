From: Victor Julien <lists@inliniac.net>
Subject: tcp state in conntrack destroy events
Date: Tue, 17 Jan 2017 20:46:42 +0100
Message-ID: <fdd3eb50-75d3-32e1-d7a0-f333050aece5@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:54235 "EHLO
        mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdAQU3R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 15:29:17 -0500
Received: from [192.168.1.6] (a212-238-163-105.adsl.xs4all.nl [212.238.163.105])
        (Authenticated sender: victorlists)
        by mail.inliniac.net (Postfix) with ESMTPSA id DAECB7338
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2017 20:49:08 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I was hoping to get the last TCP state in a conntrack destroy event,
however it seems to be unavailable.

Through libnetfilter_conntrack the value retrieved at ATTR_TCP_STATE is
always 0.

Using the conntrack command I see the same behavior:

destroy doesn't have it (conntrack -E -e destroy -p tcp):

[DESTROY] tcp      6 src=218.65.30.38 dst=192.168.178.254 sport=61063
dport=22 packets=11 bytes=820 src=192.168.0.123 dst=218.65.30.38
sport=22 dport=61063 packets=8 bytes=424 [ASSURED] mark=3 delta-time=77

update does (conntrack -E -e updates -p tcp):

 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.0.53 dst=x.x.x.x
sport=52958 dport=443 src=x.x.x.x dst=192.168.178.254 sport=443
dport=52958 [ASSURED] mark=3

Is this intentional? My goal is to create connection log that includes a
hint about why the connection is gone.

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

