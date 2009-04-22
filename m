From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: nf_conntrack_proto_udplite
Date: Wed, 22 Apr 2009 21:06:29 +0100
Message-ID: <200904222106.29497.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:36242 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbZDVUGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:06:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id EF2DC20B26
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2009 21:06:29 +0100 (BST)
Received: from mail.springl.ukfsn.org ([127.0.0.1])
	by localhost (l2.home [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 223qZc2V0ygc for <netfilter-devel@vger.kernel.org>;
	Wed, 22 Apr 2009 21:06:29 +0100 (BST)
Received: from l3.home (l3.home [IPv6:2002:542d:c701:1:250:daff:fe6d:bbdd])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 4F10920B1B
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2009 21:06:29 +0100 (BST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

Whilst testing kernel 2.6.30-rc3 I have noticed that when I issue command: 

modprobe nf_conntrack_proto_udplite

the following message is produced:

FATAL: Error inserting nf_conntrack_proto_udplite 
(/lib/modules/2.6.30-rc3/kernel/net/netfilter/nf_conntrack_proto_udplite.ko): 
Invalid argument

Is this a kernel bug or have I done something wrong?

Steven.
