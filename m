From: Luca Pesce <pesce.luca@gmail.com>
Subject: Re: R:Re: Questions about early_drop()
Date: Sat, 7 Nov 2009 16:29:35 +0100
Message-ID: <873dce860911070729t51476ac3pc3b3dd358bfdbc35@mail.gmail.com>
References: <0016e6d7ea70951fbb04779150de@google.com>
	 <4AF2C3DC.7070200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46737 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZKGPex (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2009 10:34:53 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so2110192bwz.21
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Nov 2009 07:34:58 -0800 (PST)
In-Reply-To: <4AF2C3DC.7070200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 5, 2009 at 1:23 PM, Patrick McHardy <kaber@trash.net> wrote:
> The default is not properly sized, its a trade-off between memory
> use and performance. A good size would be 2 * max_entries since
> each conntrack is hashed twice.
>

Ok, I seem to understand: since each tuple is hased in the table,
actually the real table size is double of the nf_conntrack_max
parameter, so to have maximum performance (1 entry per bucket) we
should have a table with size = 2*nf_conntrack_max. Am I right?
Thank you very much for the explanation.
Luca
