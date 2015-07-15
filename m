From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [Q] iptables AH module api mismatch between -master and 1.4.7
Date: Wed, 15 Jul 2015 15:15:22 +0300
Message-ID: <20150715121521.GK2034@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: vzdevel <devel@openvz.org>, Pavel Emelyanov <xemul@virtuozzo.com>,
	Konstantin Khorenko <khorenko@virtuozzo.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33450 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbGOMP0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 08:15:26 -0400
Received: by lbbyj8 with SMTP id yj8so23624424lbb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jul 2015 05:15:25 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello! Could you clarify please the following aspect: before the commit

 | commit 6944f2c8190f1c4319aeac748470c71b0ba45025
 | Author: Jan Engelhardt <jengelh@medozas.de>
 | Date:   Tue May 24 23:50:29 2011 +0200
 |
 |    libxtables: have xtopt_parse_mint interpret partially-spec'd ranges
 |
 |    When ":n" or "n:" is specified, it will now be interpreted as "0:n"
 |    and "n:<max>", respecitvely. nvals will always reflect the number of
 |    (expanded) components. This restores the functionality of options that
 |    take such partially-unspecified ranges.
 |
 |    This makes it possible to nuke the per-matchdata init functions of
 |    some extensions and simply the extensions postparsing to the point
 |    where it only needs to check for nvals==1 or ==2.
 |
 |    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

if the AH module has no --ahspi argument passed to iptables then it
became [0;0xffffffff] by default, but in -master branch it becomes
[0;0] instead, which implies that if iptables-save is called with
latest -master branch it should not be used with old (1.4.7)
iptables-restore otherwise the kernel would see different --ahspi
ranges. Thus (if only I'm not missing something obvious) this is
abi breakage and old behaviour should be fixed (I'm gonna prepare
a patch for that but would love to know first if it's needed)?

	Cyrill
