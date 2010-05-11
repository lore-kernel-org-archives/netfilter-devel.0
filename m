From: John Haxby <john.haxby@oracle.com>
Subject: Whither xt_SYSRQ?
Date: Tue, 11 May 2010 15:32:06 +0100
Message-ID: <4BE96A66.4040607@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:50943 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0EKOcY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 10:32:24 -0400
Received: from rcsinet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o4BEWN0j025479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2010 14:32:24 GMT
Received: from acsmt353.oracle.com (acsmt353.oracle.com [141.146.40.153])
	by rcsinet13.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o4BEWI4I027308
	for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2010 14:32:18 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The earlier discussions about whether to include xt_SYSRQ in mainline 
seem to have petered out with no clear consensus.  As I recall, there 
were two suggestions as an alternative: use k(g)dboe and use a dedicated 
standalone module.

The former suggestion, kdboe, doesn't seem to fly because it's not in 
the kernel and also (unless I'm mistaken) provides little or no 
concession to security.  It's great for development but in the case 
where xt_SYSRQ can be used in a production environment, it doesn't seem 
to work.  Providing the environment for the debugger to work in is also 
likely to involve installing a lot on a production machine that wouldn't 
normally be there.  (xt_SYSRQ is nice and light and would sit nicely 
alongside, for example, netconsole.)

The standalone module is troublesome.  If I was starting from scratch 
with that I'd be putting in filters and whatnot that match those 
provides by xtables anyway.  If everything apart from the actual 
function (sysrq) and password control is duplicated by xtables then 
you'd have to ask "why isn't this part of xtables?".

I know xt_SYSRQ is used by quite a few people and it is seen as 
generally useful, so what needs to be done to get this into the mainline 
kernel?  Once it's there it stands a good chance of being backported to 
some of the production kernels (RHEL6, I'm looking at you) but without 
having some upstream commitment that seems a distant dream.

if xt_SYSRQ isn't acceptable, what is?  (Bearing in mind that I believe 
that whatever it is needs to be acceptable to a production environment.)

jch
