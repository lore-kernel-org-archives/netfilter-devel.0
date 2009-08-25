From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Tue, 25 Aug 2009 17:46:03 +0200
Message-ID: <4A94073B.80106@plouf.fr.eu.org>
References: <4A93D817.4080706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:62340 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZHYPqF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:46:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id 968D839DE91
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2009 17:46:02 +0200 (CEST)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3kzp7tB3-zRF for <netfilter-devel@vger.kernel.org>;
	Tue, 25 Aug 2009 17:46:01 +0200 (CEST)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by poutre.nerim.net (Postfix) with ESMTP id 86BC739DE8E
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2009 17:46:01 +0200 (CEST)
In-Reply-To: <4A93D817.4080706@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

May I ask what are the reasons for a helper to drop packets ?
