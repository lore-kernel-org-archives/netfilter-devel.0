From: Dominik Kaspar <dokaspar.ietf@gmail.com>
Subject: Question about the "dst" field in sk_buff
Date: Wed, 3 Feb 2010 19:15:36 +0100
Message-ID: <2a3692de1002031015l7ff6e1a1w61caa03d46afb55b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:63587 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0BCSPi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:15:38 -0500
Received: by gv-out-0910.google.com with SMTP id l14so136311gvf.37
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Feb 2010 10:15:37 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to compile various xt_*.c files that try to access
skb->dst. However, the sk_buff structure has no "dst" field in the
kernel version I am using (2.6.31), only a "_skb_dst" field. So when I
run "make", for example to compile the xt_ECHO.c example from the
netfilter tutorial, I always encounter errors like this:

error: =91struct sk_buff=92 has no member named =91dst=92

What do I have to do to solve this? I guess it has something to do
with those "compat" files, but I don't how they are used... Any hint
would be highly appreciated.

Best regards,
Dominik
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
