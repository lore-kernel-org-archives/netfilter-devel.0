From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: [xtables-addons] geoip in Debian 7 working fine (--> please update
 the distro matrix)
Date: Thu, 18 Oct 2012 19:48:32 +0200
Message-ID: <508040F0.4050006@mutluit.com>
References: <k5gtj2$ou2$1@ger.gmane.org> <alpine.LNX.2.01.1210181915570.16412@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39523 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab2JRRsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:48:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1TOuDB-00012V-6G
	for netfilter-devel@vger.kernel.org; Thu, 18 Oct 2012 19:48:49 +0200
Received: from 77-21-150-226-dynip.superkabel.de ([77.21.150.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Oct 2012 19:48:49 +0200
Received: from for-gmane by 77-21-150-226-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Oct 2012 19:48:49 +0200
In-Reply-To: <alpine.LNX.2.01.1210181915570.16412@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote, On 10/18/2012 07:18 PM:
> On Monday 2012-10-15 13:55, U.Mutlu wrote:
>
>> Hello,
>> please update the matrix at
>> http://xtables-addons.sourceforge.net/distro-support.php?p=kernel%7Ciptables%7Cxtables-addons%7Cxtables-geoip&d=.*
>> for Debian 7 (wheezy), as geoip is working well in that distribution
>> (the pkg "xtables-addons-common" from the debian repo must be installed).
>
> Debian does not provide a xtables-geoip package.

As said, I've it working fine here, I used the following steps:

apt-get install xtables-addons-common libtext-csv-xs-perl
mkdir -p /usr/share/xt_geoip
cd /usr/lib/xtables-addons
./xt_geoip_dl
./xt_geoip_build -D /usr/share/xt_geoip *.csv

then restart the firewall script with the iptables geoip rules.

But: this is on physical host nodes only, don't know if it works also
in virtual systems like openvz containers on the host


