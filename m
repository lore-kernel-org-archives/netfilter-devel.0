Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649EE3A5E97
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 11:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777893551; cv=pass; b=sErp5aABr3jTUK5uS0Jy7UAZQQU4KU+NYR2IkPG6+CROR+yDkd20T6WX5r4k0SqnfjuGkWPWJ5RFO0eU9Xg1nY25GOlveafSCoHvGZJT2t+SWaSSXVb4H4MiPHuxU31vUmVl2FAPNJEQDK8iIA8nSBHgziOdzL2Cl4RbIJeBEuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777893551; c=relaxed/simple;
	bh=ZzvoZyDaV+9GQ9a6TuOYJKQ0Evbo9uBsNcTG1aZxwVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sKFrgaf+gGdIXzFyuptQ3Hy972Irid3AgUPk4yArcUdi6RMQSrgV1zYMNTmWlZmimQb7irDrnDfmd0HZo/gZ0eFrCcZGat9+E593XfdLtZPfS5dqYNQIOQoWwFUfwlQKjNDNgPYMypfrvOoW75Ot5VXKgJXHm9YkB9peMQvk//U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L2eGRh8z; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2eGRh8z"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-65c3ea2ebf7so1410417d50.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 May 2026 04:19:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777893549; cv=none;
        d=google.com; s=arc-20240605;
        b=ZmykiHtUpSRD418k3B8GovrCiPB5YM14/ZtkYrDvd9mqoo3S7K+/7Bbd2eC1EE2Yrl
         aINuIRoNaOE/FfOjUzvIYiebKbyquB4ZF7Gfsi7znjT4bFYYD0j+bGABavE/aostO+r7
         ALAElWNrq2tefUIFARv0IUJ9PO+0Vo0WHL1nvQIqojpqjgaMJafMAvF3EyxVD/TLOCmB
         DVOTj/B7kMNVkWeLu4CoiRJRMSN56fNe7mRSPQRvqffpTd7OuNwV3yITvUY8JQ/I9e38
         /xd90qTE4uiUxMPiGmLBBpAEIKUhXjtxT6n+J+W6L+kL4SEk3v6QfByEczH2TpITLp7+
         kXlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GUktrT8GuU0q956SxbwjSrFItR1lGCQYJxE8ZlZEKXc=;
        fh=8OYpcO7Q9NsXKV6KdFaZPb14G6aRojtj8z9Y8LJtvik=;
        b=WU+e4aG8FRHsi9zP1LQ6R8VSiEJYg/i0IkeZ3voZpqoL+UEMtebPnKv76NZmO2oNwe
         fJq1JWQI2FCKNqT2Cfm6mvqHwxCQz8V/9uFwSwWmOaU+lWwJ1ZKEVRi7yf/WiIHzdYmn
         q5mR2qkcQi1zPDQbaN9Wf5d89N9sZitM1pkmFTnNl2opCAj+lcJtOrsUnweIBL4FUEb/
         no3h7efXbYE5cFj96gy+DWWoOJJZjNagVdq3FDKUUee5VDs6QNZZHxySBfJWmv2gp9eb
         E6CU0gJlRDYgXH/iPEFuK3t3u+HK3yvrJ33Y/P3vTnt96AuPunVGW4zjpaod7ra6ik0o
         tSww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777893549; x=1778498349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUktrT8GuU0q956SxbwjSrFItR1lGCQYJxE8ZlZEKXc=;
        b=L2eGRh8zHnK1Ed00MAOaMxx7Setfh4ohIzZspAHSkdMRHG7ougdq94LTquV5beH+e5
         YkSx2oEwDYi45SYxc0VkorpcHIYbp4UCOddj1CiHPP2a573cjoKtVc3aXIig701ZsoFW
         s2KnRxH9yv5aH1JSLLBOmDZHYkfH4CLBN43pcz13uxN/KIdtX7yFULS1ytCqW/eQTc34
         DftcYU0HFUm07+j3DY14XUZ1gmlp5yFhqkIE8UoSvo89AwF/HrRm0oYBI6Y+r3AlTZCB
         3dFeCnSAgWM4pg61FVNramO89OM2tMjhY+VdVxpaNgOOoGH/mpUp9mH2wsNaFwDMi/kq
         e9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777893549; x=1778498349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GUktrT8GuU0q956SxbwjSrFItR1lGCQYJxE8ZlZEKXc=;
        b=gzPBs2FOqR+H3vM8QRsY4OE+hndU2GWP1IgnmVO58AEEG5tO9q6iT3Y/i++uT+qMHR
         oEnHt5rnkX4ekvduJHYjlq5FUUUzecbG7U+hfTBhrr/MhQzQh1vpVP7an7+3DEMfwS78
         VTGfQCVefOxPmn+sUSN2abWw2BI45OuWnnSy8DcSWw8P5KMvJiT50q7po5TAbNF2mYsa
         w0BasJP6W3fG9gBGfUXhAyCUVWZNP2NNnQ9ofUdbElMqL+ig2+uPVpFrRwkrUYEFo164
         k316hJy+Mfr6deMpPQrD/lxaW//rHL1q/4KoXEmubaEOtUI7koRTNX0UsFvSlNBYR46W
         wF7Q==
