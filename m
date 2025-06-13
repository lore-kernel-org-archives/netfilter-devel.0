Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7663C4C6E
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 12:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749818606; cv=none; b=AGmT5fvHdqLk31wfTmf4Z1yArj0LgtLr+YAZzejHxCspX8ILmwwTfxSp0VZZOYsS7WByhmGtwYl6JPiI2jDNwtD4WKO3lkAIRxjxeRhZBGTYkuV5ApTU3dpC4pEoOdSQsGkfh1IdM4IHFaS1bel1+jGLTh+1Wu71LanhfFH7qYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749818606; c=relaxed/simple;
	bh=WeobSiZShyKhGrA2RvKLL8DsBWrohV8WCAAEE0MYTXo=;
	h=Content-Type:Date:Message-Id:From:To:Cc:Subject:Mime-Version:
	 References:In-Reply-To; b=rxqOsuaz8neATMC3o107Nfs2FDeuz2hOlT7B+sPJHSjWeY0JI7Fi2b7LmK6bKVE+X7OOlmpQzdinRwp5C6u5VuQU80NlPgrYCdSDAzL8hT7jWAcwxMDQEzGjmcqzYFmZ5GWhbrUT1IEyFcDIfWKaLVSV1xryEQg6arwY+DtPU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 125164522E;
	Fri, 13 Jun 2025 14:43:21 +0200 (CEST)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Jun 2025 14:43:20 +0200
Message-Id: <DALEXBLBOPWN.2DL1A7GBBBVQ8@proxmox.com>
From: "Christoph Heiss" <c.heiss@proxmox.com>
To: "Florian Westphal" <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH conntrack-tools] conntrack: introduce --labelmap option
 to specify connlabel.conf path
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: aerc 0.20.1
References: <20250613102742.409820-1-c.heiss@proxmox.com>
 <aEwXADKlOKotEVRi@strlen.de>
In-Reply-To: <aEwXADKlOKotEVRi@strlen.de>

Thanks for the review!

On Fri Jun 13, 2025 at 2:18 PM CEST, Florian Westphal wrote:
> Christoph Heiss <c.heiss@proxmox.com> wrote:
>> Enables specifying a path to a connlabel.conf to load instead of the
>> default one at /etc/xtables/connlabel.conf.
>>
>> nfct_labelmap_new() already allows supplying a custom path to load
>> labels from, so it just needs to be passed in there.
>
> Makes sense, patch looks good to me.
>
>>  3 files changed, 46 insertions(+), 25 deletions(-)
>> [..]
>> diff --git a/src/conntrack.c b/src/conntrack.c
>> index 2d4e864..9850825 100644
>> --- a/src/conntrack.c
>> +++ b/src/conntrack.c
>> @@ -249,6 +249,9 @@ enum ct_options {
>>
>>  	CT_OPT_REPL_ZONE_BIT	=3D 28,
>>  	CT_OPT_REPL_ZONE	=3D (1 << CT_OPT_REPL_ZONE_BIT),
>> +
>> +	CT_OPT_LABELMAP_BIT	=3D 29,
>> +	CT_OPT_LABELMAP		=3D (1 << CT_OPT_LABELMAP_BIT),
>
> Why is this needed?

Honestly, the option parsing is quite convoluted.

But it's used for indexing into `optflags`, which in turned is used by
generic_opt_check().

As `--labelmap` can only be used with `--label{-add,-del}` and thus
`-L`, `-E`, `-U` and `-D`, this is appropriately reflected in
`commands_v_options`.

Based on that, generic_opt_check() will then throw an error/abort if
`--labelmap` is used with any other command, e.g.:

  conntrack v1.4.8 (conntrack-tools): Illegal option `--labelmap' with this=
 command
  Try `conntrack -h' or 'conntrack --help' for more information.

At least what I got after tracing quite a bit through the code.

>> [..]
>> @@ -3212,6 +3220,10 @@ static void do_parse(struct ct_cmd *ct_cmd, int a=
rgc, char *argv[])
>>  			socketbuffersize =3D atol(optarg);
>>  			options |=3D CT_OPT_BUFFERSIZE;
>>  			break;
>> +		case 'M':
>> +			labelmap_path =3D strdup(optarg);
>
> Should this exit() if labelmap_path !=3D NULL?

Don't have a strong preference on this, but probably makes sense to
abort in case the user ever specifies the option multiple times. I'll
add that.

>
>> +	if (labelmap_path)
>> +		free(labelmap_path);
>
> free(NULL) is ok, so no need for the conditional.

Ack.

>
> Patch looks fine, but I think it would be good to have a preparation
> patch that moves all labelmap_init() calls from do_parse() to into
> do_command_ct().
>
> Then the option ordering would not matter anymore.

Can do that. Will just entail a bit more refactoring around the
--label{-add,-del} option parsing, as that relies on an already
initialized labelmap.


