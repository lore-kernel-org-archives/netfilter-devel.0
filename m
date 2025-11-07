Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ED827C842
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Nov 2025 14:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762525181; cv=none; b=jEOM/xs18HwfmTKvEF6ILi5/X02Qs4b6M4/6p9qjPKxLTzARWyUUQNImldgRBFrnUrsL9A+NE6WsrXV2qMxnztdXG6SNnrc2LhdZBcO9LQWQV8f91pvbVv+pgh3U6npARXppbcbooXzyJxUrooITBYS5NigL6oteuW6O6HYHLNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762525181; c=relaxed/simple;
	bh=ZFH5vEyfzoKrIPeZzLK1Ie34cw2X582gChbLrJtCYE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=u1mxVxYiPJovJvMrduJVNlxLZxKZLPKiaQ+TxhaBQ3ojaITV4h4c8xRxe0G6m1TV76ENuhpg4krtKahgtFn0Q5ZeBd0chLG6b8SX3vitqxI2t62btxSyVT8e8SVlr8AT40+uZ6Dt0LT0hsRdxrw/arD+gmBwf9g/jLUF8yVgXE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ETKxC+S7; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETKxC+S7"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8801e4da400so8451396d6.3
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Nov 2025 06:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762525179; x=1763129979; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFH5vEyfzoKrIPeZzLK1Ie34cw2X582gChbLrJtCYE8=;
        b=ETKxC+S7JUJV2JCfP5kQ74Et2WcSGTNwF4HT6HQNoYfDp42a17SX/krEtT6k2wMIgS
         wv74MV5+zwfuvBqRT32QlJ9gf2DPx9F2kKwPDr+Lp8VDbbkLXhS3z8BWZdYyDayp322M
         ZI/ISPmP38GGN5tOdUw7rn7AnC8jn7tsEjPLohCT7APW+d7OOUlkBST+I1+uKkZ1CcDJ
         bW42nAJO1V/kwMMFY7tG7sWUQq4uP7j8q34oFe7hrnlscUlvoCZnjsO45DzhC+e27Oq/
         c4n/YEEObCEqXTnrVcgv29u33zOg45UYuk40zdS7NDjEZMQdHF3o3+F+4AQTrYHDdJq2
         mpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762525179; x=1763129979;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZFH5vEyfzoKrIPeZzLK1Ie34cw2X582gChbLrJtCYE8=;
        b=qOrrKI3LTH+7aikgpISlVliXv0yuV87PUWpiHjq1m3vfRa6IkJRIE+YDhqHa7PoDhm
         9hLwfHnGo04HpdmxehHfPQzahzNluUKxiKX8b6DibQRgPg4vsUTv7wLpPEyo8tsoAvW8
         1xu5QTurySL0xiXYwNn1DEgV62M7zmvpkIqYJlM2cPf4PlZIlfzol7UTfhpcR2jvcrSt
         C9/kRfDtLzBMomGk6KLcGYke0bbaMOqWO6rOft/KMLKe981KGwhXQlPW1e29gqvwh8H9
         r04VO8xb6oTY/IppkgYw1RxhYkLB3zEhfoppEWZ/pGANT8SDFb8c5hBvEWjxLG6KzeTH
         XeOw==
X-Forwarded-Encrypted: i=1; AJvYcCXQ2LGt7yiY4wBqCkcb450Q+nMHud1yxenGbntxUUN/mEXNQlM16sfhqbQez4mOcd7QCtiJjHzzzq0z1j4pyrg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8hH8o1Yw+A1Bd20Nzoxr4cDU2lZwRIYAcSci1uqtm7VVszcyi
	zK2g8DncQvL36uOtsKLJeRQ7F0rBHPma5Id/mXKTrv0bZEvwovkirHYUl+KZzBaOIpGRRepVmhy
	A2Rck980YzlhKLilbSUnmJShwtq+mTIc=
