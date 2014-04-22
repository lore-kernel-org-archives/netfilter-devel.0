From: Eric Leblond <eric@regit.org>
Subject: Re: [ ulogd PATCH 0/2 ] two small fixes for ulogd
Date: Tue, 22 Apr 2014 10:02:11 +0200
Message-ID: <1398153731.4353.3.camel@ice-age2.regit.org>
References: <53557B50.6000503@ix.netcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Bob Hockney <zeus@ix.netcom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37494 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaDVICY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:02:24 -0400
In-Reply-To: <53557B50.6000503@ix.netcom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Mon, 2014-04-21 at 14:10 -0600, Bob Hockney wrote:
> Hi there,
> 
> I have two small fixes for ulogd.  The first adjusts the mysql data 
> layout for oob_protocol (ether proto) to unsigned smallint from signed 
> to accommodate all defined values.  The second is to the PGSQL output 
> plugin, the patch adding the connstring parameter inadvertently required 
> its use, ignoring other connection parameters and breaking prior 
> configurations.

Thanks a lot. That's two good catches. Sadly I can not apply your
patches with git am. Can you resubmit your patch using git
format-patch ?

Thanks in advance.

BR,
-- 
Eric Leblond <eric@regit.org>

