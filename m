From: Olaf <mailinglists@ban-solms.de>
Subject: iptables 1.4.11, cannot invert tcp flags
Date: Tue, 07 Jun 2011 07:24:39 +0200
Message-ID: <4DEDB617.7090805@ban-solms.de>
References: <4DDE857E.40807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hss-server.de ([212.72.183.75]:54665 "EHLO hss-server.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1FGFc4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:32:56 -0400
Received: from hss-server.de (localhost.localdomain [127.0.0.1])
	by hss-server.de (Postfix) with ESMTP id DC13091C026
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2011 07:24:38 +0200 (CEST)
Received: from [184.193.0.0] (p4FF7CC89.dip.t-dialin.net [79.247.204.137])
	by hss-server.de (Postfix) with ESMTPSA
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2011 07:24:38 +0200 (CEST)
In-Reply-To: <4DDE857E.40807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,


with 1.4.11 I can no longer invert --syn nor it's equivalent --tcp-flags 
SYN,RST,ACK,FIN SYN.
Both show up 'normal' (tcp flags:0x17/0x02) instead of 'inverted' (tcp 
flags:!0x17/0x02) when listing rules.
Works fine when using 1.4.10 or older versions.

Is inverting of tcp flags no longer supported? iptables -p tcp -h still 
shows [!] as possible option.


Thanks Olaf
