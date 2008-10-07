From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/23] netfilter: xtables: do centralized checkentry call
 (2/2)
Date: Tue, 07 Oct 2008 15:06:26 +0200
Message-ID: <48EB5ED2.5000109@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <4d1c693c1eeb16b8e66dfbfa1c43fe178ac4884b.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYJGNGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:06:33 -0400
In-Reply-To: <4d1c693c1eeb16b8e66dfbfa1c43fe178ac4884b.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> With the previous patch moving checks into xtables.c, the checks in
> *_tables can be cleaned out. Also propagate the error code from
> xt_{match,target}_check in the error case instead of always using
> -EINVAL.

It seems to me this part also belongs in patch 1/2 since we're
doing these checks twice for one revision?
