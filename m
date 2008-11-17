From: John Haxby <john.haxby@oracle.com>
Subject: Problem compiling
Date: Mon, 17 Nov 2008 16:29:38 +0000
Message-ID: <49219BF2.6090904@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet14.oracle.com ([141.146.126.236]:46922 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKQQbW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:31:22 -0500
Received: from acsinet12.oracle.com (acsinet12.oracle.com [141.146.126.234])
	by acsinet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mAHGWkJH011784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 16:32:47 GMT
Received: from rgminet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by acsinet12.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mAHGTX69011573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 16:29:35 GMT
Received: from acsmt700.oracle.com (acsmt700.oracle.com [141.146.40.70])
	by rgminet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mAHGTlx9018350
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 16:29:48 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

I'm having problems compiling this: 
http://marek.terminus.sk/prog/ipt_sysrq.shtml

This is on Fedora 9 and RHEL5 and in both cases I get this error:

/usr/include/iptables.h:5:29: error: libiptc/libiptc.h: No such file or 
directory

Now, the easiest way to "fix" this is it to make sure that 
libiptc/libiptc.h is installed into /usr/include but I'm wary of this as 
libiptc.a has a comment in the Makefile that says "libiptc is not a 
public interface and therefore not installed."

What is the right thing to do here?   Install the missing header file(s) 
or fix the normally installed header files to not refer to those that 
aren't?

jch
