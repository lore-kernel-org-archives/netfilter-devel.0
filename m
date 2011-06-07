From: Lutfi ODUNCUOGLU <lutfio@metu.edu.tr>
Subject: Iptables 1.4.11 can not be compiled with 2.6.39.1 kernel Debian Squeeze
Date: Tue, 07 Jun 2011 12:33:40 +0300
Message-ID: <4DEDF074.7070904@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from likya.general.services.metu.edu.tr ([144.122.144.158]:33697
	"EHLO mail.metu.edu.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1FGJdi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:33:38 -0400
Received: from [144.122.3.229] (sandal.cc.metu.edu.tr [144.122.3.229])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.metu.edu.tr (Postfix) with ESMTPSA id 548E6506DC
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2011 12:33:35 +0300 (EEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am just traying to compile iptables 1.4.11 under Debian Squeeze with
kernel
Linux test 2.6.39.1 #1 SMP Tue Jun 7 10:51:23 EEST 2011 x86_64 GNU/Linux

I just did
./configure
make
make install

when I ls -la the /usr/local/sbin/iptables, the output is:


lrwxrwxrwx 1 root staff 14 Jun  7 12:26 /usr/local/sbin/iptables ->
iptables-multi

But when I give the command

/usr/local/sbin/iptables -V

it returns me

/usr/local/sbin/iptables: No such file or directory

Now I just compiled iptables 1.4.10 and it works without problem.

/usr/local/sbin/iptables -V
iptables v1.4.10

What may be the problem?

Regards,

Lutfi
