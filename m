From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Wed, 24 Mar 2010 16:02:01 +0100
Message-ID: <4BAA2969.8010106@trash.net>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de> <1269377101-13875-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44356 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab0CXPCE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:02:04 -0400
In-Reply-To: <1269377101-13875-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> xt_conntrack has been provided since v2.5.32.
>   

I'm fine with the removal of old revisions, but how are you planning on
informing users about removal of this module? Most people don't read
feature-removal-schedule, and distributions are unable to help with
user written scripts.
