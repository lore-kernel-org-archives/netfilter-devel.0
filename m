Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793962400;
	b=hZ+1Sr/JcrxuLwnWJ7qQ1RO8PbfBy1hDdoNPndTaSilhgJZWDMU0CoCAa9CSBpeg21V3
	 585BL5gidzaUSvjcp9sbxAmSN13sfUT3Ilt4bkEJfJeN/jkeqezik0ynm0hoXFb/kjZs4
	 2sJMHsH8jl9ivHVU2eDWWBO8z5rU2dSi52zrKKkEkhg39o9dehOnyjn5gQAIOZlfh2q/z
	 tbTzXeu+563uIezQHkILaAgWbMt2FB1MPmY2W3kwi3voOrdrgmNRO+kfh7TrudDZwmx4/
	 SIAAyUY01yGIXFSB21NHh9B+WwhEeQ/Dq1zAZRamD+CIxwJLBwBhhjExUpGMHu3eQGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962400;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=UqUmaRUubcVECI46J0khfr0jkBr2Tg4PfDuvk07wVm0=;
	b=enK2OIwHp/JD1WoCPiJpHOmw3n/okED2Ifzbcw3zuU0qUy+lX+IUhsnxhjbgqzovQbWB
	 OKhBnMMg0zZzI7KbsAfrR+98u0EKvdU/8h7FEuxQ7wWrAE6rapY/A1+uVRhEKmslVINWd
	 gTAK+WBkE1PNobdnCCklOA/1n/KW4ZKwHLGjPBwzvlxoSlDq+daaj8aDGFmVhpc7GbwzN
	 jmZx3XT1ssKWAuVgplNUofFL6HYpD6K8WTy/QqAm8jXXP/Pw3yHQWKMucGbW7K5He4DJt
	 ibIJ3Itt6/Z68rO/l8mQx4G2712Ukc2acg5XHGemhjefdl8Xcht+a9iaAM2qGY3WN5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XPNze0Q5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AB9606A326
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 10:53:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55AB9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XPNze0Q5
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1a3c08d6928so889629c88.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2026 02:53:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793962399; cv=none;
        d=google.com; s=arc-20260327;
        b=LkQxUVduO/MpA7CMXf10+PqCQTpBV7af0LXk8IxpGGpGvfzkD8kalANSfqki9gjtm1
         PySVIVZr5UdOsREI/qMqwRX3V23caRDsWJkDZf29bYqzYDKq1domHQ7+3p2Fjxp1C4c7
         ZRtXCmzno6A3+e8Vek8IHsX2/RopFQqfrwGJFn3LPjcTnXjF0C1mXsKxjwxrfmM0nww4
         a4pzQ5fmVmJIQt/3OV8kiAxEGoJ4GmgaFbo1cydGQnKsdCqK9ng0dr1v3fzuiH5jJOYh
         qWW+vsAJFP2ZYM937epCczpeX79wuzxn6aG+/8YcT8HwkM3cLDBqGj575l958BPXXOMV
         X2WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=UqUmaRUubcVECI46J0khfr0jkBr2Tg4PfDuvk07wVm0=;
        fh=rKPHD65xw4fm8Eah2U6YCeRi9s/ZGxNrLF3JfAYUdVg=;
        b=QhsJ/H25MV/cWO5W6YDSMP+B4W8ncI2Qv/1XcjkS/9cTqVlQvJebyD4cdfUj7UQPOg
         E2yR6/zbU3rkpSxJXd6wvyJkV+/oAsDPZZnNvg9FHX1LGFRyVS46UAhMoOKqMhBcI44f
         uGIBScXeCx/jJc66VRc8EjfNJI3+TLrQN5n10EPfpfnIDjNxlpwWE2TuonX0iKw28pAk
         rAhBQuVZ87EgP9iMaAmb7UTt4jhpKnNFBAD4y+e1LaNSQ+jqaHcKApvW5D+78h2GQijX
         2342DCXG82jjc/DEjiEcqS57KSrffNMgUCnCv0tPVMT3ulMsp3QmVY3cC7evNErxu7v8
         HDZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793962399; x=1794567199; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UqUmaRUubcVECI46J0khfr0jkBr2Tg4PfDuvk07wVm0=;
        b=XPNze0Q5tHQMNC6a0vff/dKH/Hf/5TjQI2x294CpMhkULlvUw2HPID9y0/fvGPqSOq
         qS8wRa1lYHZGq4o/Xn0+qye80Ol2tnkUtaKNyEVA7GJJ0X9ozqL4nNhdf0XOyY/pZVRU
         wk43BW4d9dO/vW0Wa297mdlH2+4JJhOvfE92HMqynGJf41pQYTErnrW7VXm/eH/aYxmh
         xajMJGXObl0VRKI3n5wUIyM+9llzu16Rwf/UJc+ZhwC2Et01rf+BSusyibxdQSdGgaNt
         RgDyc8u9PaqOX5dfX25YwNKcE796sqJPZmLa4Adey27iNMIybb8wN3bRYpkk7i028jZ5
         ORBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793962399; x=1794567199;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UqUmaRUubcVECI46J0khfr0jkBr2Tg4PfDuvk07wVm0=;
        b=S5pisGIJkUCMeJb5AhI8TNAFfAkhmsTtr0k9gr3iNioN2W1jNbSmMzYoLRPuM+qtwM
         VZA9iQFQIeDYLimJCnneQJe1xAcdbFm3nMCaIaRH9L31P4Avb0exUfrdGjavCt5peSQl
         WCirIYCPm4+TtugQqHQDufGagd7W03z2HoESJ94LNB2mWeWPJJdLnWxlFeNU4ZMBcwbp
         wEQVyKFMFW3Y6cSMbVMAtp/pgFhCIw+VHYcmVvWr0kbuiimvE6MyHpi5JnnmFj6swCPT
         IHQMQdNXxK0AIdkHdbDYKILlh3NzCOb1ZlqEDMaIEQxlexf/ii7ndctUM5E8oh1f9ekN
         +7ww==
