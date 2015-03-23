From: Laurent Bercot <ska-devel@skarnet.org>
Subject: Re: [PATCH libnftnl] src: restore static array with expression operations
Date: Mon, 23 Mar 2015 14:21:30 +0100
Message-ID: <5510135A.9020809@skarnet.org>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org> <20150323114411.GH603@acer.localdomain> <20150323123400.GA6511@salvia> <20150323130805.GN603@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:36943 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbCWN3I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 09:29:08 -0400
In-Reply-To: <20150323130805.GN603@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23/03/2015 14:08, Patrick McHardy wrote:
> Yeah, me too. Do you have a pointer to the bug report? I'm surprised
> that they are not invoked, from what I can tell that should happen in
> any case.

  Hi Patrick,
  I reported the bug on the netfilter@vger.kernel.org mailing-list
(not the -devel one.)

  I just tested Pablo's proposed patch. It's working perfectly.
  Thanks a lot, Pablo.

-- 
  Laurent

