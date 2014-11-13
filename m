From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: x_tables: eb_tables: limit.0 match: invalid size 32 (kernel) !=
 (user) 24
Date: Thu, 13 Nov 2014 16:10:28 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1411131608030.26202@nerf08.vanv.qr>
References: <CAJsRc6i_vEWAOEUJVrx5t0DtNHZdMg5jj3N726YSOs7zX_pCcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ronny Janssen <ronny.janssen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:53304 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138AbaKMPK3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:10:29 -0500
In-Reply-To: <CAJsRc6i_vEWAOEUJVrx5t0DtNHZdMg5jj3N726YSOs7zX_pCcg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2014-11-13 15:25, Ronny Janssen wrote:

>[  320.376828] x_tables: eb_tables: limit.0 match: invalid size 32
>(kernel) != (user) 24
>
>Question is.. what would be the proper solution?

This has been reported so often already - did you check?
There is no programmatic solution. The kernel can only recognize at most 
two formats, which breaks down when people throw in userspaces with a 
third ABI.