X-Gm-Message-State: APuU4Z/PbkXPXnIaZJEDCUSMsYnQbQVnYS1xZswuV37FpnVhfbF0CJ0E
	EuM8Shms8ZyCxh7tmUgkB/4z43qI2ckPuhH0WlgP4kFYI8vZD4as6xx6qWQsi9hVS8cQWysjR+Z
	z9+Gp3VO7oAhf5GWC81Nb1vuwdHlrgImfZA2Kpg==
X-Gm-Gg: AYBFou01hq6e+Kv7pv1GGJwVGyFqU5v3ga6VyPNCjI1yJANyz7/rjCupHnVVIoNQnf9
	3Al8TUKYchI/KIqBp2nxZTY+bruE2K4QfloVMich1nzXAg8AcDralx1+WSusbnERmi62krJhHXI
	YQKQU/3H5fVqrmp7cVy7FNcKJOlgYX7xYPY484p3chptYKhpEJPhXGaOpFPjXpgiT11jPSpKgFi
	cXrGWOUYxKRr/z5vRXFvBIeLScRWz1dTbBUKE2cj4jMyPn7hlnbGc2k9gh2J0cS4iB/xHnvTXRZ
	yXqEFGJubUNS0BDCBkTzB4Vbs24/We6gPAr8sI33szfmeCtlDryLOX51O4dV+/v/Plaifj3bzro
	HqEEO1sCdLo3T4Y+1OOtXj5v235jOfvd6L2ElV6Z4IssyXhjntdHTlq9/XXXcB/bTgO12shH4v4
	nVxtwvjqJtjAqWIknH0Y0SX5+BkqS9X1AQXAQsG3Q4h0V2WEmyK3nw+zpSIEcgU22Xq7sQCjAM6
	B5S7UDUfbMMJfhwxK04jcsRlg1WsZxG0rIYXofrq29ah6rK/ZZPHo4lmnQDB5FB9++PJA==
X-Received: by 2002:a05:7022:b90c:b0:15e:3a65:5b97 with SMTP id
 a92af1059eb24-1b25d31e64bmr2372976c88.16.1793962399330; Fri, 06 Nov 2026
 02:53:19 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: "S.S.Vikash" <arisivikash@gmail.com>
Date: Fri, 6 Nov 2026 16:23:08 +0530
X-Gm-Features: AclHuK-WvG0zgl-MIla378cXPI_8PY8LTq3RMd-8qahwJVquNDWlBTd9QFc23WA
Message-ID: <CAPGrzGkjouOeqOcy4pXbBgx58DWvZpqK8ppuChPsDsXKvxp4RA@mail.gmail.com>
Subject: [RFC] netfilter: conntrack: early_drop eviction limitation under
 sparse table configurations (max << buckets)
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Hi,

While investigating connection tracking exhaustion behavior under a spoofed
SYN flood, I observed that the effectiveness of early eviction in
net/netfilter/nf_conntrack_core.c:early_drop() degrades significantly when
nf_conntrack_max is configured to be substantially smaller than
nf_conntrack_buckets.

Setup & Reproduction:
- Host kernel: Linux 6.14 (Proxmox host)
- Workload: Conntrack table saturated with non-ASSURED, unreplied TCP
  connections generated by spoofed SYN traffic.
- Test: Verifying whether an inbound, legitimate SSH connection can be
  established while the table is at capacity.

Results observed:

nf_conntrack_max       |   nf_conntrack_buckets     |     New SSH Connection
------------------------------+-----------------------------------+----------------------------------
              4096              |              262144
|         Failed (drops)
              4096              |              4096
  |         Established
              65536            |              262144
|         Established
              262144          |              262144                  |
        Established

Root Cause Analysis:
In early_drop(), the kernel examines at most NF_CT_EVICTION_RANGE (8)
consecutive hash buckets starting from the calculated hash index.

With nf_conntrack_max=4096 and nf_conntrack_buckets=262144, the hash table
is sparsely populated. Since early_drop() examines only eight consecutive
buckets, it can fail to locate an eligible entry even when many non-ASSURED
connections remain in the table. This appears consistent with the connection
failures observed during testing.

When the bucket count is reduced or when the table density is increased,
early eviction succeeds reliably and permits legitimate inbound connections.

Proposed Improvements:
I am interested in addressing this behavior upstream and would appreciate
feedback on which direction would be most useful:

1. Diagnostic:
   Warn (e.g., via pr_warn_once()) when nf_conntrack_max is configured to be
   significantly lower than nf_conntrack_buckets via sysctl, notifying the
   operator that early_drop() heuristics may become ineffective under load.

2. Documentation:
   Update Documentation/networking/nf_conntrack-sysctl.rst to document the
   tuning implications of sparse hash tables on early eviction.

3. Algorithmic:
   Investigate a bounded improvement to candidate selection in sparse tables
   without introducing unacceptable CPU overhead on the drop path.

I'm happy to prepare a patch or provide additional test measurements based
on the discussion.

Thanks,
Vikash SS
