From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/16] [NETFILTER]: Re-add missing checkentry calls
Date: Sun, 05 Oct 2008 14:50:57 +0200
Message-ID: <48E8B831.7020609@trash.net>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44040 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYJEMvC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:51:02 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> A previous commit ("Move Ebtables to use Xtables") unfortunately
> removed match and target checks in Ebtables. Add it back. Some checks
> go into xtables.c as part of consolidation work.

Should I fold this one into the patch that removed them?
