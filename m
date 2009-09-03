From: Pierre Chifflier <chifflier@inl.fr>
Subject: (unknown)
Date: Thu,  3 Sep 2009 23:23:23 +0200
Message-ID: <1252013004-9029-1-git-send-email-chifflier@inl.fr>
References: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
Cc: eleblond@inl.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46835 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378AbZICV1F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:27:05 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 95636940119
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2009 23:27:01 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 8574C940164
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2009 23:26:58 +0200 (CEST)
Subject: 
In-Reply-To: <alpine.LSU.2.00.0908240031330.30556@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here is an updated version of the UNIXSOCK plugin (part 2 only, other
parts are unchanged).
I think all remarks from Jan have been integrated:
- use sizeof(server_sock.sun_path) and do not use UNIX_PATH_MAX
- remove useless casts from void*
- use ARRAY_SIZE
- if no buffer size was provided, try to determine it using
  getsockopt(SO_RECVBUF) at runtime
- use one line for init function attributes, and make it static

Cheers,
Pierre


