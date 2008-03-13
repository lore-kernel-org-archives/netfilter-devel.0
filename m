From: "Nishit Shah" <nishit@elitecore.com>
Subject: Do nfnl_query and nfnl_catch are blocking fuctions ?
Date: Thu, 13 Mar 2008 17:35:41 +0530
Message-ID: <000e01c88502$8f4212c0$adc63840$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:51726 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752667AbYCMMEz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:04:55 -0400
Received: from nishitshah.elitecore.co.in (HELO elitecore3) ([192.168.1.76])
          (envelope-sender <nishit@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 13 Mar 2008 11:41:20 -0000
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Is it possible that on hi=
gh rate of conntrack
addition/deletion/updation, nfnl_query or nfnl_catch, If space is not
available at the sending socket these fuctions will block as they are u=
sing
sendto and recvmsg calls ?

Rgds,
Nishit Shah.=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
