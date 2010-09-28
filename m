From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: could ipporthash be extended/modified
Date: Tue, 28 Sep 2010 22:33:28 +0100
Message-ID: <4CA25F28.8050202@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51593 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0I1Vda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:33:30 -0400
Received: by wyb28 with SMTP id 28so122509wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Sep 2010 14:33:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the above type can only accept /16 (B-class) type addresses. 
Is there any reason for this limitation? Could this be extended to 
accept any IP address?

The reason I am asking this is because I have to revert to employing 
unsavoury gimmicks to get a pair of IP,port addresses as part of my 
ipset matching and it would be much easier if this was available through 
ipporthash (or similar) construct.

Is that a possibility?
