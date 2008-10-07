From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/23] netfilter: ip6tables: fix Kconfig entry dependency
 for ip6t_LOG
Date: Tue, 07 Oct 2008 15:19:11 +0200
Message-ID: <48EB61CF.9040308@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <164ab02780d16ab7920e7495fef6d72f0fd05ab9.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45543 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYJGNTS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:19:18 -0400
In-Reply-To: <164ab02780d16ab7920e7495fef6d72f0fd05ab9.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ip6t_LOG does certainly not depend on the filter table.
> (Also, move it so that menuconfig still displays it correctly.)

Applied, thanks.

