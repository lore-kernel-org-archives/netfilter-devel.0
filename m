From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] nft-test: don't use colors if output is not a tty
Date: Wed, 25 Mar 2015 09:27:56 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1503250923030.28207@nerf40.vanv.qr>
References: <1427268710-2889-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: pablo@netfilter.org, anarey@gmail.com,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:48760 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbbCYI15 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 04:27:57 -0400
In-Reply-To: <1427268710-2889-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>+    if sys.stdout.isatty():
>+        HEADER = '\033[95m'
>+        GREEN = '\033[92m'
>+        YELLOW = '\033[93m'
>+        RED = '\033[91m'
>+        ENDC = '\033[0m'

Where did the values 91, 92, 93, 95 actually come from? They are 
nonstandard and, apparently, are a carry-over for AIX compatibility.
