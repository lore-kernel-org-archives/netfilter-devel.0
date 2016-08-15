From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4, V2, libnftnl] tests: Fix segfaults due outbound
 access
Date: Mon, 15 Aug 2016 11:12:39 +0200
Message-ID: <20160815091239.GC3905@salvia>
References: <20160811233222.GB5108@salvia>
 <20160812201722.10134-1-carlosfg@riseup.net>
 <20160813101210.GD1376@salvia>
 <55d5bbb9-bfba-5cb3-11d1-348ce2e20675@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbcHOJMp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 05:12:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 21D91A4165
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 11:12:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 15ECADA7F7
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 11:12:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1A594DA7E7
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 11:12:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <55d5bbb9-bfba-5cb3-11d1-348ce2e20675@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 13, 2016 at 05:25:19PM +0200, Carlos Falgueras García wrote:
> Another possible solution is something like this:
> 
> 	  static const char *element2str(uint32_t element) {
> 	- 	if (element < MAX_ELEMENT)
> 	+ 	if (element < MAX_ELEMENT || !element2str_array[element])
> 	  		return "unkown";
> 	  	return element2str_array[element];
> 	  }
> 
> What do you think?

This only requires a oneliner patch and a very simple solution, please
do this.
