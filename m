From: Lutfi <lutfio@metu.edu.tr>
Subject: ipset timeout problem
Date: Tue, 17 May 2011 10:57:31 +0300
Message-ID: <4DD22A6B.9080904@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from likya.general.services.metu.edu.tr ([144.122.144.158]:46042
	"EHLO mail.metu.edu.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1EQH5W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2011 03:57:22 -0400
Received: from [144.122.3.229] (sandal.cc.metu.edu.tr [144.122.3.229])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.metu.edu.tr (Postfix) with ESMTPSA id C0E995052B
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2011 10:57:19 +0300 (EEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I am using ipset v. 6.2 on my Debian 6.0 64 bit box with kernel verison
2.6.37.2 #12. I used the command  "ipset create test iptree  --timeout
10800" for creating  the set and add the ip addresses by using "ipset
add test x.x.x.x". At beginning there seems no problem but after a while
timeout values increases for ip addresses. Moreover I use a script to
add those ip addresses to this set.  The output of "ipset
list test" is below:

Name: test
Type: hash:ip
Header: family inet hashsize 8192 maxelem 65536 timeout 10800
Size in memory: 733184
References: 3
Members:
82.192.209.168 timeout 14134968
208.64.3.39 timeout 14365461
208.64.174.47 timeout 14384661
82.192.190.201 timeout 14132269
82.192.9.77 timeout 8601380
82.192.27.13 timeout 12652080
82.192.3.140 timeout 12380980
208.64.124.180 timeout 14378563
208.64.50.80 timeout 14370262
82.192.83.196 timeout 13290880
188.132.196.169 timeout 39439453
82.192.42.169 timeout 12851080
208.64.104.203 timeout 6423
82.192.19.153 timeout 12571180
208.64.43.25 timeout 14369162
82.192.70.245 timeout 13141480

you can see the timeout values are much more higher than 10800 seconds
but some of them are correct.

What does cause this problem?

Regards,

Lutfi



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJN0ipqAAoJEOASPA9veM4zHvUH/jnQ/8PV+GC8kZu7yHuWR5dS
rz/iziJat1X1nE626JOJjI0nQuxAuOtbUwtOoslprgf0WZB0Sk04ewxL1DdmlerT
hcGN7lVwGtOczrgRXS8i6DoSqH9KSzSyxqdnT1kuQ8VEI0CBfVeZh313kCk644sT
0G3gGPMjDtS1FY6brUAFZtFQq9GJjgVZcUiSQK+3xVQewUEKoLPoJfVyDnt+MBMz
TPXhYKLQtRwLQN9efmNwlrNxJa1ux5VhmCxNPycWfog1Av6tUnBzxbNYzuYiob6h
9rUC7voMiBffNE26O1mf9mFGmyLSjPmPZ4Ca5T3vDFRcz36R5x8K4Cs0/VC+Xu0=
=2LZD
-----END PGP SIGNATURE-----
