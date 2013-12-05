From: Eric Leblond <eric@regit.org>
Subject: [PATCHv3 0/3] add nft_queue module
Date: Thu,  5 Dec 2013 22:31:25 +0100
Message-ID: <1386279088-4895-1-git-send-email-eric@regit.org>
References: <20131205170955.GA8663@localhost>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:58638 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LEVbp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:31:45 -0500
In-Reply-To: <20131205170955.GA8663@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patch is a rework of previous patchset which fix comments
sent by Pablo. Code commons to xf_NFQUEUE and nft_queue has been
put in a common header. Other minor points have been fixed to.

BR,
--
Eric
