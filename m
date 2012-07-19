From: Eric Leblond <eric@regit.org>
Subject: [PATCH 0/1] Fix NFCT crash
Date: Thu, 19 Jul 2012 08:56:03 +0200
Message-ID: <1342680964-1250-1-git-send-email-eric@regit.org>
References: <CAAJpzgYGxVgazp74qck_Diacp7SJCjMOZFhw7cX0_k6B-4Qw9Q@mail.gmail.com>
Cc: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39810 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2GSG5B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 02:57:01 -0400
In-Reply-To: <CAAJpzgYGxVgazp74qck_Diacp7SJCjMOZFhw7cX0_k6B-4Qw9Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Great diagnostic! it was in fact polling mode and the same NFCT
instance on two stacks.

Can you try the following patch. It fixes the problem for on my
test setup.

BR,
--
Eric
