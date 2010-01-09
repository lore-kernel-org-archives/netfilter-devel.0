From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: for ebtables ? net set type request (ip + vlan)
Date: Sat, 9 Jan 2010 14:58:18 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1001091455160.14468@blackhole.kfki.hu>
References: <4B487CDA.7080006@dsn.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Nikolay Nuzhdin <ds@dsn.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:40942 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0AIN6V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:58:21 -0500
In-Reply-To: <4B487CDA.7080006@dsn.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 9 Jan 2010, Nikolay Nuzhdin wrote:

> Is where plans to release ipset support for ebtables and arptables?

Do you mean to store and match IP address/network + VLAN id pairs? No, I 
haven't thought of that yet. It seems as a feature candidate for the next 
major branch.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
