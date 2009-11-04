From: Patrick McHardy <kaber@trash.net>
Subject: Re: early_drop() possible issue?
Date: Wed, 04 Nov 2009 12:34:15 +0100
Message-ID: <4AF166B7.2000608@trash.net>
References: <0016e6d64c234ca84604775639a4@google.com> <873dce860911011458v7a4f1fe8l93c11c1ecb9af8be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Luca Pesce <pesce.luca@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36019 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbZKDLeN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:34:13 -0500
In-Reply-To: <873dce860911011458v7a4f1fe8l93c11c1ecb9af8be@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Pesce wrote:
> Sorry, I re-worked the patch, because it was buggy (ct_general.use was
> incremented, not tested).
> Here is the (hopefully) correct one:

Your patch is whitespace corrupted, as is the remainder of the email.
Please resend as attachment with a description of what this is trying
to do.
