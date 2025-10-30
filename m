Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F90D329E7E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 20:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761857305; cv=none; b=bs2WYcdZPJTERkasfrc+5kzEIgZqAXzwa3fJp3JhEPCSsHRymnNAarpaCco4V127Vej4U6eCBzPacv0N04XiYw61PCnEtUNiyOo+Nct+T1kyZ7YXdijK+Dc3zbkODimFCOIIFues7Z71fpfeN4AyYetGFpzky3qfOe2XL5ygKe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761857305; c=relaxed/simple;
	bh=rIWlZBg/RWSmUJYCjVduMXXlXli2vX/TJcx7EQKLOhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bjE+47j1GgsxK7sYYwJarRtEft1TBFTqpVEJrD+8mG3y5L5NZ3kyQLNSYQPQOcDPpfPkbVppe+p7zlTce7KR8eyiz+FsxrBKQvOxBvoVThLWCpPskngWrcJV8t6VofxieQ8pztSx1pUgmAWvAt7NGg2rQie+K/sH9PbB2pZlO5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pnzs7tMZ; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pnzs7tMZ"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88025eb208bso7868746d6.2
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 13:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761857302; x=1762462102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAAUBtqV+6cAEC6eWnL8u1CFOXDYJHXorQLmtUtcHaw=;
        b=Pnzs7tMZeDC9/9/dK0WCWtF3XSBQ0kEWbPMy+dBNPId6TPl/MS2Ggt3/rfcqg4/LFL
         Nhsw4OLgxF3T24a1BFzlJCYlfQbQMpYxWJsEZeK15nHzR1WIq5STr2QvEecpWYqeGSqg
         dBxkG20RmlZCX8StGne/dmCWEYNSNP4NPKXi44z4ubDFJuGQEX92vGa05LsjRrQ0crmL
         O43FBW2SGLJNB7kSgGBJoTwF0vGvjY4s0jaSyVtcmK3giNZoR03I2H55rGrA11+sy0w0
         hqYU2RbbmkO0GS2MqwZue/TsCvL3JdnSn+1kkxZZytdE8gPkbknx/+xbUlT5+SMRozrg
         URfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761857302; x=1762462102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAAUBtqV+6cAEC6eWnL8u1CFOXDYJHXorQLmtUtcHaw=;
        b=Xdovz1NKJzl0CCxkYMzD5sqxPi83eTRVZgpUHKOjrakPhApTmAc5oZ4euduwJ8ux8B
         P6NJ6LOL/R5VdmL1WDW4XbV2OVW+4726Y/zcC78ySjSqs//km6E1UOk2gKoxG/pdWoqq
         k6CVs5NDyZMQGPQ47qUA4SIhGmUSg+lP1vtqbjgKs0w5JFm1o7/MXlZYrN74LcnKR3zk
         THtxY5c+tChmMPxfyt9t/Oe6qpg+mF4IbsScAelsgBSM+HJye5haZdyFrLE1q81LkyML
         KWl8g9dsUqUZH25GdfP6pqLZtTKLvL/YXyVv+TGo9IB+J+azLG0TDUu3kxgCgfjzNjfS
         rjew==
X-Gm-Message-State: AOJu0Yy+jMIk9xuwVPeXKv7VAaBiJ8KT/jGUhjsr1F9MuxpB3gO0v6Mv
	K9Cc12UD8UaT+7JornFOrWTDn1gULSS6BO5bB8E2MzmQrUQGmUQQa1lrakW1xiPf+V4zrf/qhPl
	JkDhepT6RUo87HJ9dlQbmKglzcXwungvOFlfd
X-Gm-Gg: ASbGncv4gpnN6Vi8Z0DIpRkctM7qCNykoCexVYJMB3RvEI7fvNZf47cuQTMXcMzbFoZ
	C2TOZUf05QGrs+D7XKDoZD+/xWqMLzQHgf5y7yE7vPOcoqbQZJyeBzcrNqYYPiKHY/A3AQatWTU
	rAyJFob8KiXdYgiB8Zg3Wq+uur4xUOAyu9jGYZ6Nt+hXHWLVvXzW94r0M3tIIYADEAeaBSSkuuO
	XQOlD+435IOJc/nVeZ3aHTSNgj+mjF/THwYKpnO1OA62lX8IIxH+wdVILY0VlYMcvsjthJEX1cT
	dAK2uK9QJFXeWw4ghcB5Xrf/djJ+eMs4OdsGF6gNIm6uhzh/8rh6CD6bWwOfQw==
