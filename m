From: Eric Leblond <eric@regit.org>
Subject: [RFC PATCH] Disabling helper assignement by default
Date: Tue, 27 Mar 2012 00:05:01 +0200
Message-ID: <1332799502-11623-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45398 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2CZWqJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:46:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Here's a patch which provides a way to disable helper assignement by
default To preserve backward compatibility, this feature is disabled
by default.

Once the feature is activated, the user has to manually define
the helper assignement by using the CT target.
This patch is aiming at improving the situation described in the
'Secure use of iptables and connection tracking helpers' document:
	https://home.regit.org/netfilter-en/secure-use-of-helpers/
where a ports=0 loading option was given to emulate this behaviour.

BR,
--
Eric Leblond <eric@regit.org>
