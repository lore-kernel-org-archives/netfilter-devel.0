From: =?iso-8859-1?Q?Giuseppe_Macr=EC?= <gmacri2@uic.edu>
Subject: Assignment port procedure
Date: Wed, 10 Mar 2010 17:06:18 -0600
Message-ID: <700FD7E4-E34D-4020-8748-F2DDCAA661A0@uic.edu>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-1.cc.uic.edu ([128.248.155.182]:57404 "EHLO
	mail-1.cc.uic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab0CJXQG convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:16:06 -0500
Received: from [192.168.1.140] (erf2054merrifield.cs.uic.edu [131.193.37.153])
	(authenticated bits=0)
	by mail-1.cc.uic.edu (8.14.0/8.14.0) with ESMTP id o2AN6Lnb020689
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Mar 2010 17:06:21 -0600
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Very new in netfilter developing.
I would like change assignment port procedure into the nat part of netfilter. I'm looking at nf_nat_proto_common.c, exactly at get_unique_tuple function (linux/net/ipv4/netfilter).
Is it the correct way to proceed?
Last question: does iptables handle nat with the nf_nat.ko module or with something else?

Giuseppe
