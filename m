From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Patchsets overview
Date: Sat, 15 Dec 2007 17:20:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712151620320.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34752 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXLOQUK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:20:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to all,


(iptables svn7138) iptables-modules "branch" (it is all quilt stacks):
ipt-01-line-based-makefile.diff
ipt-02-nf_inet_addr.diff
ipt-03-libxt_owner-match.diff
ipt-04-strtou_bound.diff
ipt-05-libxt_tos-match.diff
ipt-06-libxt_TOS-target.diff
ipt-07-libxt_MARK-target-v2.diff
ipt-08-libxt_TEE-target.diff
ipt-09-libxt_TCPOPTSTRIP-target.diff
ipt-10-libxt_TARPIT-target.diff
ipt-11-libxt_STEAL-target.diff
ipt-12-Chaostables.diff

(iptables svn7097) iptables-automake branch:
ipt-autotools.diff

(kernel davem-net-2.6.25) netfilter branch:
nf-01-family-specifiers.diff
nf-02-nf_inet_addr.diff
nf-03-xt_connlimit-nf_inet_addr.diff
nf-04-xt_mark-match-v1.diff
nf-05-xt_TOS-semantic-change.diff
nf-06-xt_MARK-target-v2.diff
nf-07-xt_connmark-match-v1.diff
nf-08-xt_CONNMARK-target-v1.diff
nf-09-macro-parentheses.diff
nf-10-xt_TEE-target.diff
nf-11-xt_TARPIT-target.diff
nf-12-xt_STEAL-target.diff

Some of the patches I already posted within the last 6 hours as mail, 
some are merged in your tree but not davem's, so... let's sort it out 
sooner or later - after the replies to the mails have come in 
probably :-)

Two tarballs at
http://dev.computergmbh.de/f/iptables-modules.tar.bz2
http://dev.computergmbh.de/f/netfilter.tar.bz2
on the automake front, no conclusion has yet been drawn (all delays most 
likely due to 1.4.0 going out the door, that's fine)


regards,
Jan
