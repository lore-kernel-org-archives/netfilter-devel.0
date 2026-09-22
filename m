Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B717355C1B5
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090876; cv=none; b=bTF07g8wU1VMngN6ny6AU1lQ8p59AoyG9pnMRaQGlq16/jqU1E4cdPPvh8PagmB1w6RYz0v2AuqZD9OhqXGs8VUasFOGWxXHBsvO3BPsVFJajmAvmE88g9DgSWIeIvOStBOnYjAPbfnQVdu5/T4Y1/NwVmD0JPePSSZLW4T/jX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090876; c=relaxed/simple;
	bh=H6M2+2ePKHnNXtCxv8bZ8wAVt5XsjCTjUh+IXXp4Ros=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iv5fWscUAB4tpOTskeGd3BVG1cdsJcKBNG74yk+bwyA6eaU7O9ghLqaB4GCLM5jCsuKD5tMHMvk1kK3lsO1sq1T8V4bpQoAms8oVmlQYzxOZwwHqKB7MJThcUkirw4eKGcRy+vppCn8/BSI8St+c2gGAJszDrCtHsb1ODJikXL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ATgf/bPb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cbJN0B15; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ATgf/bPb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbJN0B15"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790090872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SEowbgJIDHpYJATL6KIUYHLNQoCqqGPHET4KCWOduog=;
	b=ATgf/bPbh+Got/voT6dPUvMTbAewUpVz7j7mSm296/aUcN9bMbyqsnFd7wUtG78+qAJzcD
	WDGoffs4kbl8l4iTYxX7XgsCjs7+LNwHNP2EOd0kJT/OmuS5Me0pZ1XCPdow+l8gSmtFOG
	OER6jBBe1Rmx8EwO2ZGWOlvxNY+dQts=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-MjM5meiPMD-5YOwIqEb80g-1; Tue, 22 Sep 2026 11:27:49 -0400
X-MC-Unique: MjM5meiPMD-5YOwIqEb80g-1
X-Mimecast-MFC-AGG-ID: MjM5meiPMD-5YOwIqEb80g_1790090867
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f4bff865cso39819f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790090867; x=1790695667; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SEowbgJIDHpYJATL6KIUYHLNQoCqqGPHET4KCWOduog=;
        b=cbJN0B151Ta+VBlvHJEdHry0GaMsQGfYgyiPxEsuqVqLVrWVxOpewoausweIOWbH/3
         Ha4fr8Rtu/iSmvJ+XPobzo2KQrZ5fKqqQiLXgolbT0uUnnb39TMKUZJDuhr7wo4z+xPl
         HFjpX5123qWRXpCx8ky/ZrdBqM4++vy7l4ejzSlZzF+u5iOlo3xjgTGIkF7kdoAeLsrP
         DA5AwMKcHoD8pN+XB8lGEY+mZeSajYvYr18yucGeDOBMNaWDZW82qohRyfPeFHsvkohb
         mPw8wQgKTUq0uhmbXdXuBUifnzp5IXGsHmTzeZth+HHDRAIDiDBu/TKm5NnF7gVS7qAu
         s99Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090867; x=1790695667;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SEowbgJIDHpYJATL6KIUYHLNQoCqqGPHET4KCWOduog=;
        b=mFF32Yugs2n0SED0gN2bgThZsILGcDRnCz9vKifSqCMVa/l4vAHcmRn7akb2pFgbxF
         Z1+/Ic2rkDpn2vH4xDCFiJSkl864O5NOxgQPZNpccY3vCaEfBIewx91FZcygspvq4Jgt
         KGE9Fbvnj8f0LjiPvvOxYTO0MRCQZkrSh9Otj6syoxqczr2DK2CIgoFBIpjC2RVMiXPP
         dSxnLM5OnFfXUuPMfUnhBB7cVSqPNLBtpbosbvD0ku+pEbsSgWUFviuzf3L5UjqDR4U0
         tQYb7NNpQBI0KzIvlA7+puS7PhmemwWRTmdElwONSDwyW1Ef///3/yAEPIPxfhHX8yfk
         k0wg==
