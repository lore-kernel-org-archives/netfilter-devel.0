From: "Julio A. Romero" <julioarr@fisica.uh.cu>
Subject: about merging fuzzy and connlimit ??
Date: Sat, 13 Aug 2011 15:34:42 -0400
Message-ID: <E1CCC621DD6049CC8F04995F81472215@poweredge1800>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.uh.cu ([200.14.51.4]:57913 "EHLO smtp.uh.cu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab1HMTfK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:35:10 -0400
Received: from server.fisica.uh.cu (server.fisica.uh.cu [10.6.11.1])
	by smtp.uh.cu (Postfix) with ESMTPS id 9EC347D057
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2011 15:34:59 -0400 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by server.fisica.uh.cu (Postfix) with ESMTP id 8465A528DC
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2011 15:32:11 -0400 (CDT)
Received: from server.fisica.uh.cu ([127.0.0.1])
	by localhost (server.fisica.uh.cu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fiiyPI9XpH29 for <netfilter-devel@vger.kernel.org>;
	Sat, 13 Aug 2011 15:32:07 -0400 (CDT)
Received: from poweredge1800 (unknown [10.6.13.2])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: julioarr)
	by server.fisica.uh.cu (Postfix) with ESMTPSA id 65CC2528D9
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2011 15:32:06 -0400 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

That's correct?


# Create average

iptables -N average

# Restrict the number of parallel connections per client IP

iptables -A average -m connlimit --connlimit-above 20 -j REJECT

# Traffic rate control above the lower limit per client IP

iptables -A average -m connlimit ! --connlimit-above 20 \
-m fuzzy --lower-limit 100 --upper-limit 1000 -j REJECT

# Allow the traffic below the lower limit

iptables -A average -m connlimit ! --connlimit-above 20 -j ACCEPT


thanks,
julio
