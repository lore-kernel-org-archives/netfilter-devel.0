From: David Miller <davem@davemloft.net>
Subject: Re: Replacement for nf-HiPAC
Date: Mon, 05 Mar 2012 00:00:24 -0500 (EST)
Message-ID: <20120305.000024.1765921018367596593.davem@davemloft.net>
References: <CA+tq5hxfg7pH_aYGwsREURfiRBc4=-Xu=3=UJSJ136D_NNmPhQ@mail.gmail.com>
	<CA+tq5hx5u-VLdz45qfHNK7+CLymoqOo8WDYSgY-0E7deCV+nhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: abhi@devireddy.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:48558 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2CEFA1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 00:00:27 -0500
In-Reply-To: <CA+tq5hx5u-VLdz45qfHNK7+CLymoqOo8WDYSgY-0E7deCV+nhQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


We have a full packet classifier in the packet scheduler,
which gets processed before the networking stack even sees
the packet, and have had one there for more than 15 years.
