From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] Fix NAT issue in 2.6.30.4+
Date: Thu, 17 Sep 2009 12:51:41 +0200
Message-ID: <200909171251.41577.thomas.jarosch@intra2net.com>
References: <alpine.DEB.2.00.0909102134290.12124@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:39905 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZIQLP7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:15:59 -0400
In-Reply-To: <alpine.DEB.2.00.0909102134290.12124@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Vitezslav Samel discovered that since 2.6.30.4+ active FTP can not work
> over NAT. 

Confirmed on 2.6.30.5 ;-) I haven't tried the patch yet...

Thomas

