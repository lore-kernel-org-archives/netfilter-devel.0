From: Eric Leblond <eric@inl.fr>
Subject: [RFC] make thread-safe iface resolution in libnfnetlink
Date: Tue, 28 Apr 2009 23:45:26 +0200
Message-ID: <1240955127-13723-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38066 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753069AbZD1Vpb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:45:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've encountered some problems with libnfnetlink iface resolution on a
system where some interfaces are getting up and down: NuFW which uses
this feature has crashed during a down/up of an interfaces. One of
the reason seems that nufw uses one thread is used for iface related
event treatment and another thread is doing iface name resolution.

As the hash can be modified or read without any lock, I think the
problem can be linked with this issue. I thus propose a patch that
modifies the iface resolution subsystem to make it thread-safe.

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
