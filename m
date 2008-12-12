From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Fri, 12 Dec 2008 08:38:39 +0000
Message-ID: <4942230F.2000106@oracle.com>
References: <492E926D.5020807@oracle.com> <4935747C.5090207@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:57187 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYLLIis (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:38:48 -0500
Received: from acsinet13.oracle.com (acsinet13.oracle.com [141.146.126.235])
	by acsinet11.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mBC8dkK5013531
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2008 08:39:48 GMT
Received: from acsmt701.oracle.com (acsmt701.oracle.com [141.146.40.71])
	by acsinet13.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mBC8d7Qj025116
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2008 08:39:08 GMT
In-Reply-To: <4935747C.5090207@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

John Haxby wrote:
> Hello All,
>
> This is a patch to the SYSRQ xtables-addon that is, I believe, secure 
> enough to use in moderately untrustworthy environments.
>
> This is an updated version of the patch to address comments previously 
> received.   The main change, prompted by Patrick McHardy's question, 
> is to allow the hash algorithm to be changed at module load time.  
> Other than that I've clarified the '\n' password termination and 
> updated the man page to include using -m limit, the configurable hash 
> algorithm and made it a little that you can send multiple request keys.

I don't know if I'm being overly anxious or impatient, but is there 
anything more I need to do for this updated patch?

jch
