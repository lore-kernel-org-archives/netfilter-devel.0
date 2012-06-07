From: Kelvie Wong <kelvie@ieee.org>
Subject: Having expectations live past the master connection's lifetime
Date: Thu, 7 Jun 2012 10:34:13 -0700
Message-ID: <CAK2bC5qkHXMzSQg6v6DNb0ou7KWj+sTXibyLv=53zxe236M9pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41853 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2FGReP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:34:15 -0400
Received: by bkcji2 with SMTP id ji2so808277bkc.19
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Jun 2012 10:34:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,

I have noticed that expectations seem to get deleted as soon as their
master connection finishes their TIME_WAIT. Is there any way to have
expectations outlive their masters?

I need to have a dynamic port open (for DCERPC), and the initial
connection to the endpoint mapper is typically short-lived.

The way I was going to do this was to just add a rule with iptables
using a userspace helper; is there a better way to do this?
-- 
Kelvie Wong
