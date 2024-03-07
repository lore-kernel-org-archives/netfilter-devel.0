Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5887A12EBF6
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709828662; cv=none; b=YZJHj3FdO/XUTtXuQbGMe2K4rnbBq9ol/cG46O3zfMbuvnTQYMyBI9JLMV3iAPcda17BtQMh9GLC2CL/euW1xvjg58tXYJOiPpWzlZyrTGg0i4mLP4hDM5keUK052WqH2CqFTJB/14YGp9ETGxpplTWYHS+OKQxawHqoZYFRj+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709828662; c=relaxed/simple;
	bh=v+v2KsExTzcbxjgeHCW9cTsfnqpGhd8OK/XNi5pqLJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmblmmmooBiIWN/IRp6n/JSnzjA2Y8iLKkEWIH1lTSwU2DTcf8wUUmsM15UROWu6j8noaMtGrY9itnp/D6wxEzzmcrXuQVbbRfi4gjHoc+8oX5Xh5YoBHQMZFkPC8ANfCS5tOdJck3udlFoyvCpAZugFHxEx1MdGoEZKs0SHJFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=47140 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1riGXU-00HCEr-R9; Thu, 07 Mar 2024 17:24:14 +0100
Date: Thu, 7 Mar 2024 17:24:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Daniel Mack <daniel@zonque.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Issues with netdev egress hooks
Message-ID: <ZenqK_1HBMutR10u@calendula>
References: <ba22c8bd-4fff-40e5-81c3-50538b8c70b5@zonque.org>
 <ZeizUwnSTfN3pkB-@calendula>
 <07000633-1191-445d-b894-8a1d8b0c9044@zonque.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <07000633-1191-445d-b894-8a1d8b0c9044@zonque.org>
X-Spam-Score: -1.9 (-)

Hi Daniel,

On Thu, Mar 07, 2024 at 02:34:38PM +0100, Daniel Mack wrote:
> On 3/6/24 19:17, Pablo Neira Ayuso wrote:
[...]
> > I guess you are running a kernel with
> > 
> > commit 0ae8e4cca78781401b17721bfb72718fdf7b4912
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Thu Dec 14 11:50:12 2023 +0100
> > 
> >     netfilter: nf_tables: set transport offset from mac header for netdev/egress
> > 
> > so this is a different bug?
> 
> Interesting, I did in fact run a 6.4 production kernel when I tried
> this, and that didn't have that patch applied. Sorry for that oversight.
> 
> On 6.7, what I see is different but still broken:

I'm here with 6.8.0-rc6+:

> This rules does the right thing and patches the source MAC correctly:
> 
> table netdev dummy {
>   chain egress {
>     type filter hook egress device dummy priority 0;
>     ether saddr set 1:2:3:4:5:6 dup to eth0
>   }
> }
> 
> Whereas trying to patch the IP source addr leads to no packets being
> forwarded at all anymore:

My setup:

# ip link set up dev dummy
# ip a a 10.141.10.1/24 dev dummy
# ip ro del local 10.141.10.1 dev dummy table local proto kernel scope host src 10.141.10.1

testing with ping to 10.141.10.1

I need to remove the local route, otherwise packets go through
loopback interface.

> table netdev dummy {
>   chain egress {
>     type filter hook egress device dummy priority 0;
>     ip saddr set 1.1.1.1 dup to eth0
>   }
> }

1) tcpdump in dummy:

17:14:42.939483 f2:20:1a:4c:c4:a1 > f2:20:1a:4c:c4:a1, ethertype IPv4 (0x0800), length 98: 1.1.1.1 > 10.141.10.1: ICMP echo request, id 46403, seq 1, length 64

2) tcpdump in eth0:

17:15:21.006853 f2:20:1a:4c:c4:a1 > f2:20:1a:4c:c4:a1, ethertype IPv4 (0x0800), length 98: 1.1.1.1 > 10.141.10.1: ICMP echo request, id 1087, seq 1, length 64

> Interestingly, ether type filtering is also broken now, the following
> also doesn't match any packets:
> 
> table netdev dummy {
>   chain egress {
>     type filter hook egress device dummy priority 0;
>     ether type ip dup to eth0
>   }
> }

1) tcpdump in dummy

17:18:13.921128 f2:20:1a:4c:c4:a1 > f2:20:1a:4c:c4:a1, ethertype IPv4 (0x0800), length 98: 10.141.10.1 > 10.141.10.1: ICMP echo request, id 137, seq 1, length 64

2) tcpdump in eth0:

17:19:00.398882 f2:20:1a:4c:c4:a1 > f2:20:1a:4c:c4:a1, ethertype IPv4 (0x0800), length 98: 10.141.10.1 > 10.141.10.1: ICMP echo request, id 21186, seq 1, length 64

> I browsed through the patches since 6.7 and couldn't find anything that
> is related. Did I miss anything?

I tried again this first example you posted:

table netdev dummy {
  chain egress {
    type filter hook egress device "dummy" priority 0;
    ether type ip ether saddr set 01:02:03:04:05:06 ip saddr set 1.1.1.1 dup to "eth0"
  }
}

tcpdump dummy:

17:22:08.390312 01:02:03:04:05:06 > f2:20:1a:4c:c4:a1, ethertype IPv4 (0x0800), length 98: 1.1.1.1 > 10.141.10.1: ICMP echo request, id 47168, seq 1, length 64

tcpdump enps25:

17:20:28.298524 01:02:03:04:05:06 > f2:20:1a:4c:c4:a1, ethertype IPv4 (0x0800), length 98: 1.1.1.1 > 10.141.10.1: ICMP echo request, id 15435, seq 1, length 64

Maybe my setup is different?
