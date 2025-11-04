Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D2127B4EE
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 11:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762255094; cv=none; b=Ub7eexcU9jYgZDuY9aY+A7m18OfBfYxJ1rvuM2DmL4HkUFbJcO3SWeUG3EoAK+BtqOZHUwhQ0vyJYMEi/7Qnb0TYGtZjWUVa27ZQs+pbFGXW3S76ApWLD4fc7rxxyTcTrqePeFev7KHlFWYWVBQtmVN2WMxlO2V+4uKhXCT/xGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762255094; c=relaxed/simple;
	bh=07T2MIelmCvJuwddAMT5IJYtbPNXwpgQ1BzvwFOjp9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgO3zJFOSRic60HcWu21+ZXMRyjjCiNs+01ptMP/zT8LzRx6F3dGIOnJzY4NrMkXU6vSlXCHNrtYrpeciMQoyDMlh3Gru7IYBwUSd10TT6UQ6o7QmYtzLaPpJTU05MYWPLV1mkYdzM/QcaOhAMyuFTn4wDU9ei32jOkNBhQylhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qmsFPmTv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qmsFPmTv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7HdQzewN31lFnGAMvtgePsaiADGEH9lJCNT4vrAeylU=; b=qmsFPmTvkDiGqFGP1Mtw2Yvl+p
	uF36mIKgFfktvUqP8iqKRbFFGP6UVZfnxThqDd/5T3ZBNK09tupemaIko0X1YXpX9oJ7TWGsPUbAu
	2PlwUCYOJaLILEMhkccgJrTSmeCTVc7QdxgkjSnZ/VF6g0aaGHVJSLPJlrCtQljrBeJpURupvjA/j
	SdT9mNhlFxQGjdbdSe8pamepfF8e/5n28UzTNRt4ipi993C5iEs4Jbc9n2vjS2Ikc3uv3PwMojcRl
	5AZebuqbl0qJT21uTSpgVgzXUaODDcAgoOpVEkWMKeHRUv/fVyHNLdHDtGHY39QT5m0hRUja5yM3g
	iFSG1VXA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vGF32-000000003FI-0o5C;
	Tue, 04 Nov 2025 12:18:00 +0100
Date: Tue, 4 Nov 2025 12:18:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_json: support handle for rule positioning
 in JSON add rule
Message-ID: <aQng6Holl8xN04dd@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-2-knecht.alexandre@gmail.com>
 <aQNBcGLaZTV8iRB1@strlen.de>
 <aQNNY-Flo9jFcay3@strlen.de>
 <CAHAB8WyByEKOKGropjHYFvz=yprJ4B=nS6kV6xyVLm0PWMWbYQ@mail.gmail.com>
 <aQdRjC4HJmjMStrI@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQdRjC4HJmjMStrI@strlen.de>

Hi,

On Sun, Nov 02, 2025 at 01:41:48PM +0100, Florian Westphal wrote:
> Alexandre Knecht <knecht.alexandre@gmail.com> wrote:
>  Export/import scenario (handles are metadata):
> >   {"add": {"rule": {"family": "inet", "table": "test", "chain": "c",
> >                     "handle": 4, "expr": [...]}}}
> >   → Handle 4 is ignored, rule appended
> > 
> > Explicit positioning:
> >   {"add": {"rule": {"family": "inet", "table": "test", "chain": "c",
> >                     "position": 2, "expr": [...]}}}
> >   → Rule added after handle 2
> > 
> > What do you think about this approach? I can implement it if you agree it's
> > the right direction.
> 
> I think its a sensible strategy, yes.
> 
> Reactivating the handle is a no-go as it will break existing cases.

Though libnftables-json.5 has this description of rule's "handle"
property:

"The rule’s handle. In delete/replace commands, it serves as an
identifier of the rule to delete/replace. In add/insert commands, it
serves as an identifier of an existing rule to append/prepend the rule
to."

So one might declare lack of handle support in "add" commands a bug and
the use-cases depending on it as broken.

We must not stop ignoring handles in implicit add commands as that
breaks 'nft -j list ruleset | nft -j -f -' but we can distinguish
those.

> Could you also add a test case that validates the various relative
> positioning outcomes?
> 
> i.e. given:
> 
> rule handle 1
> rule handle 2
> rule handle 3
> 
> - check that positinging at 1 results in
> rule 1
> rule N
> rule 2
> rule 3
> 
> - check that positining at rule 1 results in
> 
> rule 1
> rule N2
> rule N
> rule 2
> rule 3
> 
> - check that positinging at rule 1 will fail
> in case that rule was already deleted.
> 
> - check that positinging at rule 2 will insert
> after handle 2 and not N2.

I'd suggest extending testcases/rule_management/0001addinsertposition_0
in tests/shell to cover the missing parts above and create a copy for
JSON syntax.

> My only question is how "Position" is treated with insert (instead of
> add).
> 
> It should NOT be ignored, it should either be rejected outright (and
> everywhere its not expected) or it should have different meaning, ie.
> prepend (insert occurs before the given handle).

With insert command, handle property is recognized and behaves identical
to standard syntax. In general, I think JSON syntax parser should
deviate as little as necessary from standard syntax one. Same name but
different function will likely confuse users. Although not documented
anymore, standard syntax still accepts "position" and treats it as
synonym to "handle".

So maybe just do this (untested):

--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4045,7 +4045,8 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
                return NULL;
        }
 
-       if ((op == CMD_INSERT || op == CMD_ADD) && h.handle.id) {
+       if (h.handle.id &&
+           (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE)) {
                h.position.id = h.handle.id;
                h.handle.id = 0;
        }
@@ -4328,9 +4329,9 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
                enum cmd_ops op;
                struct cmd *(*cb)(struct json_ctx *ctx, json_t *, enum cmd_ops);
        } parse_cb_table[] = {
-               { "add", CMD_ADD, json_parse_cmd_add },
+               { "add", CMD_ADD, json_parse_cmd_replace },
                { "replace", CMD_REPLACE, json_parse_cmd_replace },
-               { "create", CMD_CREATE, json_parse_cmd_add },
+               { "create", CMD_CREATE, json_parse_cmd_replace },
                { "insert", CMD_INSERT, json_parse_cmd_replace },
                { "delete", CMD_DELETE, json_parse_cmd_add },
                { "list", CMD_LIST, json_parse_cmd_list },

Cheers, Phil
