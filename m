From: Eric Leblond <eric@regit.org>
Subject: [ulogd RFC PATCH 0/2] New JSON output plugin
Date: Tue, 28 Jan 2014 23:41:25 +0100
Message-ID: <1390948887-2112-1-git-send-email-eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56241 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1Wlo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:41:44 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=ice-age2.regit.org)
	by ks28632.kimsufi.com with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA256:128)
	(Exim 4.80)
	(envelope-from <eric@regit.org>)
	id 1W8HLf-0006eI-Gl
	for netfilter-devel@vger.kernel.org; Tue, 28 Jan 2014 23:41:42 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Hello,

Here's a patchset introducing a new output plugin for ulogd. Called
JSON, this output plugin write events in JSON format to a file. This
format has the advantage of being easily parsed by logging system
such as logstash (or the proprietary splunk).

To ease interaction with other source events such as syslog, it is
important to use the normalised field names. Common Information
Model is used by splunk and seem to be used in most logstash config
snippet. So I've decided to upgrade ulogd key to be able to store 
the CIM key name in them.

Patchset statistics:
 configure.ac                              |  12 ++
 filter/raw2packet/ulogd_raw2packet_BASE.c |  10 +-
 filter/ulogd_filter_IP2STR.c              |   4 +
 include/ulogd/ulogd.h                     |   3 +
 output/Makefile.am                        |  10 ++
 output/ulogd_output_JSON.c                | 254 ++++++++++++++++++++++++++++++
 ulogd.conf.in                             |  15 ++
 7 files changed, 306 insertions(+), 2 deletions(-)

BR,
--
Eric
