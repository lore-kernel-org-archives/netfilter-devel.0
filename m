From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: add m4 directory
Date: Sat, 21 Feb 2009 20:21:48 +0100
Message-ID: <49A0544C.9060404@netfilter.org>
References: <alpine.LSU.2.00.0902212005220.31533@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39071 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753842AbZBUTVy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:21:54 -0500
In-Reply-To: <alpine.LSU.2.00.0902212005220.31533@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent 9bf002ff7935e7dff625683787fc3a06ac2ef2cb (conntrack-tools-0.9.11-1-g9bf002f)
> commit be1ed556e5045846430cdfecfead1543faed5272
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sat Feb 21 20:04:33 2009 +0100
> 
> build: add m4 directory
> 
> Since 4dd73e4e34b57685d8a85e041f6a0b4a65200e30, the "m4" directory
> is missing because git stores no empty directories. Add the
> appropriate .gitignore file and the problem resolves itself.

Applied, thanks Jan.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
