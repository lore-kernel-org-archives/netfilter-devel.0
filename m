From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: null-pointer deref in ulogd2
Date: Tue, 23 Jun 2009 08:31:58 +0000 (UTC)
Message-ID: <h1q3tu$2vi$1@ger.gmane.org>
References: <h1q05h$o8h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59572 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZFWIcH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:32:07 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MJ1QH-0005xa-3E
	for netfilter-devel@vger.kernel.org; Tue, 23 Jun 2009 08:32:09 +0000
Received: from ppp-82-135-84-171.dynamic.mnet-online.de ([82.135.84.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 08:32:09 +0000
Received: from berni by ppp-82-135-84-171.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 08:32:09 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Schmidt <berni@birkenwald.de> wrote:

> now it seems to work okay. In the database about 90% of the flows have
> flow_end_sec NULL.

Just had a closer look, flow_start_sec can be NULL as well.

ulogd=# SELECT COUNT(*) FROM ulog2_ct WHERE flow_start_sec IS NOT NULL
AND flow_end_sec IS NOT NULL;
 count 
-------
 88793
(1 row)

ulogd=# SELECT COUNT(*) FROM ulog2_ct WHERE flow_start_sec IS NULL AND
flow_end_sec IS NOT NULL;
 count  
--------
 320560
(1 row)

ulogd=# SELECT COUNT(*) FROM ulog2_ct WHERE flow_start_sec IS NOT NULL
AND flow_end_sec IS NULL;
 count  
--------
 407220
(1 row)

ulogd=# SELECT COUNT(*) FROM ulog2_ct WHERE flow_start_sec IS NULL AND
flow_end_sec IS NULL;
 count 
-------
     0
(1 row)

What is happening here?

Bernhard

