From: Philip Craig <philipc@snapgear.com>
Subject: conntrack untracked match is broken
Date: Mon, 22 Jun 2009 16:31:35 +1000
Message-ID: <4A3F2547.30301@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:59769 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973AbZFVGbe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:31:34 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by bne.snapgear.com (Postfix) with ESMTP id 4D812EBBB7
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2009 16:31:36 +1000 (EST)
Received: from bne.snapgear.com ([127.0.0.1])
	by localhost (bne.snapgear.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uNbidU0q-4FG for <netfilter-devel@vger.kernel.org>;
	Mon, 22 Jun 2009 16:31:35 +1000 (EST)
Received: from [192.168.0.3] (philipc2.sw.moreton.com.au [10.46.1.58])
	by bne.snapgear.com (Postfix) with ESMTP
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2009 16:31:35 +1000 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

# iptables -I INPUT -m conntrack --ctstate UNTRACKED
# iptables -L INPUT
Chain INPUT (policy DROP)
target     prot opt source               destination
           all  --  anywhere             anywhere            ctstate
(ctstate isn't matching anything.)

The problem is that state_mask in 'struct xt_conntrack_mtinfo1' is
only 8 bit, but XT_CONNTRACK_STATE_UNTRACKED == 256.
Unfortunately, gcc doesn't warn about this for '|=', only for '='.

A workaround is to use -m state --state UNTRACKED

Looks like we need a conntrack match v2 to fix this?

