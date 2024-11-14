Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C7B18B49F;
	Thu, 14 Nov 2024 11:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731584797; cv=none; b=dTeSmExfCO5yB9BjHgTGRKDh+0mHCVRAIH/N6+JusmK8cC4FzL7VYxsxe2Ddvi/CoO7067TXW8/96jthyOvKAatsYgZ0VWX1qZmET6hR0MPzHWzImFuaUE1IxmhxGI8fh6gQLKFeBKJeiXAckY5eklpEqj9Pb0cKePjWDo1clh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731584797; c=relaxed/simple;
	bh=kBpLdhEGc7zOKzxVLXAaaIEWbOCpClUn8A3oGq7aZ/Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ajDDP5LO5kTFkPZH/1iSB0II4g2YAtj3LZTysuBaFxuyS14ftCCYRSqBkhbIzTeHHd2cW5LFmklFmImA8FoHfSVA1HiwSNHADE7h3LxQkABjqwvPceVfP4KepnZ7FFh31KU8A2HGvVkfgfJoeUe3Ai/1zEILwS/qc8K49yjsLY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=LqHtwD0N; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="LqHtwD0N"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 413B232E01C3;
	Thu, 14 Nov 2024 12:46:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1731584790; x=1733399191; bh=3iF6OqcXdH
	l2rv+0knV1DhJxbA/YKrtu8gEBD1nHGzA=; b=LqHtwD0NEHf0eKewieiDI6yJlG
	SqOjJTIkGlyTd7VX5TKu12/tCP0SuZr/7h6heOTaFaM1pRZgqgW/X2oBse2DN0B2
	RYmPsiH/Gdjn1qjp7GayjPb1ISbi4fJEEDdo+g/a2Czy9dsOQq813cya6FdCrHcY
	e7fSFHEuRZhSS3+xI=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id FufRpJMCKJMn; Thu, 14 Nov 2024 12:46:30 +0100 (CET)
Received: from mentat.rmki.kfki.hu (254C26AF.nat.pool.telekom.hu [37.76.38.175])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 268C632E01B7;
	Thu, 14 Nov 2024 12:46:30 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 8B28A1428CC; Thu, 14 Nov 2024 12:46:29 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 87F9E142175;
	Thu, 14 Nov 2024 12:46:29 +0100 (CET)
Date: Thu, 14 Nov 2024 12:46:29 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Paolo Abeni <pabeni@redhat.com>, Jeongjun Park <aha310510@gmail.com>, 
    davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
    horms@kernel.org, kaber@trash.net, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
    syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] netfilter: ipset: add missing range check in
 bitmap_ip_uadt
In-Reply-To: <ZzXfDDNSeO0vh1US@calendula>
Message-ID: <759eccdd-f75b-f3a7-8686-d4c49c72df41@blackhole.kfki.hu>
References: <20241113130209.22376-1-aha310510@gmail.com> <ff1c1622-a57c-471e-b41f-8fb4cb2f233d@redhat.com> <ZzXfDDNSeO0vh1US@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: maybeham 2%

On Thu, 14 Nov 2024, Pablo Neira Ayuso wrote:

> On Thu, Nov 14, 2024 at 12:10:05PM +0100, Paolo Abeni wrote:
> > On 11/13/24 14:02, Jeongjun Park wrote:
> > > When tb[IPSET_ATTR_IP_TO] is not present but tb[IPSET_ATTR_CIDR] exists,
> > > the values of ip and ip_to are slightly swapped. Therefore, the range check
> > > for ip should be done later, but this part is missing and it seems that the
> > > vulnerability occurs.
> > > 
> > > So we should add missing range checks and remove unnecessary range checks.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
> > > Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
> > > Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> > 
> > @Pablo, @Jozsef: despite the subj prefix, I guess this should go via
> > your tree. Please LMK if you prefer otherwise.
> 
> Patch LGTM. I am waiting for Jozsef to acknowledge this fix.

Sorry for the delay at acking the patch. Please apply it to the stable 
branches too because those are affected as well.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
