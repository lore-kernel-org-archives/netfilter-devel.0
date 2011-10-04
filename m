From: Julien Lafaye <jlafaye@gmail.com>
Subject: Packet statistics accounting module: request for comments
Date: Tue, 4 Oct 2011 06:50:24 +0200
Message-ID: <CAFAca_CyLYGH+FyzyONsM7CiA6K3=BNdwY6PvTd+d1HEFKX6XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: jlafaye <jlafaye@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42269 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1JDEuZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Oct 2011 00:50:25 -0400
Received: by vcbfk10 with SMTP id fk10so66860vcb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Oct 2011 21:50:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I created a small packet statistics accounting module based on the
xtables framework. It is based on a FIFO that is filled in netfilter
hooks and emptied by a user program reading statistics through /proc
callbacks. The goal of the module is to be able to get maximum traffic
rate with an improved resolution compared to basic techniques. Typical
expected resolution is 100ms.

The code is currently stored in github: https://github.com/jlafaye/xt_pktstat

I would like the code to be considered for inclusion in the
xtables-addons framework. Nevertheless, the code might not be mature
enough as this is the first time I do kernel programming. Although
advised by knowledgeable persons, there are probably many issues in
it.

I would greatly appreciate is somebody on this list is able to give me
pointers and people to contact to actually improve my code and get it
ready for xtables-addons inclusion.

Regards,

Julien

PS: the guide 'How to write Netfilter modules' was great.
