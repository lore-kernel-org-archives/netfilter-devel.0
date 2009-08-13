From: Daniel Huhardeaux <daniel.huhardeaux@tootai.com>
Subject: IP traffic rerouting
Date: Fri, 14 Aug 2009 00:44:03 +0200
Message-ID: <4A849733.4020404@tootai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.tootai.net ([82.231.69.24]:37806 "EHLO mail1.tootai.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbZHMXOe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:14:34 -0400
Received: from [192.168.0.4] (unknown [192.168.0.4])
	by mail1.tootai.net (Postfix) with ESMTP id 3F2A8398043
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2009 00:44:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

is there a solution to reroute all traffic (icmp, udp, tcp, ...) from
one IP address to another one?

I know xinetd can do this but that's only for tcp and for a specific
port. I'm looking for a global solution -if any-

Regards

-- 
Daniel Huhardeaux       _____ ____ ____ _____ _____ _
enum   +33 368 460 088 (_  __) _  ) _  (_  __) _  _(_)  +48 222 472 472
iaxtel  1-700-849-6983  / / / // / // / / / / /_/ / /  GIZMO,SKYPE,GTALK
sip/iax:callto 101@sip./_/ ( ___( ___/ /_/ (_/ (_/_/.net   tootaiNET