X-Gm-Message-State: AOJu0YxBa0QJKSglcEx28Otm1tF9AIH3QXErP6n3DHpqiIr1uf5DNfNH
	3WJyo8S6Fim/uoLZWtzKctB27HItshaekCpJADic1HTtjJgkwhK+NDfuozMD4nnO72I0xzIKiGe
	ACgTA4IVsvJk3UOz2T4XwR7O5VD0js/dilqySrCY=
X-Gm-Gg: AeBDies6um3LBAZ/UjXJglJ9CNS6nW/gthCa4HZKQumloMTP0YYx1Mpr4m1rXLGnciM
	/n1jlWu2MqriRHnAD+7pBIG3HUdasCWCF+m2BLY40GNYbsL6vV3IlshBRtKb45pfVVA/La5NgkI
	ElfuI1qbNF4Mcgg596nVakg+TBz33VcMdKiEOePumtR0opaJFYuOy4o1l9T5rAqKbSfbwrD+oQe
	0+MhqxN3SFeGGItuVysF9dCVHASm8lDaowvkSRsrZQz4C8xz8y3jFrYnnHgDVnwxsm2dD8sdnl/
	EWy3jj4eCqSRJTBb5sM=
X-Received: by 2002:a05:690e:43d0:b0:652:f423:47e5 with SMTP id
 956f58d0204a3-65c3dafd73fmr7032604d50.42.1777893549046; Mon, 04 May 2026
 04:19:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324204016.2089193-1-anzaki@gmail.com>
In-Reply-To: <20260324204016.2089193-1-anzaki@gmail.com>
From: Ahmed Zaki <anzaki@gmail.com>
Date: Mon, 4 May 2026 05:18:32 -0600
X-Gm-Features: AVHnY4IY0lLYrd3lltgEmZEsaExiL_o12SlXBsrcMKQ_K6GyfdPRWP-pijiOczM
Message-ID: <CANczwAH0_RZqdi+XheKzwviwvDJeXm98pt7Ki0SkcfWVAWKsaw@mail.gmail.com>
Subject: Re: [PATCH nf-next v2 0/2] Update (DSA) netdev stats with offloaded flows
To: netfilter-devel@vger.kernel.org, andrew@lunn.ch, olteanv@gmail.com, 
	pablo@netfilter.org, fw@strlen.de, kuba@kernel.org, pabeni@redhat.com, 
	edumazet@google.com
Cc: coreteam@netfilter.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 2:41=E2=80=AFPM Ahmed Zaki <anzaki@gmail.com> wrote=
:
>
> Some devices (notably DSA) delegate the nft flowtable HW offloaded flows
> to a parent drivers. The delegating drivers cannot collect or report
> the offloaded flows stats since they have no access to the underlying
> hardware. This breaks SNMP-based network monitoring systems that rely on
> netdev stats to report the network traffic.
>
> Fix by moving the offloaded flow stat reporting to the nft flowtable
> subsystem. The first patch adds a new stats field "fstats" to net_device
> that is allocated and updated by the nft subsystem only if the new
> flag "flow_offload_via_parent" is set by the driver. It also report these
> stats back to the user in dev_get_stats().
>
> Patch 2 sets the new flag "flow_offload_via_parent" for the DSA driver.
> ---
> v2: - added the new "net_device->fstats" field since the existing
>       tstats cannot be used since it would double-count on devices that
>       already use tstats for hardware MIBs (P1).
>     - fixed the outdev ifindex logic based. See new func
>       "flow_offload_egress_ifidx()" in P1.
>

Hello,

This series has been marked as "Needs Review" on patchwork for about 6
weeks. Anything I can do to help?

Thanks.
