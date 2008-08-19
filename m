From: David P Olshefski <olshef@us.ibm.com>
Subject: kernel crash in ebtables 2.0.8-2 - too many rules??
Date: Tue, 19 Aug 2008 09:44:03 -0400
Message-ID: <OF69038DDF.86CD51FE-ON852574AA.004AEA6E-852574AA.004B73CE@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45915 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYHSNoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:44:09 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7JDi88s030642
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:44:08 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7JDi8tr207966
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:44:08 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7JDi8dF015347
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:44:08 -0400
Received: from d01ml604.pok.ibm.com (d01ml604.pok.ibm.com [9.56.227.90])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m7JDi8DM015336
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:44:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am getting a crash in translate_table after creating about 140 
rules.....is there a rule limit? 

David O.
