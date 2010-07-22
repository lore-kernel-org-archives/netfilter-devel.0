From: Tino Keitel <tkeitel@innominate.com>
Subject: How to filter connections using connmark with
 libnetfilter_conntrack
Date: Thu, 22 Jul 2010 18:35:40 +0200
Message-ID: <20100722163540.GA14567@tkeitel002.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:51899 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0GVQfq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:35:46 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id 0BF4D232BE
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2010 18:35:47 +0200 (CEST)
Received: from home.innominate.com ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id flTIE9G+e23a for <netfilter-devel@vger.kernel.org>;
	Thu, 22 Jul 2010 18:35:46 +0200 (CEST)
Received: from tkeitel002.bln.innominate.local (unknown [10.1.0.104])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by home.innominate.com (Postfix) with ESMTPS id E3BF4231D7
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2010 18:35:46 +0200 (CEST)
Received: from tkeitel by tkeitel002.bln.innominate.local with local (Exim 4.71)
	(envelope-from <tkeitel@innominate.com>)
	id 1ObykG-0003no-RS
	for netfilter-devel@vger.kernel.org; Thu, 22 Jul 2010 18:35:40 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to get conntrack update events for all connections that go
through FORWARD, but not through INPUT or OUTPUT.  I tried to set a
connmark bit and check for the mark.  But I saw no way to filter for a
given mark value using a kernel filter.  Did I miss something?  I
already filter in userspace, but I want to avoid this if possible.

Regards,
-- 
Tino Keitel
Software Engineer
 
Innominate Security Technologies AG
/protecting industrial networks/
Tel: +49.30.921028-206
Fax: +49.30.921028-020
Rudower Chaussee 13
12489 Berlin / Germany
http://www.innominate.com/

Register Court: AG Charlottenburg, HRB 81603 Management Board: Dirk
Seewald, Chairman of the Supervisory Board: Volker Bibelhausen
