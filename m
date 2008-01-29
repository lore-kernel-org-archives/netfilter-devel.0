From: Patrick McHardy <kaber@trash.net>
Subject: Re: Transmit mark during connection destruction event
Date: Tue, 29 Jan 2008 14:38:28 +0100
Message-ID: <479F2C54.8030109@trash.net>
References: <20080128231323.GA24226@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55230 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761543AbYA2Ny1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:54:27 -0500
In-Reply-To: <20080128231323.GA24226@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
> 
> The following feature was submitted some months ago. It forces the dump
> of mark during the connection destruction event. The induced load is
> quiet small and the patch is usefull to provide an easy way to filter
> event on user side without having to keep an hash in userspace.
> 
> This new version is against 2.6.24 git tree.


It clashed with some changes I had queued locally, but I fixed it
up and applied it. Thanks Eric.
