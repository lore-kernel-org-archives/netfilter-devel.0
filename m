From: Nils Rennebarth <Nils.Rennebarth@web.de>
Subject: How to register conntrack notifier
Date: Tue, 27 Oct 2009 16:03:52 +0100
Message-ID: <894367326@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:38545 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZJ0PDt convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:03:49 -0400
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id A4D2561F8145
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2009 16:03:53 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The help text for NF_CONNTRACK_EVENTS reads:
  If this option is enabled, the connection tracking code will
  provide a notifier chain that can be used by other kernel code
  to get notified about changes in the connection tracking state.
which sounds just like what I need: I want to execute a callback
whenever a conntrack gets destroyed. However studying
nf_conntrack_netlink.c, nf_conntrack_ecache.c and related header files
for quite a while now, i am still unable to figure out how to do that.

Can someone enlighten me?


______________________________________________________
GRATIS f=FCr alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
