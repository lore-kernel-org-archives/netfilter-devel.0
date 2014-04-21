From: Bob Hockney <zeus@ix.netcom.com>
Subject: [ ulogd PATCH 0/2 ] two small fixes for ulogd
Date: Mon, 21 Apr 2014 14:10:56 -0600
Message-ID: <53557B50.6000503@ix.netcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:53410 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518AbaDUUWs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:22:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

I have two small fixes for ulogd.  The first adjusts the mysql data 
layout for oob_protocol (ether proto) to unsigned smallint from signed 
to accommodate all defined values.  The second is to the PGSQL output 
plugin, the patch adding the connstring parameter inadvertently required 
its use, ignoring other connection parameters and breaking prior 
configurations.

-Bob
