From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: nomatch in bitmap:* sets
Date: Sun, 08 Apr 2012 15:59:49 +0100
Message-ID: <4F81A7E5.3040400@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51375 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2DHO7z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Apr 2012 10:59:55 -0400
Received: by wejx9 with SMTP id x9so2235483wej.19
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Apr 2012 07:59:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently only hash:* sets have the "nomatch" feature. Could this be 
extended to bitmap:* sets as well?
