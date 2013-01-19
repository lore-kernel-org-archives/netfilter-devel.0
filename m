From: Eric Leblond <eric@regit.org>
Subject: [ulogd patch 0/3] improve ulogd command line
Date: Sat, 19 Jan 2013 10:50:32 +0100
Message-ID: <1358589035-1275-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37660 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3ASJvK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:51:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This little patchset adds some options to ulogd. First one is '-v'
which sends log message to standard out (combined to syslog). Second
one is '-l' which allows user to set log level from command line.

BR,
--
Eric
