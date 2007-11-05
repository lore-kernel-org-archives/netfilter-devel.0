From: "ron lai" <ronlai@cs.stanford.edu>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Mon, 5 Nov 2007 08:36:13 -0800
Message-ID: <001c01c81fc9$fb5a0f10$6500a8c0@ronPc>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <472EF88E.8030006@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: "Patrick McHardy" <kaber@trash.net>, <netfilter@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>
To: "Amin Azez" <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cs-smtp-1.Stanford.EDU ([171.64.64.25]:53564 "EHLO
	cs-smtp-1.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbXKEQfd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:35:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The problem happens in both SNAT only and SNAT+DNAT cases.

Ron
----- Original Message ----- 
From: "Amin Azez" <azez@ufomechanic.net>
To: "Ron Lai" <ronlai@cs.stanford.edu>
Cc: "Patrick McHardy" <kaber@trash.net>; <netfilter@vger.kernel.org>; 
<netfilter-devel@vger.kernel.org>
Sent: Monday, November 05, 2007 3:03 AM
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 
2.6.22.6


> Are you doing SNAT and DNAT on the same connection?
>
> Sam
>
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

