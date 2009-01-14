From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables use of NFPROTO_UNSPEC as wildcard incomplete :-(
Date: Wed, 14 Jan 2009 03:22:30 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901140256180.22699@fbirervta.pbzchgretzou.qr>
References: <87k58yzy2v.fsf@cayenne.mti.ag>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Christian von Roques <roques@mti.ag>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44015 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760207AbZANCWd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:22:33 -0500
In-Reply-To: <87k58yzy2v.fsf@cayenne.mti.ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2009-01-13 22:38, Christian von Roques wrote:
>
>I have a problem with your changeset below:
>
>commit ab4f21e6fb1c09b13c4c3cb8357babe8223471bd
>Author: Jan Engelhardt <jengelh@medozas.de>
>Date:   Wed Oct 8 11:35:20 2008 +0200
>
>    netfilter: xtables: use NFPROTO_UNSPEC in more extensions
>    
>    Lots of extensions are completely family-independent, so squash some code.
>    
>    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>    Signed-off-by: Patrick McHardy <kaber@trash.net>
>
>
>I have a production server where I had to replace a failed on-board
>Ethernet port with a 3c905 requiring a very new kernel (due to a
>regression in the 3c905 driver, which was just recently fixed).  This
>server requires netfilter/xt_MARK.c for IPv4.  Unfortunately your
>changes to make NFPROTO_UNSPEC act like a protocol wildcard seem
>incomplete.  -j MARK does not work anymore.  Replacing NFPROTO_UNSPEC
>with NFPROTO_IPV4 in xt_MARK.c fixed my problem, but obviously
>disabled the MARK target for all other protocols (which I fortunately
>don't need).
>
>Is this a know problem?
>Are you able to reproduce the problem?
>The simplest command which used to fail was:
>iptables -t mangle -A OUTPUT -j MARK --set-mark 0x14 


This is probably the same as
http://marc.info/?l=netfilter&m=123174116204956&w=2 and only
manifests itself under the condition that kernel < 2.6.28 && iptables
<= 1.4.0. Most people should-have (read it as a recommendation)
upgraded their iptables long ago, really, since some distros just
keep on shipping old stuff like almost forever.