X-Gm-Gg: ASbGncv1FTIv9yOQQq+0aC70ah3riMQ99rcsAfiuNyMFFOXIvpY2rF5/XrDyQCalPXO
	hhPu/rc5O3xxvGfVBp18O6fhm1k4Rg3FGBYdH/+gRi6H/LPGB0JvU33laPLHYh/g2y8h//quICp
	eulPZUORS2L9SYGJ5Fzs6Vylnto+wLuL2NXlNSLcXwwflDjyHdt455/WO+pW3mwcsZPUQzbGTso
	onQ1CuLwrArTN3RxgYUqWDecACdJdmSZ/W2CdwMNfiDA3Arx3P/ztBel4K/+CavTdpSoGfFOL8B
	JjI/q6HRnMWrr9kWDRW1ZKSEVfOE/NUXXTPV8cays4nNs6p/
X-Google-Smtp-Source: AGHT+IEfwRxF3VZHIdQTEko1nhPPkWgWdIVuksjHW3essmyUcAfcjc6RZ1UP2Lqz9es3seHX4nkmRvAAE4TqPvDxrUw=
X-Received: by 2002:ad4:5ced:0:b0:880:460a:96ce with SMTP id
 6a1803df08f44-881834e75eemr42405086d6.63.1762525178561; Fri, 07 Nov 2025
 06:19:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106083551.137310-1-knecht.alexandre@gmail.com> <aQxwwwlTFj12H8TN@orbyte.nwl.cc>
In-Reply-To: <aQxwwwlTFj12H8TN@orbyte.nwl.cc>
From: Alexandre Knecht <knecht.alexandre@gmail.com>
Date: Fri, 7 Nov 2025 15:19:27 +0100
X-Gm-Features: AWmQ_bm-tvMQVd2JD9kT68fESccq-eI6KOHeKP6tgeGSHGba6LjGFVVkVo9Z390
Message-ID: <CAHAB8WyP-eD-v+zkO5xuNYRwkQyNTwwYhZ2j7+WMDj+-SJ19Eg@mail.gmail.com>
Subject: Re: [PATCH nf v3] parser_json: support handle for rule positioning in
 JSON add rule
To: Phil Sutter <phil@nwl.cc>, Alexandre Knecht <knecht.alexandre@gmail.com>, 
	netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Phil,

Before submitting v4 for JSON handle positioning, I wanted to share
the design approach and get your feedback on whether it looks sound.

After your feedback on v3, I realized routing commands through
json_parse_cmd_replace doesn't work for non-rule objects. I've taken a
different approach that I believe addresses all the requirements
cleanly.

# Design Overview

The core challenge is distinguishing between two formats that both
call json_parse_cmd_add:

- Explicit format: {"add": {"rule": ...}} - handle should control positioni=
ng
- Implicit format: {"rule": ...} (export/import) - handle must be
ignored for portability

Solution: Use a context flag (CTX_F_IMPLICIT) to mark implicit format.

## Implementation Details

1. New Context Flag

#define CTX_F_IMPLICIT (1 << 10) /* implicit add (export/import format) */

Why bit 10?
- Next sequential bit after CTX_F_COLLAPSED (bit 9)
- Follows existing flag numbering convention

Why a flag instead of a function parameter?
- Follows existing pattern (json_parse_flagged_expr at lines 1747-1754)
- Keeps function signatures unchanged (less invasive)
- Properly scoped and restored (no state leakage)
- Localized to parser_json.c (doesn't leak outside JSON parsing)

2. Set Flag in Implicit Fallback

At line 4373, where we handle implicit format:

/* to accept 'list ruleset' output 1:1, try add command */
{
uint32_t old_flags =3D ctx->flags;
struct cmd *cmd;

ctx->flags |=3D CTX_F_IMPLICIT;
cmd =3D json_parse_cmd_add(ctx, root, CMD_ADD);
ctx->flags =3D old_flags; // Restore after parsing

return cmd;
}

Design choice: Save and restore pattern ensures the flag doesn't leak
to subsequent commands.

3. Check Flag in Rule Handler

In json_parse_cmd_add_rule at line 3211:

/* For explicit add/insert/create commands, handle is used for positioning.
* Convert handle to position for proper rule placement.
* Skip this for implicit adds (export/import format).
*/
if (!(ctx->flags & CTX_F_IMPLICIT) &&
!json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
if (op =3D=3D CMD_INSERT || op =3D=3D CMD_ADD || op =3D=3D CMD_CREATE) {
h.position.id =3D h.handle.id;
h.handle.id =3D 0;
}
}

Why this location?
- Only affects rule objects (tables, chains, sets unaffected)
- Preserves existing command routing (no changes to dispatch table)
- Single check covers ADD, INSERT, and CREATE

4. Expression Flag Mask (Discovered Issue)

During testing, I discovered that setting CTX_F_IMPLICIT broke
expression parsing with errors like:
Error: Expression type payload not allowed in context ()

Root cause: Expression validation at line 1732:
if ((cb_tbl[i].flags & ctx->flags) !=3D ctx->flags) {
json_error(ctx, "Expression type %s not allowed in context (%s).");
return NULL;
}

This check assumes ALL bits in ctx->flags are expression context
flags. When CTX_F_IMPLICIT (a command-level flag) is set, the
validation fails because expression callbacks don't include this flag
in their allowed flags.

Solution: Introduce a mask to separate flag types:

/* Mask for flags that affect expression parsing context */
#define CTX_F_EXPR_MASK (CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY |
CTX_F_DTYPE | \
CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | \
CTX_F_CONCAT)

