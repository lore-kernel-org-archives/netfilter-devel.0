Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD0121D3E6;
	Mon, 22 Sep 2025 23:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758583294; cv=none; b=phEwVFSSQ5xxVXLo48YR8rzS1x/KrlyVk9H/MKpAfgJp+DVCSu2pe8EzVhdDnd2OKGikoNHujcQzd5MiS2n+GLz42o/YWx4WxftKj2X2tVLUKjFymANgq7XTS3+oF1y26rI/g1QyeSgCv4DUsHd6hitUN0LAr38/NUrNlFbf1yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758583294; c=relaxed/simple;
	bh=57/LDRcjjrdmIgOksL0xn8GZ+eRjE+2CG5SDSbYqSFk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ECtWDsywEAp5SXsSa51ol9EOqFhYtIoZv2h/OSFRrI7ty91UupCEzIacersdKzXtSVJceqBYHrX+NQBhEziEk98+z/geLkQkWZtBNVSrfa2Jt0S6ZCNJIGSVVHi7H6HB51+2q5O+69h/BXOIdMg+2URh19FvZN+9xKXz18YlZpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 887E11003C54A5; Tue, 23 Sep 2025 01:21:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 867441100A8ECB;
	Tue, 23 Sep 2025 01:21:20 +0200 (CEST)
Date: Tue, 23 Sep 2025 01:21:20 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Ricardo Robaina <rrobaina@redhat.com>
cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    paul@paul-moore.com, eparis@redhat.com, pablo@netfilter.org, 
    kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v1] audit: include source and destination ports to
 NETFILTER_PKT
In-Reply-To: <20250922200942.1534414-1-rrobaina@redhat.com>
Message-ID: <p4866orr-o8nn-6550-89o7-s3s12s27732q@vanv.qr>
References: <20250922200942.1534414-1-rrobaina@redhat.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Monday 2025-09-22 22:09, Ricardo Robaina wrote:

>NETFILTER_PKT records show both source and destination
>addresses, in addition to the associated networking protocol.
>However, it lacks the ports information, which is often
>valuable for troubleshooting.
>
>+	switch (ih->protocol) {
>+	case IPPROTO_TCP:
>+		sport = tcp_hdr(skb)->source;
>+		dport = tcp_hdr(skb)->dest;
>+		break;
>+	case IPPROTO_UDP:
>+		sport = udp_hdr(skb)->source;
>+		dport = udp_hdr(skb)->dest;
>+	}

Should be easy enough to add the cases for UDPLITE,
SCTP and DCCP, right?
