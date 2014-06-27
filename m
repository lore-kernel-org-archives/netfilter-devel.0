From: giorgio.nicole@arcor.de
Subject: libnftnl.pc lacks dependency from libmnl
Date: Fri, 27 Jun 2014 11:16:25 +0200 (CEST)
Message-ID: <1005632599.974483.1403860585336.JavaMail.ngmail@webmail09.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:39241 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbaF0JQ1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:16:27 -0400
Received: from mail-in-11-z2.arcor-online.net (mail-in-11-z2.arcor-online.net [151.189.8.28])
	by mx.arcor.de (Postfix) with ESMTP id 5B834D8182
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2014 11:16:25 +0200 (CEST)
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net [151.189.21.50])
	by mail-in-11-z2.arcor-online.net (Postfix) with ESMTP id 5283E7FE6C5
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2014 11:16:25 +0200 (CEST)
Received: from webmail09.arcor-online.net (webmail09.arcor-online.net [151.189.8.45])
	by mail-in-10.arcor-online.net (Postfix) with ESMTP id 44F422D71ED
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2014 11:16:25 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've noticed that the pkg-config file libnftnl.pc installed by the
library package misses the dependency from libmnl in
the 'Required:' line.

# cat libnftnl.pc.in
# libnftnl pkg-config file

prefix=@prefix@
exec_prefix=@exec_prefix@
libdir=@libdir@
includedir=@includedir@

Name: libnftnl
Description: Netfilter nf_tables infrastructure library
URL: http://netfilter.org/projects/libnftnl/
Version: @VERSION@
Requires:                                                             <=== this line
Conflicts:
Libs: -L${libdir} -lnftnl
Cflags: -I${includedir}


giorgio
