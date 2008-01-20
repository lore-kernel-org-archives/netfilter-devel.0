From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] [NETFILTER]: ebtables: mark matches, targets and
 watchers __read_mostly
Date: Sun, 20 Jan 2008 15:52:51 +0100
Message-ID: <47936043.2030103@trash.net>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801172110550.18447@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59621 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYATOxv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:53:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801172110550.18447@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 110d4caa32e46b7dd78e6b59518e0137fc02a6e4
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Thu Jan 17 20:12:15 2008 +0100
> 
>     [NETFILTER]: ebtables: mark matches, targets and watchers __read_mostly


This doesn't apply without the first patch.
