From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2.6.24][BUG] Compact code broken?
Date: Thu, 15 Nov 2007 14:48:12 +0100
Message-ID: <473C4E1C.2040301@trash.net>
References: <20071114212855.GA580@dreamland.darkstar.lan>	<20071114.150029.144310383.davem@davemloft.net>	<68676e00711141539k18fa900bj9016ee5dd72a71c4@mail.gmail.com> <20071114.154247.130153717.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050305000700050108090505"
Cc: kronos.it@gmail.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45237 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbXKONsQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:48:16 -0500
In-Reply-To: <20071114.154247.130153717.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050305000700050108090505
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: "Luca Tettamanti" <kronos.it@gmail.com>
> Date: Thu, 15 Nov 2007 00:39:11 +0100
> 
>> On Nov 15, 2007 12:00 AM, David Miller <davem@davemloft.net> wrote:
>>> From: Luca Tettamanti <kronos.it@gmail.com>
>>> Date: Wed, 14 Nov 2007 22:28:55 +0100
>>>
>>>> Hello,
>>>> I'm testing a 64bit kernel on my machine and I've found an issue with
>>>> iptables (32 bit). Kernel is git current (9418d5dc).
>>> What platform?  x86?  powerpc?  sparc64?
>> x86
> 
> Ok, the userland pointer you provided seemed to be sign extended
> to 64-bit, so there might be a pointer arithmetic bug in the
> netfilter compat code somewhere.


It took me a few passes over the code, but it turns out to be
a simple typo :)

Luca, does this fix it for you?


--------------050305000700050108090505
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: fix compat_nf_sockopt typo

It should pass opt to the ->get/->set functions, not ops.

Fixes compat fault reported by Luca Tettamanti <kronos.it@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ac55193be35872211189096ec600f94614a0179b
tree a6633e33307b5ec1e11fedc2d0e125ed6e2bd081
parent 99fee6d7e5748d96884667a4628118f7fc130ea0
author Patrick McHardy <kaber@trash.net> Thu, 15 Nov 2007 14:46:43 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 15 Nov 2007 14:46:43 +0100

 net/netfilter/nf_sockopt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 87bc144..3dd4b3c 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -143,12 +143,12 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 		if (ops->compat_get)
 			ret = ops->compat_get(sk, val, opt, len);
 		else
-			ret = ops->get(sk, val, ops, len);
+			ret = ops->get(sk, val, opt, len);
 	} else {
 		if (ops->compat_set)
-			ret = ops->compat_set(sk, val, ops, *len);
+			ret = ops->compat_set(sk, val, opt, *len);
 		else
-			ret = ops->set(sk, val, ops, *len);
+			ret = ops->set(sk, val, opt, *len);
 	}
 
 	module_put(ops->owner);

--------------050305000700050108090505--
