From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: How to disable Connection Tracking runtime
Date: Tue, 6 May 2008 08:19:28 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805060819150.11757@fbirervta.pbzchgretzou.qr>
References: <df1bdeb10805052038y43f41d12gf45c7f512aea759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Srinivas Murthy <codevana@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56847 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYEFGTa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2008 02:19:30 -0400
In-Reply-To: <df1bdeb10805052038y43f41d12gf45c7f512aea759@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-05-06 05:38, Srinivas Murthy wrote:

>Hi,
> Is there a way to disable conntracking runtime?

Use -j NOTRACK.
