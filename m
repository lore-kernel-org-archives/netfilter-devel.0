From: Patrick McHardy <kaber@trash.net>
Subject: Re: [03/19] common error messages
Date: Sun, 20 Jan 2008 14:18:53 +0100
Message-ID: <47934A3D.80505@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161448440.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57753 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYATNTw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:19:52 -0500
In-Reply-To: <Pine.LNX.4.64.0801161448440.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Error messages vary wildly among modules, and there is a lot of
> reundance in it too. Introduce a helper function that does all of
> the parameter checking boilerplate and gives unique messages.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Looks good, applied.