X-Google-Smtp-Source: AGHT+IG6Uo85hN9xFdG10QwEDmdsDoFEWy4GnX67wkJbLio962nHFmcf5Gqo6Hi4v8VhbAr5YgpOePkhtht7prEHXso=
X-Received: by 2002:a05:6214:d04:b0:87c:113c:f1d2 with SMTP id
 6a1803df08f44-8802f47f6fcmr13784206d6.38.1761857301920; Thu, 30 Oct 2025
 13:48:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-1-knecht.alexandre@gmail.com> <20251029224530.1962783-2-knecht.alexandre@gmail.com>
 <aQNBcGLaZTV8iRB1@strlen.de> <aQNNY-Flo9jFcay3@strlen.de>
In-Reply-To: <aQNNY-Flo9jFcay3@strlen.de>
From: Alexandre Knecht <knecht.alexandre@gmail.com>
Date: Thu, 30 Oct 2025 21:48:08 +0100
X-Gm-Features: AWmQ_bku6t5lBeZSgZS268sm33zhb3zU1jMx42jcGgPQwRkcLrMkalZIYHD_7C4
Message-ID: <CAHAB8WyByEKOKGropjHYFvz=yprJ4B=nS6kV6xyVLm0PWMWbYQ@mail.gmail.com>
Subject: Re: [nft PATCH v2] parser_json: support handle for rule positioning
 in JSON add rule
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

Thanks for your feedback! I've investigated the test failure and found an
interesting design that I'd like to discuss.

The problem:

The test 0005secmark_objref_0 (and 0001set_statements_0) fail because they
include handles in rule JSON that don't exist yet. For example:

  {"rule": {"family": "inet", "table": "x", "chain": "y", "handle": 4, ...}=
}

My patch makes JSON "handle" behave like CLI handle - converting it to a
positioning reference. This causes "No such file or directory" errors becau=
se
handle 4 doesn't exist yet.

Current behavior vs. expected:

In CLI, this already fails as expected:

  $ nft add rule inet x y handle 4 tcp dport 80 accept
  Error: Could not process rule: No such file or directory

But in JSON (before my patch), handles were silently ignored for ADD operat=
ions.

The current JSON design :

As Phil Sutter noted in commit fb557b55 (2018): "For a programmatic API lik=
e
JSON, this should be fine" - JSON always exports handles regardless of -a f=
lag.

I couldn't agree more with JSON being a programmatic API.

I verified:

  $ nft -j list ruleset    # includes "handle": 2
  $ nft -a -j list ruleset # same output, includes "handle": 2

This creates a conflict:
1. Export/import: JSON exports include handles (for reference/metadata)
2. Positioning: JSON should support adding rules at specific positions
(like CLI)
3. Ambiguity: when "nft -j -f" receives "handle": X, he doesn't know
if it is for positioning
   or just metadata from an export?

Why we shouldn't solve this in code:

Doing a handle lookup before deciding whether to use it for positioning cou=
ld
cause race conditions when adding multiple rules or add slowness. The solut=
ion
must come from the input format itself to be unambiguous.

Proposed solution:

Reintroduce the "position" field in JSON for explicit positioning:
- "handle": ignored for ADD operations (treated as metadata from exports)
- "position": used for positioning (add after this handle)
- "index": already supported for absolute positioning

Why "position" makes sense for JSON:

While the "position" keyword was deprecated in CLI (commit effb881c, 2018) =
in
favor of "handle" for consistency, it still exists for backwards compatibil=
ity
and is even documented in the official wiki:
https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management

For JSON, "position" could serve a clearer purpose:
- Separates positioning intent from metadata
- Allows safe export/import (handles are preserved but ignored for position=
ing)
- Provides explicit semantics: "position": X means "add/insert
relative to handle X"

Example:

Export/import scenario (handles are metadata):
  {"add": {"rule": {"family": "inet", "table": "test", "chain": "c",
                    "handle": 4, "expr": [...]}}}
  =E2=86=92 Handle 4 is ignored, rule appended

Explicit positioning:
  {"add": {"rule": {"family": "inet", "table": "test", "chain": "c",
                    "position": 2, "expr": [...]}}}
  =E2=86=92 Rule added after handle 2

What do you think about this approach? I can implement it if you agree it's
the right direction.

Thanks for your time!

Alexandre
