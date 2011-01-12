From: Sam Roberts <vieuxtech@gmail.com>
Subject: can libnetfilter_conntrack be used to write a userspace connection tracker?
Date: Wed, 12 Jan 2011 13:25:11 -0800
Message-ID: <AANLkTimfmoEKVWA_kBM-1DiuTR0=OG0Y8kC5nvq0G7G-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45837 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1ALVZO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:25:14 -0500
Received: by bwz15 with SMTP id 15so943290bwz.19
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jan 2011 13:25:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm working on a connection tracker for a RPC-like protocol (over TCP).

I believe that by inspecting packets using nfqueue, and
creating/destroying expectations using nfconntrack, I can do a
connection tracker in user-space.

In order to remove nfqueue from the mix, I've been looking at the
conntrack code, trying to figure out whether even notifications about
connection status can include the TCP data that I need to inspect, the
data that's in the skbs provided to kernel module conntrack helpers. I
haven't been able to be certain what libnfconntrack can/cannot do, but
it seems outside of the usage that the command line tools and
conntrack daemon need, so I suspect its not possible.

Can somebody confirm my suspicions?

Thank you.
Sam
