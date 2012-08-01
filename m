From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd - long living connections
Date: Wed, 1 Aug 2012 18:54:02 +0200
Message-ID: <20120801165402.GA19512@1984>
References: <CAAJpzgYSo5_sXunijxBBdWrJET1hLJ8gPw0WLZod-m4jxZHosw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54192 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab2HAQyI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:54:08 -0400
Content-Disposition: inline
In-Reply-To: <CAAJpzgYSo5_sXunijxBBdWrJET1hLJ8gPw0WLZod-m4jxZHosw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 31, 2012 at 08:27:29PM -0700, Gomathivinayagam Muthuvinayagam wrote:
> Hi,
> 
> I feel current ulogd based accounting has some issues. It provides the
> account usage during the destroy event. This is an issue for long
> living connections, like alerting the user when he exceeds the quota.
> I read the solution from the pdf published by Herald, 2005.
> 
> Snippet is given below
> 
> To overcome limitation number one, the accounting process can use a
> combined event and polling scheme. The granularity of accounting can
> therefore be configured by the polling interval,
> and a compromise between performance and accuracy can be made.
> 
> Current ulogd2 has not yet have the functionality. The reason is,
> polling based accounting does not provide any unique id for a
> particular connection. So even if we generate polling based data and
> event based data, there is no way to combine the data. If you guys
> already thought about solution for this problem, can you share it?

You can combine that data using the hashtable that ulogd2 uses. You
only has to pass the ct object that you receive from the dump to look
for any existing matching.
