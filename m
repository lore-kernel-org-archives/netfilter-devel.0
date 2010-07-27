From: Andrew Beverley <andy@andybev.com>
Subject: Re: question about libfilter_conntrack
Date: Tue, 27 Jul 2010 07:12:39 +0100
Message-ID: <1280211159.1462.54.camel@andybev>
References: <AANLkTinSbAJfzTyxJRawHzA05u73fZpgoUXDABNQ+v=y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pete Kay <petedao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:47296 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0G0GMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jul 2010 02:12:51 -0400
In-Reply-To: <AANLkTinSbAJfzTyxJRawHzA05u73fZpgoUXDABNQ+v=y@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I would like to use libfilter_conntrack to remove an entry in the
> conntrack table.
> 
> Does anyone have an example showing how to do that programmatically?

There's an example in the source code, in utils/conntrack_delete.c

Andy


