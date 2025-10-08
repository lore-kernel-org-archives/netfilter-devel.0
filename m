Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D41A19D082
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 11:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759921762; cv=none; b=LUtUr9R7EUMAnDGSoSQAfEZeDQqyFx3vcpL4NGbjforXGvZEpW1n652t5x9gT0IqfNOpgFs5N5kadqX/NlcX0ffDw3L7gfqQxIUOfbERhLXS84jCsSqfl6Jqx6Eph6sAGnq4gKfsTuRJ0Bp15qB+vQVOT1BNhjnzUqnPKLtPZ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759921762; c=relaxed/simple;
	bh=lvYJaeIuxMAPG7h0s/Fwg/EWbRpquvji8fs0PYaFqR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dM9v/BGwVuWbI59+sHM8xPCOFL+goe9yYAJeuqP6fRajKKVxRqmBtaYQp7GmBW6Wfvt3r3jShY+V+XHFVL7ShQv4KYTGdH6yhaONrFVlSaVzucoKfomr2V/zPeOHjlVNM/FrG5pQR842w3W82YmU2So0+3aBlKKh0+cYpv1vczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jNavNaPg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qG+qApIk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jNavNaPg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qG+qApIk"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A1E89602AF; Wed,  8 Oct 2025 13:09:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759921749;
	bh=xsi8efyUcv2RCuBiDqmzr/1gdQAqfgaGkBfJg7pR8ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jNavNaPgngjTsOzwG3qLVbLDho4D2fV1tB3/yeIZxUH0QNPxQ/IH3NLkUEYjXK9UW
	 DEwXPw28R5FobxrxkKo7jWX48FB0tb2MYGCGaylflCMx/WTkJDjYD+vkaeIx3bYjps
	 a35vNLyMBEDFVtfXA71WErz27JaUQeNdjylVPAQifk18GpZ73RCQ3SfdsyTB+X1hWb
	 npAfpauNKRmN8vmHiI3f8xrd6ripifuOK1ASgPfjX3Jnbd4dync719Vd5G7CHLm1D9
	 bObPNuOhUTibh/JVksGPOCaj29sCviubgCgDPTg33j2b2hbVDLyOcR1S3TlKxdw5UV
	 AHiT9D2Z83RiA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 45987602AB;
	Wed,  8 Oct 2025 13:09:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759921747;
	bh=xsi8efyUcv2RCuBiDqmzr/1gdQAqfgaGkBfJg7pR8ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qG+qApIkNdIfFywmY/hcJgdWqonak00WBOypiDXdBnGj7Z07Atk+ZuR0a95EL5NOa
	 f5R9SQgR10Q28Uo8cq/7GmQw0JVQI7j0S4T7mHAgH5NcIjSa1MP6RclmKyj/6qC4Te
	 QRwgN+6szIH2RIcBnhMPHPQ4iurfd5p43roa6IZMcn+kYzy4TPzwcOFQX2S8TeSTVh
	 DE09nfDit4KvBByS8DGgt55E9hKWnp7ZQsMnhiZTLfIU1JkomGKpQc+Vp7Yh8JAIdP
	 WWczIUKsH1E5fh0J+13O+9hKO40IlzO6ouwJAi/ViKOhG9lnLr1S/ogeefaiJznEtO
	 68px5qWjuidTg==
Date: Wed, 8 Oct 2025 13:09:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
Message-ID: <aOZGUPMwr5aHm66x@calendula>
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
 <aOV47lZj6Quc3P0o@calendula>
 <CA+jwDR=hSYD76Z_3tdJTn6ZKkU+U9ZKESh3YUXDNHkvcDbJHsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+jwDR=hSYD76Z_3tdJTn6ZKkU+U9ZKESh3YUXDNHkvcDbJHsw@mail.gmail.com>

Hi,

On Wed, Oct 08, 2025 at 10:41:05AM +0200, Nikolaos Gkarlis wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Regarding bf2ac490d28c, I don't understand why one needs an ack for
> > _BEGIN message. Maybe, an ack for END message might make sense when
> > BATCH_DONE is reached so you get a confirmation that the batch has
> > been fully processed, however...
> 
> _BEGIN might be excessive, but as you said, I do think _END could be
> useful in the way you describe.
> 
> My assumption is that the author of 1bf2ac490d28c aims to standardize
> the behavior while also allowing some flexibility in what flags are
> sent. If someone tried to use those flags in a creative way that
> deviates from what nft userspace expects, they might run into
> difficulties handling the responses correctly.

