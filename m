From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.21.1 released
Date: Fri, 7 Mar 2014 17:06:05 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1403071705010.22956@nerf08.vanv.qr>
References: <alpine.DEB.2.10.1403071328240.32311@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:34938 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbaCGQGH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:06:07 -0500
In-Reply-To: <alpine.DEB.2.10.1403071328240.32311@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2014-03-07 13:32, Jozsef Kadlecsik wrote:

>Userspace changes:
>  - Fix libipset library release versioning (reported by Mathieu Bridon)

AFAICS, functions were only added, yet the SONAME was changed.
(-version-info 7:0:4 should have been -version-info 7:0:5)
