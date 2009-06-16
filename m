From: Philip Craig <philipc@snapgear.com>
Subject: TPROXY target returns NF_ACCEPT
Date: Tue, 16 Jun 2009 19:09:42 +1000
Message-ID: <4A376156.60106@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: KOVACS Krisztian <hidden@sch.bme.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:46193 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751438AbZFPJJl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:09:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The TPROXY target returns NF_ACCEPT rather than XT_CONTINUE.
Is there a reason for this, or is it left over from when
there was a tproxy table?  I can place the tproxy rules last
if needed, but this behaviour was unexpected.

Also, does tproxy handle related ICMP packets too?
