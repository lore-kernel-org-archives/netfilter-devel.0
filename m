From: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Subject: FSM for TCP proto
Date: Sun, 11 Nov 2012 16:58:04 +0100
Message-ID: <CACd4Q021-ukEstznTnm-3Jst9_E94R7Q89ohFrs05S2uj5W+Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57494 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2KKP60 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:58:26 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3651009wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Nov 2012 07:58:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've been trying to understand netfilter's connection tracking for TCP.

The FSM used is a simplified version of the usual TCP FSM, and
therefore, as I understand it, it does not permit a perfect tracking
of TCP.

A first question is: why not rely on a better version of the FSM? It
would maybe imply that the states of both end-hosts should be stored
but it would also allow a finer-grained tracking of the connection.

I assume this is because the firewall doesn't need to be so specific
about the tracking, but why not? Wouldn't it be better from a security
viewpoint?

In the same line of thinking, I can see that, for example, at the
regular connection closing, no check is done on the direction of the
FIN segments. AFAIK, this would mean that a host could make think the
firewall that a connection is closed when it is actually sending 2
times a  FIN segment. A one-liner check would make sure that both FINs
come from different hosts, why omit this?
The real question is: am I missing something important that would make
this kind of things insignificant?

In advance, thank you.

--
nimai
