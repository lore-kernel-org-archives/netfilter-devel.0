From: Srinivasa T N <seenutn@linux.vnet.ibm.com>
Subject: ipt_NETFLOW and xtables-addons
Date: Mon, 31 Jan 2011 12:47:07 +0530
Message-ID: <4D4661F3.4070507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35818 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1AaHRN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:17:13 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp02.in.ibm.com (8.14.4/8.13.1) with ESMTP id p0V7H8nD012267
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2011 12:47:08 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p0V7H7oW3559622
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2011 12:47:08 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p0V7H7FU021479
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2011 12:47:07 +0530
Received: from [9.124.151.148] ([9.124.151.148])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p0V7H71K021475
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2011 12:47:07 +0530
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
    Can I compile ipt_NETFLOW standalone (i.e., use pom and not change 
kernel)?  Or should I integrate that with xtables-addons?  If I have to 
integrate, how can I do so?

Regards,
Seenu.
