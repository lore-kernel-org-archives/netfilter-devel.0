From: Alex william <alex.william21@outlook.com>
Subject: [IPTABLES] Module ipt_same
Date: Fri, 31 Jul 2015 09:24:27 +0400
Message-ID: <BLU436-SMTP2146D2AF1763E1C081B991E9A8A0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu004-omc1s8.hotmail.com ([65.55.116.19]:61863 "EHLO
	BLU004-OMC1S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbbGaFp1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Jul 2015 01:45:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

My objective is if ip A.A.A.A goes to B.B.B.B it is natted with IP X.X.X.X
then if A.A.A.A re-establishes a session with B.B.B.B it is natted with
the same IP X.X.X.X. According to my reseach the module ipt_same does
that: 

SAME (IPv4-specific) Similar to SNAT/DNAT depending on chain: it takes a
range of addresses (`--to 1.2.3.4-1.2.3.7') and gives a client the same
source-/destination-address for each connection.

But seems like the module ipt_same is not available under iptables v1.4.21
Kernel: 3.16.7. 

Are there any module available that can help achieve my objective?

Thanks.

Regards,
Kaviraj


