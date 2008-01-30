From: heitzenberger@astaro.com
Subject: [ULOGD RFC 00/30] [ULOGD RFC] ulogd V2 improvements, round #1
Date: Wed, 30 Jan 2008 19:58:47 +0100
Message-ID: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-67.dex002.intermedia.net ([64.78.20.25]:39625 "EHLO
	DHOST002-67.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbYA3TBk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this is a patchset for you to comment on, which tries to turn ulogd V2
into something usefull.

Some of the patches are are quite intrusive, others might be to be
discussed.  Please take a look at all of them and give some comments
back, I'll appreciate it.

In the end they turn ulogd v2 into some powerfull network accounting
solution being capable to handle 400000 or more concurrent flows.
That's where your post-processing starts to get important of course
:).

Some points which might be of interest to you:

 * ulogd-ifi.diff: replacement for the IFINDEX plugin, as that
 functionality IMO is better homed in the ulogd core and not in a
 plugin (remove IFINDEX?).

 * some of the patches are quite large and contain many individual 
 changes in the end.  Should I split them?

 * ulogd-NFCT-new-lib.diff: makes ulogd work with a recent
 libnetfilter-conntrack.  This one is fairly untested, I'll test that
 before sending the final patchset.  Note also that I'd like to use
 libnl with ulogd rather soon, so this is only a short-term solution.

 * the libnetfilter-conntrack patch I've send before is required
 to build ulogd.

Some of those patches still contain trailing whitespace.  Please
ignore that as of now, I'll send additional patches removing
whitespace later.

Thanks in advance for your feedback.

 /holger

