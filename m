From: Andrew Beverley <andy@andybev.com>
Subject: Re: event callback in netfilter-conntrack
Date: Fri, 13 Aug 2010 14:49:36 +0100
Message-ID: <1281707376.29275.14.camel@andybev>
References: <AANLkTi=QAxRdeh1srRh8Xdz1qS2eJBzxcRfoNot4=GYd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pete Kay <petedao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:54162 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab0HMNuN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:50:13 -0400
In-Reply-To: <AANLkTi=QAxRdeh1srRh8Xdz1qS2eJBzxcRfoNot4=GYd@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Does anyone know how to obtain the original sport value from struct
> nf_conntrack *ct within the event callback handler?
> 

I imagine something like:

port = nfct_get_attr_u16(ct, ATTR_PORT_SRC);

Remember that you may need to use ntohs() to make it readable in the
format you want it.

Regards,

Andy


