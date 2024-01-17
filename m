Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FDA22308
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2024 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507710; cv=none; b=o3f4AU7y2WtAnifPratm5bT24TGg4hIlau6Y0CP6cRcoS8csw5P8U4tofUnj9yHmrQI+rM9954r6it3C3T+tlyJS++qo/ZttWJnhIAw4vFI94nxFSXNfd4m3u1KYEyjl3F6BZRMoZExjNpKHN4Cw0xomZigMncq5XxVpCtvo39U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507710; c=relaxed/simple;
	bh=H6F34XKiq3lLfPvqxg6QnsQlOx+GScvSZqxl2/wrgLw=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=A4ezaj56teV+yCzcH7LS3rwSedaldoBZF/hG94v6h3SUwp1IYz7lZoPx5u8bU8vh5ysZiXg6jpn90OMsxDevH3Ob+p994vLlaGWPQRYSOYZ3ar9osNfyM9Whnj8zL+/+DWlgYIgjR0AU3byXFTgvg2vbK/OCLYsI/K/+jJgR7YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i0+yau41; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i0+yau41"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-55818b7053eso16409a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2024 08:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705507705; x=1706112505; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gVsnehQLkD3XfpuYGLfg/mVGzgx+4d4kVL88pDZKO8=;
        b=i0+yau41+mbU2kcA5muH70nQo4Lnr3KeL+qLwgKRhMxny1ucBVI+IYcD+iz6yUVtlA
         r53MkzKjXTH9oVxgfevwcq52x3/DUTdmv2ZvxePC3hPvvf7nhiHI6y+vj4VHVn35J7P5
         cNybkeoKB1DrLZEP4LhJogk3r59+BZP+oAXketEzaQ0QE1XRZnz78d00WBIkQo2AZleo
         DvZmJDKAYBiOoHncMb61xYm1UXKegDVhKrH8jLalHc/cxFnuvTETj4A90Xk8ustLsyVk
         IB+nWA75kunvsIiOLaWADe3Ej/yLFzGmwuYxmZ/8F78KH1ldLc701WwwAQbblm2yo9I3
         Ch5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705507705; x=1706112505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gVsnehQLkD3XfpuYGLfg/mVGzgx+4d4kVL88pDZKO8=;
        b=Im4wxSwByPYroM8k6SvdjHuxTwuXGjxqxM8w11ZBNN5Sd+Lc5+ApQqt3mQb/Qkb1gI
         I5wwqfnyH4JtbS+TdX2WrYJrMpyHQ3Ee2M4bt7TVM1sWBkAnzSwtkM7SJRHz5nYnR/vi
         +HzhaU53TDXiyUGp1lYFs9HV2erzKZA9s06kTYpmJZDTu6XoSgiUseDdDkAHj/qEMWDn
         bLtr2ASa2u9h2ZWWBsTtPVx9BvTJk7xWC4hJTOKFWcdpRbDEvZvehsLkXseVH+1mWjAH
         EDKUDo9FsyiEBBOo//30xS/eetNTxkfTTASK8jAbhe5/yFjUarAs1NhhK1A6zPiSCu6Y
         NqSg==
X-Gm-Message-State: AOJu0YwuPtzliGCO/vb9Q8toEWWCV4w8BU4vx4ZNzHKC53QPT++jNMyT
	em7ZCaPpJkhVWNaqXDKRDLzMx9Ecb4xixdjVkWx9RlwXCNur1mci+A+YIx9iPzfAlRky3VnGr9k
	kEgY4Zp+AJVHapP8wSk6OBTK6CHk1OV8C6LJc
X-Google-Smtp-Source: AGHT+IGefZFkdb+yUuXFJw40KsJN6J5lh2G3F74Tw88Y/QrsC2fSpvReuos/PQMsWgAB8l0jtdPITqSKn/v0k/hdP9o=
X-Received: by 2002:a05:6402:3551:b0:557:15d:b784 with SMTP id
 f17-20020a056402355100b00557015db784mr219578edd.2.1705507705227; Wed, 17 Jan
 2024 08:08:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240117160030.140264-1-pablo@netfilter.org> <20240117160030.140264-15-pablo@netfilter.org>
In-Reply-To: <20240117160030.140264-15-pablo@netfilter.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 Jan 2024 17:08:11 +0100
Message-ID: <CANn89i+jS11sC6cXXFA+_ZVr9Oy6Hn1e3_5P_d4kSR2fWtisBA@mail.gmail.com>
Subject: Re: [PATCH net 14/14] netfilter: ipset: fix performance regression in
 swap operation
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net, 
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 5:00=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> From: Jozsef Kadlecsik <kadlec@netfilter.org>
>
> The patch "netfilter: ipset: fix race condition between swap/destroy
> and kernel side add/del/test", commit 28628fa9 fixes a race condition.
> But the synchronize_rcu() added to the swap function unnecessarily slows
> it down: it can safely be moved to destroy and use call_rcu() instead.
> Thus we can get back the same performance and preventing the race conditi=
on
> at the same time.

...

>
> @@ -2357,6 +2369,9 @@ ip_set_net_exit(struct net *net)
>
>         inst->is_deleted =3D true; /* flag for ip_set_nfnl_put */
>
> +       /* Wait for call_rcu() in destroy */
> +       rcu_barrier();
> +
>         nfnl_lock(NFNL_SUBSYS_IPSET);
>         for (i =3D 0; i < inst->ip_set_max; i++) {
>                 set =3D ip_set(inst, i);
> --
> 2.30.2
>

If I am reading this right, time for netns dismantles will increase,
even for netns not using ipset

If there is no other option, please convert "struct pernet_operations
ip_set_net_ops".exit to an exit_batch() handler,
to at least have a factorized  rcu_barrier();
