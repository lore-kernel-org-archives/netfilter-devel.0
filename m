From: John Haxby <john.haxby@oracle.com>
Subject: SYSRQ in mainline kernel?
Date: Thu, 25 Feb 2010 11:08:55 +0000
Message-ID: <4B865A47.4080802@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:63262 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab0BYLJu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:09:50 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet11.oracle.com (Switch-3.4.2/Switch-3.4.2) with ESMTP id o1PB9mmL003892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Feb 2010 11:09:49 GMT
Received: from acsmt353.oracle.com (acsmt353.oracle.com [141.146.40.153])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o1OJPkom018982
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Feb 2010 11:09:47 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Some time ago, when I submitted changes to make SYSRQ a little more 
secure, it was suggested that perhaps this should be submitted to the 
mainline kernel.    I think it was Patrick McHardy that suggested it.  I 
could've done with this a couple of days ago and the recent SYSRQ patch 
jogged my memory.

What do I need to do to make this happen (or at least begin to happen)?

jch
