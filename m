From: Victor Julien <lists@inliniac.net>
Subject: libnetfilter_queue question
Date: Wed, 19 May 2010 12:15:35 +0200
Message-ID: <4BF3BA47.7040109@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:38584 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab0ESKZg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 May 2010 06:25:36 -0400
Received: from [192.168.1.4] ([80.101.90.58])
	(authenticated bits=0)
	by tulpe.vuurmuur.org (8.13.8/8.13.8/Debian-3+etch1) with ESMTP id o4JAFZRH013382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2010 12:15:40 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I'm using libnetfilter_queue for inline mode in the Suricata IDS/IPS
(www.openinfosecfoundation.org). I'm using a callback that makes the
packet(s) available to the detection engine. In some special cases the
call back could fail (only malloc failure atm).

I was wondering what the proper response would be to such an event. I'm
assuming nfq_handle_packet() would return an (non zero) error code in
that case.

Should I verdict the packet? (drop to be safe)

Cheers,
Victor

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

