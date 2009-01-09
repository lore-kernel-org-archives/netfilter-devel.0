From: Ryan VanRiper <ryan.vanriper@adventiumlabs.org>
Subject: ENOBUF error during recv
Date: Fri, 9 Jan 2009 14:54:45 -0600
Message-ID: <200901091454.45485.ryan.vanriper@adventiumlabs.org>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr>
Reply-To: ryan.vanriper@adventiumlabs.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cp.exo2.net ([204.11.35.3]:50051 "EHLO mail1.exo2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757426AbZAIVBd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:01:33 -0500
In-Reply-To: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am using the nfqnl_test.c program and noticed that under network load (ie. 
sending a 20meg text file) the while loop doing the recv in main() fails and 
after some debugging returns a perror of ENOBUFF (105) ?

Any ideas why this would happen ?

I using centos 5.2 i386 32bit, and 2.6.18 kernel.

Thanks,
Ryan
