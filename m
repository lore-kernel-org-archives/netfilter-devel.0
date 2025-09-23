Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8F728032D;
	Tue, 23 Sep 2025 17:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649462; cv=none; b=exR4wv0BjrqcTmrUSqaZQ+odOEHsCjx95g9rVHLtgsZlCbbhFBHp19l7kKx9aZTkIEvJPDzdjnpHQckokv77YP9RaTcM0rn8MCIuI5GgjwS4/LLsIVS40OjODTZSZOVI3QJLvLvnbu3RMRYOVDaueEhmTQZ8XMnie1TSa1nq1UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649462; c=relaxed/simple;
	bh=uC4lZBDakL3o8bcCBH3lmQCJPnrDiPKs7JccPmLeiBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meJ7mpn157eEMcqcUkglV6OCS2vDT3Fq0sI4YXIJE1uVVIdYj5M2tQHC8NJOvm4wLpOt4D2WRQHpCzrFVm6Y8G8M8QD1fll8KWgcab3jc9X9YmFnlVcOoutucZPfCClDW4tYayZYzpDDqEWL0UW4kmS9kr4pOkNebcN0s5ZYA2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 495C661935; Tue, 23 Sep 2025 19:44:14 +0200 (CEST)
Date: Tue, 23 Sep 2025 19:44:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: Jan Engelhardt <ej@inai.de>, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, paul@paul-moore.com, eparis@redhat.com,
	pablo@netfilter.org, kadlec@netfilter.org
Subject: Re: [PATCH v1] audit: include source and destination ports to
 NETFILTER_PKT
Message-ID: <aNLcbUp5518F_GWL@strlen.de>
References: <20250922200942.1534414-1-rrobaina@redhat.com>
 <p4866orr-o8nn-6550-89o7-s3s12s27732q@vanv.qr>
 <CAABTaaDaOu631q+BVa+tzDJdH62+HXO-s0FT_to6VyvyLi-JCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAABTaaDaOu631q+BVa+tzDJdH62+HXO-s0FT_to6VyvyLi-JCQ@mail.gmail.com>

Ricardo Robaina <rrobaina@redhat.com> wrote:
> It seems DCCP has been retired by commit 2a63dd0edf38 (“net: Retire
> DCCP socket.”). I’ll work on a V2, adding cases for both UDP-Lite and
> SCTP.

Thanks.  This will also need a formal ack from audit maintainers.
