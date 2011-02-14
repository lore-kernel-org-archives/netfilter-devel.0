From: Avi Kivity <avi@redhat.com>
Subject: Possible netfilter-related memory corruption in 2.6.37
Date: Mon, 14 Feb 2011 16:58:27 +0200
Message-ID: <4D594313.4050009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	nicolas prochazka <prochazka.nicolas@gmail.com>,
	KVM list <kvm@vger.kernel.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab1BNO6c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:58:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We see severe memory corruption in kvm while used in conjunction with 
bridge/netfilter.  Enabling slab debugging points the finger at a 
netfilter chain invoked from the bridge code.

Can someone take a look?

https://bugzilla.kernel.org/show_bug.cgi?id=27052

-- 
error compiling committee.c: too many arguments to function

