From: Florian Westphal <fw@strlen.de>
Subject: Re: [Documentation] SNAT in INPUT chain
Date: Tue, 26 Apr 2016 18:14:17 +0200
Message-ID: <20160426161417.GA3100@strlen.de>
References: <670551461680277@web23j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Lion Yang <lion@aosc.io>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35518 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbcDZQN4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 12:13:56 -0400
Content-Disposition: inline
In-Reply-To: <670551461680277@web23j.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lion Yang <lion@aosc.io> wrote:
> netfilter after about (linux kernel) 2.4.x (or 2.6.x?) [1] can put SNAT into hook NF_IP_LOCAL_IN.
> However, official docs(including 'man') doesn't change, so far.
> 
> It's hard to me to write something correctly and precisely in English.
> Would someone improve the docs please?

Is this enough?

--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -103,8 +103,9 @@ the built-in chains \fBINPUT\fP (for packets destined to local sockets),
 .TP
 \fBnat\fP:
 This table is consulted when a packet that creates a new
-connection is encountered.  It consists of three built-ins: \fBPREROUTING\fP
-(for altering packets as soon as they come in), \fBOUTPUT\fP
+connection is encountered.  It consists of four built-ins: \fBPREROUTING\fP
+(for altering packets as soon as they come in), \fBINPUT\fP (for altering
+packets destined for local sockets), \fBOUTPUT\fP
 (for altering locally-generated packets before routing), and \fBPOSTROUTING\fP
 (for altering packets as they are about to go out).
 IPv6 NAT support is available since kernel 3.7.

