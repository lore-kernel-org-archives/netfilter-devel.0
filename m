From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: [xtables-addons] geoip in Debian 7 working fine (--> please update
 the distro matrix)
Date: Mon, 15 Oct 2012 13:55:15 +0200
Message-ID: <k5gtj2$ou2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54136 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab2JOLz1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:55:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1TNjGd-000051-4S
	for netfilter-devel@vger.kernel.org; Mon, 15 Oct 2012 13:55:31 +0200
Received: from 77-21-150-226-dynip.superkabel.de ([77.21.150.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2012 13:55:31 +0200
Received: from for-gmane by 77-21-150-226-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2012 13:55:31 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
please update the matrix at
http://xtables-addons.sourceforge.net/distro-support.php?p=kernel%7Ciptables%7Cxtables-addons%7Cxtables-geoip&d=.*
for Debian 7 (wheezy), as geoip is working well in that distribution
(the pkg "xtables-addons-common" from the debian repo must be installed).

Proof:
  1050 44349 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            Source country: CN
    11   374 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            Source country: HK

:-)

