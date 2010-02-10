From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/6] netfilter: get rid of the grossness in netfilter.h
Date: Wed, 10 Feb 2010 18:44:00 +0100
Message-ID: <4B72F060.4050606@trash.net>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <1265823547-10358-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55827 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab0BJRoI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:44:08 -0500
In-Reply-To: <1265823547-10358-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> GCC is now smart enough to follow the inline trail correctly.
> vmlinux size remain the same.

Which one? The kernel currently supports 3.2+.
