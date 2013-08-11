From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] test: compare content parsing with
 original file content.
Date: Sun, 11 Aug 2013 09:47:13 +0200
Message-ID: <20130811074713.GA3864@localhost>
References: <20130810194039.18629.89549.stgit@Ph0enix>
 <20130810194051.18629.33864.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47029 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab3HKHrZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Aug 2013 03:47:25 -0400
Content-Disposition: inline
In-Reply-To: <20130810194051.18629.33864.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 10, 2013 at 09:40:51PM +0200, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Before, we have tested only if we have parsed some file but we
> hadn't tested if the content is OK.  Now, we can test if we can
> parse some file and if the object's info is the same than the
> content in the test files.

Applied this minor glitches, see below.

> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index e111fd0..f9cfcdf 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
[...]
> +	printf("matching %s: ", filename);

renamed this to "validating" instead of matching.

> +	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));

removed strerr there. If validation fails, ie. strcmp(original,
output) are not equal, errno does not contain any relevant
information.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
