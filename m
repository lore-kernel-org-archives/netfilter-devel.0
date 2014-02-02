From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd RFC PATCH 0/2] New JSON output plugin
Date: Sun, 02 Feb 2014 11:57:23 +0100
Message-ID: <1391338643.12417.1.camel@ice-age2.regit.org>
References: <1390948887-2112-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39685 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaBBK5c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Feb 2014 05:57:32 -0500
Received: from [2a01:e35:1394:5bd0:da50:e6ff:fe3c:3250]
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <eric@regit.org>)
	id 1W9ujx-0004LI-EN
	for netfilter-devel@vger.kernel.org; Sun, 02 Feb 2014 11:57:31 +0100
In-Reply-To: <1390948887-2112-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Tue, 2014-01-28 at 23:41 +0100, Eric Leblond wrote:
> 
> Hello,
> 
> Here's a patchset introducing a new output plugin for ulogd. Called
> JSON, this output plugin write events in JSON format to a file. This
> format has the advantage of being easily parsed by logging system
> such as logstash (or the proprietary splunk).

I've just pushed these patches to git.

BR,
-- 
Eric Leblond <eric@regit.org>

