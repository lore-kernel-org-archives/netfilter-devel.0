From: Ed W <lists@wildgooses.com>
Subject: Feature request: ip_set for non-modular kernel
Date: Thu, 05 May 2011 13:41:35 +0100
Message-ID: <4DC29AFF.5060901@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:39334 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1EEMlg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2011 08:41:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, Love the ip_set features - any chance that you might provide the
code (or possibly just instructions?) to build into the kernel in a
non-modular fashion? (for 2.6.38 and earlier)

The use case is a small embedded platform that has a slow modprobe
performance and modprobing at boottime directly affects the perceived
boot time speed (ie that's what I need to optimise).  Additionally it
helps with my build scripts - not your concern, but it would simplify my
build scripts

Thanks for your consideration!

Ed W
