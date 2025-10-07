Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E2F1D90AD
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 20:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759869214; cv=none; b=o+cOi2JZl6Tx7vsZHaZvyKZdMgqswYIAwoPgOwjmi09Qk/wnz6KOiXqiPxgDoaH4L5258Zv1jorREI3h8lltdakTlEkxB/ZDDgrLf5Pow7l977+mHpf46zyzZYlRnDOk4xuxX0OeVzjxMM/+e5TcRIxmWLuyZDxI2/jf1d+xgGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759869214; c=relaxed/simple;
	bh=+fHcycjHX34awiHJL04dXXLq1HmtEKOpuJ9/i+dJ628=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJFH4KWtoJCcGh9EqQiM9kVSE6pdrVG+MC7j3OMPiWlzgFO2IHJdkPLPVlw7uA77tmhdOp/YAhRLeBc0PCHcZLf5x4rlx4joJOKUhGeou9ZYd0BKNlD6ZfAMfWBQcTmxaWDN76Fp330ShG94J22V79XfCMBifxxrnua4SYPmiRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Irs3ayxR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bZQgbisH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Irs3ayxR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bZQgbisH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 22DF960337; Tue,  7 Oct 2025 22:33:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759869207;
	bh=/w2oj4SADM27jW0A/O81tufbVeOEbleMpFdgYLOyNCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Irs3ayxR2YB+YnKHrTeaaQAWFHpWcvd6yXyKHmlef+SSbN2kC9bGMhzEMRaCQRgf8
	 oQNaO+iPX6ltW756rfbKMppMkToP4SzxUk7m/7rd2+XovNrTlRJkHMTZmDS8D1MHAS
	 Wf62R68CFioKDlU51dtGNlSkfOvKiOfaLltX+rHuhxbMOu4MVXbwpk0MaKTpUVphgx
	 CCUvvVNYwizyJNGuD4UfbxljBIZQINAOpb1y1/biu+hL12qai5Cc/ZwWOsZwAF8lJw
	 X757i5+FcSnG7yzVKv35dBme8R12lxap3yTTDGqgd1i3UrXXCJ7aEDMb4ckHYnr8aw
	 hviANWWBAkYqQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 186DE60333;
	Tue,  7 Oct 2025 22:33:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759869206;
	bh=/w2oj4SADM27jW0A/O81tufbVeOEbleMpFdgYLOyNCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bZQgbisH3LIYHcDKWxVDwpZxK2fQ6m1MsnuqlAx2+mLrqEPmZ5riB/C2Tbr5Tl8q/
	 uKNh6uur9LySeRpjtIULTAI70tnn2/PGyHk7dzdUoo+dqu53IUfHyQtqnR21vyflkA
	 oXSw6HZbL6kUSYLlEYMPJL4Z5b1VlT8e6Z/Mjbv0q3erqHccVd3VKS0478/nXmuniA
	 8jGT4K92Z58938UNhneaKPjlVzqBQ+t27cAZc6GENMOuUOzZizgcDLt6/FwWHBZbeZ
	 5ZXvDKHO57ynzNGhZtnf4NOXqolPPYJVT8/g5Nx1DLkOjd6yEswME8nvI3ufcJj5ZY
	 0wvbY0PySu1yQ==
Date: Tue, 7 Oct 2025 22:33:23 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
Message-ID: <aOV47lZj6Quc3P0o@calendula>
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251001211503.2120993-1-nickgarlis@gmail.com>

Hi Nikolaos,

On Wed, Oct 01, 2025 at 11:15:03PM +0200, Nikolaos Gkarlis wrote:
> Before ACKs were introduced for batch begin and batch end messages,
> userspace expected to receive the same number of ACKs as it sent,
> unless a fatal error occurred.

Regarding bf2ac490d28c, I don't understand why one needs an ack for
_BEGIN message. Maybe, an ack for END message might make sense when
BATCH_DONE is reached so you get a confirmation that the batch has
been fully processed, however...

> To preserve this deterministic behavior, send an ACK for batch end
> messages even when an error happens in the middle of the batch,
> similar to how ACKs are handled for command messages.

I suspect the author of bf2ac490d28c is making wrong assumptions on
the number of acknowledgements that are going to be received by
userspace.

Let's just forget about this bf2ac490d28c for a moment, a quick summary:

#1 If you don't set NLM_F_ACK in your netlink messages in the batch
   (this is what netfilter's userspace does): then errors result in
   acknowledgement. But ENOBUFS is still possible: this means your batch
   has resulted in too many acknowledment messages (errors) filling up
   the userspace netlink socket buffer.

#2 If you set NLM_F_ACK in your netlink messages in the batch:
   You get one acknowledgement for each message in the batch, with a
   sufficiently large batch, this may overrun the userspace socket
   buffer (ENOBUFS), then maybe the kernel was successful to fully
   process the transaction but some of those acks get lost.

That is, 1bf2ac490d28c allows you to set on NLM_F_ACK for BATCH_END,
but that acknowledgement can get lost in case of netlink socket
overrun.

ENOBUFS scenarios break assumptions on the number of messages that
you are going to receive from the kernel.

Netlink is a unreliable transport protocol, there are mechanisms to
make it "more reliable" but message loss (particularly in the
kernel -> userspace direction) is still possible.

In this particular case, where batching several netlink messages in
one single send(), userspace will not process the acknowledments
messages in the userspace socket buffer until the batch is complete.