I think the author of 1bf2ac490d28c is using it for a testing tool
that sends very small batches (only few commands at a time). In that
case, considering the default socket buffer size, the acknowledment is
going to fit into the userspace netlink socket buffer.

> > I suspect the author of bf2ac490d28c is making wrong assumptions on
> > the number of acknowledgements that are going to be received by
> > userspace.
> 
> That could very well be the case. As you said, you’re not always
> guaranteed to receive the same number of ACKs.
> 
> I’m aware of the ENOBUFS error. Personally, I see it as a “fatal” or
> “delivery” error, which should tell userspace that no more messages
> are coming.

In netlink, ENOBUFS is not "fatal", it means messages got lost, but
there are still messages in the netlink socket buffer to be processed,
ie. the netlink messages before the overrun are still in place, but
the messages that could not fit in into the socket buffer has been
dropped.

nfnetlink handles a batch in two stages:

1) Process every netlink message in the batch, if either netlink
   message triggers an error or NLM_F_ACK is set on, then enqueue
   an error to the list.

2) If batch was successfully processed, iterate over the list of
   errors and create the netlink acknowledgement messages that is
   stores in the userspace netlink socket buffer.

Since this is a batch of netlink messages, acknowledgement either
triggered by explicit NLM_F_ACK or by errors may overrun the netlink
socket buffer.

> Similar to EPERM which I have a test case for.

EPERM is indeed fatal.

> It might not be the best approach, since one could argue such errors
> might also occur for individual batch commands. Still, now that I
> think about it, not receiving a _BEGIN message could indicate that
> the error is indeed fatal.

I think I see your point.

Acknowledgement for _BEGIN will be likely in the netlink socket
buffer, because it is the first message to be acknowledged, but _END
is the last one to be processed, so it could get lost if many
acknowledgements before have been queued to the userspace netlink
socket buffer (leading to overrun).

It seems with 1bf2ac490d28c, an acknowledgement with _BEGIN can be an
indication of successfully handling a batch in the way you describe.

> Receiving an error about an invalid command isn’t necessarily a
> delivery failure (unlike ENOBUFS), and I’d still expect to get the
> entire message back, including the ACK. Otherwise, how would userspace
> know that it has read all messages and drained the buffer?

For this nfnetlink batching, use select() to poll for pending messages
to process, and make no assumptions on how many messages you receive.

> You could argue that userspace should bail on the first error it
> receives, but if I’m not mistaken, the kernel will still send an error
> for any subsequent invalid command, meaning the buffer isn’t being
> drained again.

If you open, send then batch, process response, then close. Lazy
approach that consist of bailing out on the first error is OK. The
close call on the socket implicitly cleans up the ignored pending
error messages in the socket buffer.

But if you keep the socket open for several batches, with the approach
you describe, then unprocessed netlink error messages will pile up on
the socket buffer. If you do not do any sort of sequence tracking,
then you application process old pending errors as new, libmnl handles
this with EILSEQ.

All these netlink subtle details are not easy to follow :).

> > Netlink is a unreliable transport protocol, there are mechanisms to
> > make it "more reliable" but message loss (particularly in the
> > kernel -> userspace direction) is still possible.
> 
> Is it unreliable mainly because of those corner cases, or are there
> other factors to consider as well?

As for netlink batching, which is supported in other classic netlink
subsystems, this acknowledgement overrun issue exists, I am referring
to the scenario where you add several netlink messages to the buffer
and send() them to the kernel.

As for nfnetlink, it is a bit special in that it has begin and end
messages because this is needed for the transaction semantics (to
implement a dryrun to test if incremental ruleset update is OK).

1bf2ac490d28c added the handling for NLM_F_ACK which I left it
unspecified at the time.

Netlink can be also used for event delivery to userspace, ENOBUFS can
also happen in that case, but that is a different scenario.

TBH, I am trying to remember the details, I don't talk about Netlink
very often.