X-Forwarded-Encrypted: i=1; AKwUvBxn4UYrW+Kfbm42yss/YQ5HrjN8KrQXcmK/yZdA3OtPTCZuwjo9oxY/wlJP0QWScd4r7z60QJUpdnczdrKXR4A=@vger.kernel.org
X-Gm-Message-State: AFuF++l528gu/Z4BH02FIe/Il2b+Iz+OrbuSk3aLL5GSL05Fowv/aTID
	Juq5drM1oyJbHq5RKm9VWvf+/PhVOTOKoxL/i7lusuw1PfFiqic6B0+odOxgQ32TFEJME7Kpts+
	+zlgGgbRZuNnY7zAYYG2tDvzqUSeDx8YwC2fHXpa0bFY8WEPmO8r+nsvkTCFBG7ZqdT10maZ8TW
	ybdUnn
X-Gm-Gg: AYBFou3lk2mv/yrdbJFWBmmY4NRYWxxJ86R7669u17uh80Gngk/TAKEEoJ3PxHO6yJ9
	cSUoUm2bfEMDgShHR5zIxR1xWWSyKsbkGwaxY12FVgLtNjnjFsinxeXmo8ZS72nD1VaIM6D5kTV
	Ae+nzEvA/jWlQalAYKtdLFTniOt5AoC2rLyNb99bhJYrGOH0zA7a9CdhnItMa7T2aFMzoOPk+0u
	4D0azVp05QZnjpefV4TqvROpQ6m6fDjo65LevVbDnqLwP5iwZ7tUCfhtTJRTWtqWcMwAtruoQYX
	tLOY0Z7uJD8m9wM6J0DwIHvOLEkh/joMAyi4KXRs9+KRnOFyf7DN/67D5/MURWmKkl85Wndd3aI
	rL9fDqYH9TFLzbA==
X-Received: by 2002:a05:600c:34c7:b0:49c:ff8d:b548 with SMTP id 5b1f17b1804b1-49fc5726cfcmr277166945e9.11.1790090867448;
        Tue, 22 Sep 2026 08:27:47 -0700 (PDT)
X-Received: by 2002:a05:600c:34c7:b0:49c:ff8d:b548 with SMTP id 5b1f17b1804b1-49fc5726cfcmr277166705e9.11.1790090867129;
        Tue, 22 Sep 2026 08:27:47 -0700 (PDT)
Received: from aconole-thinkpadt14gen4.rmtusnh.csb ([216.212.25.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdab0e46fsm13166415e9.3.2026.09.22.08.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:27:46 -0700 (PDT)
From: Aaron Conole <aconole@redhat.com>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org,  Pablo Neira Ayuso <pablo@netfilter.org>,
  Florian Westphal <fw@strlen.de>,  Phil Sutter <phil@nwl.cc>,  "David S.
 Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub
 Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  Simon
 Horman <horms@kernel.org>,  Eelco Chaudron <echaudro@redhat.com>,  Jamal
 Hadi Salim <jhs@mojatatu.com>,  Jiri Pirko <jiri@resnulli.us>,  Xin Long
 <lucien.xin@gmail.com>,  Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>,  netfilter-devel@vger.kernel.org,
  coreteam@netfilter.org,  linux-kernel@vger.kernel.org,
  dev@openvswitch.org,  stable@vger.kernel.org
Subject: Re: [PATCH net 5/6] net/sched: act_ct: remove 'add_helper' dead code
In-Reply-To: <20260921145655.3167436-6-i.maximets@ovn.org> (Ilya Maximets's
	message of "Mon, 21 Sep 2026 16:55:47 +0200")
References: <20260921145655.3167436-1-i.maximets@ovn.org>
	<20260921145655.3167436-6-i.maximets@ovn.org>
Date: Tue, 22 Sep 2026 11:27:43 -0400
Message-ID: <f7t8q4tb91s.fsf@aconole-thinkpadt14gen4.rmtusnh.csb>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ilya Maximets <i.maximets@ovn.org> writes:

> This variable can only become 'true' when the connection is not
> confirmed, but it is only checked when it is confirmed.  So, it can be
> treated as being always false and just removed.
>
> Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

