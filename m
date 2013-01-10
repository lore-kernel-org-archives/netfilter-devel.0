From: Jan Engelhardt <jengelh@inai.de>
Subject: xtadm 1.5.0 released
Date: Thu, 10 Jan 2013 16:54:06 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301101621150.23731@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter user mailing list <netfilter@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58182 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab3AJPyI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:54:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,


this is the initial beta release of xtadm, the command-line interface 
for the Xtables2 packet filter. This builds upon the existing iptables 
tree and reuses extension plugins. Command-line syntax is similar to 
iptables, but do see xtadm-migration(8) and xtadm(8). It does allow to 
rudimentarily match on packets already - using xt_u32 or xt_bpf - and 
call targets such as MARK.
The convenient well-known command-line interface is also made available 
as C library called libxtadm, though there is yet work to be done to be 
able to capture the output again.

xtadm and libnetfilter_xtables can be downloaded from
	http://inai.de/nfxt/