Then filter before validation:
expr_flags =3D ctx->flags & CTX_F_EXPR_MASK; // Only expression flags
if ((cb_tbl[i].flags & expr_flags) !=3D expr_flags) {

Why this is necessary:
- Expression context flags (bits 0-8): control which expressions are
allowed where
- Command-level flags (bits 9-10): control command processing, not
expression validity
- The mask documents this separation clearly

Note: This is actually a latent issue that would also affect
CTX_F_COLLAPSED if it ever remained set during expression parsing.
Currently it doesn't because it's only set when returning early (line
3460).

## Performance Considerations

Flag check overhead:
- Single bitwise AND operation: ctx->flags & CTX_F_IMPLICIT
- Same cost as existing checks (CTX_F_RHS, CTX_F_STMT, etc.)
- No measurable performance impact

Memory:
- No additional allocations
- Single uint32_t flag bit

## Testing

Created two comprehensive tests:

Test 0007 (159 lines): All object types with all operations
- Covers: table, chain, rule, set, counter, quota
- Operations: add, insert, delete, replace, create
- Purpose: Ensure non-rule objects work correctly (addresses your v3 concer=
n)

Test 0008 (83 lines): Handle positioning semantics
- ADD with handle =E2=86=92 positions AFTER (verifies rule order)
- INSERT with handle =E2=86=92 positions BEFORE (verifies rule order)
- Implicit format ignores handles (no error on non-existent handle)

Edge cases tested:
- Multiple rules at same handle position
- Mixed explicit/implicit in same JSON
- Complex expressions (payload, meta, ct) in implicit format
- Export/import round-trips
- Non-existent handles in implicit format (correctly ignored)

## Alternative Designs Considered

Option 1: Separate flag fields
struct json_ctx {
uint32_t expr_flags; // Expression context
uint32_t command_flags; // Command processing
...
};
- Pros: Cleaner separation, no mask needed
- Cons: ~50 line refactoring, changes struct layout
- Decision: Too large for this feature, could be follow-up

Option 2: Pass boolean parameter
json_parse_cmd_add_rule(..., bool implicit)
- Pros: Very explicit
- Cons: Changes function signatures, needs threading through multiple layer=
s
- Decision: More invasive than flag approach

Option 3: Use different CMD_OPS value
enum cmd_ops {
...
CMD_ADD_IMPLICIT,
};
- Pros: Type-safe distinction
- Cons: Mixing semantic (ADD) with format (implicit), affects all
switch statements
- Decision: Implicit vs explicit is a parsing concern, not a command operat=
ion

Questions for Review

1. Flag approach: Does using CTX_F_IMPLICIT seem reasonable, or would
you prefer one of the alternatives?
2. Expression mask: Is CTX_F_EXPR_MASK acceptable as a fix, or should
I refactor to separate expr_flags and command_flags entirely?
3. Test coverage: Are tests 0007 and 0008 sufficient, or should I add
more edge cases?

Ready to submit if design is approved !

I have the complete patch ready to send if this approach looks good to you.

Thanks for your time reviewing this!

Best regards,Alexandre
