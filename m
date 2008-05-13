From: Patrick McHardy <kaber@trash.net>
Subject: netfilter moving to git
Date: Tue, 13 May 2008 15:24:16 +0200
Message-ID: <48299680.7020808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43170 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbYEMNYz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 09:24:55 -0400
Received: from [192.168.0.100] (unknown [78.42.204.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTP id ECE85948D0
	for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2008 15:24:52 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've finally managed to complete the git setup on netfilter.org
and created an iptables repository for testing.

gitweb is running at git.netfilter.org (http and https), the
git-daemon URL for the repositories is shown in gitweb.

The repository might change in case we manage to import the missin
branches and fix up the tags (they dates appear to be messed up for
some reason), but please feel free to test already and let me know
of any problems.

I'll send another announcement when we've completed the switch to
git so people know when to stop using SVN.
