Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4811BE25A
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727769417; cv=none; b=Ar4aykYu2qAJwP60LVKEdNiAubh2iKLt1rkIlyrl9+1qdqOBCQIS3wKIlTa/HrgB8FpZJ6K/9CPaAUttfx6vXG1rbbE5RzvHhKXxz5jnMXRB6XtFbKAokNvKkzjsm5o1xfOf5UdwVSFEHHj2oZRpAE3xcWx/oBKC3u0QRjvW9dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727769417; c=relaxed/simple;
	bh=D1JTQfrWYlxg+oug+vUqLOQZmsnSJiIy/5H/1jFqavI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dnTfCBbitTRe87HkbsUUdl2onhB+cAHVp/d0Eg07TSp+3OHHv69s7GxSCObkvRn5jwyW/UlwysEq0neqkBGOD4AXj3ma5so2Uo1lBNutGzsIjFgAY9yY7F65yu24EWkf42kU3FFCZgv1RZ0D3fy1oqxMehYNBtkT/nIaOBS5Rjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hk1A4nyY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hk1A4nyY"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e249fafe1ebso9107157276.2
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Oct 2024 00:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727769415; x=1728374215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YLIpnISBu8vBhPoCOC0VxpYUv2HSm5uj0+OgXD1P1w=;
        b=hk1A4nyYtoELYYoGP6gVEgMLdRSQmfN9EAFU0RnlmJjvUbPzmpD9P2+9UltciGpJcc
         HMxNsRNTG4/FBmrOubycwqKyTp6OcqAQr79vDiLhE73Syu5tk8jRZaZDm473Iu/T7mZ6
         ftt80xX6OlhBY62T+AonMiAAH5GSZpBwUHTNSZT6JKOZUKI/rFlaYfDtkpH799H8ZczI
         i7LH0fJt36kErwFDBKxGsXs9JDtM+qF8UxxoKieU0YAke/xZ0gjyrz7KzQRX14yRXiE9
         HOwyYq7te5nLbEWk0geEfp6HcHgqAmaTDZ2CyYNstE2g53jpApxF5ewOlUWfZEB9vi7O
         SFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727769415; x=1728374215;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2YLIpnISBu8vBhPoCOC0VxpYUv2HSm5uj0+OgXD1P1w=;
        b=U0Z9VQzZBwuWgIZJOO3Kn+e8qFcRB1e/nI9RM4fZEXaNd5QTsVk9NauZjo1nKBwhgl
         UMtih2HNehFQx0CZUr7yXVmUv5Tg1lgTn+QKSQYWEbnN8m/iMT06mMO7AJ3LLo5O1fDH
         KM7QRUvRnyfgHaCinJDF3TqRkvM/ONPmImLIC+lgNYoPp1NC4tjG3RuXHcIHTqHR+ez7
         9uTsU9r7A8WT5HEN6DbDb12MYJ+81etoqCckV0HgLXviWrEWMFUUhfifVhwlhy9+iARC
         9tYqrAsyH+5Ua8dYXAEpUTExTLCea461q0A0fv31DaTH4ZEpsT5mqxjqpI81k/hIS7k7
         pchg==
X-Forwarded-Encrypted: i=1; AJvYcCW10lgppEwITVPjLxvdbZ9ClNibtZ9iQvvTGV/R8fuXbLGIIYVkoa3w0HKR6izk01FPU3pj7C6/QhqhSxor8/c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz49z22e6v7PJ418CoE7UOUu4OhPs2hvAaVj5huK7n3ZYDL8vEO
	2tHkhjQKNsfUo1hBxguPMgoexMkddQODMt5ak6keFO54PyNetRl2gACTyrVu0U9cKbwdArLI8bs
	EFg==
X-Google-Smtp-Source: AGHT+IGrHwUo0pc+SGt+eG2rbtdwipm7/Eg7KBwJTogtJiz6n0iyNnSjCk9Mp4ukj5ZYb1jp3Gh60YAy+2Q=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a25:9e09:0:b0:e24:96b1:696 with SMTP id
 3f1490d57ef6-e2604b0f4f6mr12271276.1.1727769414837; Tue, 01 Oct 2024 00:56:54
 -0700 (PDT)
Date: Tue, 1 Oct 2024 09:56:52 +0200
In-Reply-To: <20240904104824.1844082-19-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-19-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZvurRJ4mGsRufmEl@google.com>
Subject: Re: [RFC PATCH v3 18/19] samples/landlock: Support socket protocol restrictions
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2024 at 06:48:23PM +0800, Mikhail Ivanov wrote:
> Add socket protocol control support in sandboxer demo. It's possible
> to allow a sandboxer to create sockets with specified family and type
> values. This is controlled with the new LL_SOCKET_CREATE environment
> variable. Single token in this variable looks like this:
> 'FAMILY.TYPE', where FAMILY and TYPE are integers corresponding to the
> number of address family and socket type.
>=20
> Add parse_socket_protocol() method to parse socket family and type
> strings into integers.
>=20
> Change LANDLOCK_ABI_LAST to 6.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> Changes since v2:
> * Changes representation of socket protocol in LL_SOCKET_CREATE into
>   pair of integer values.
> * Changes commit message.
> * Minor fixes.
>=20
> Changes since v1:
> * Refactors get_socket_protocol(). Rename it to parse_socket_protocol().
> * Changes LANDLOCK_ABI_LAST to 6 since ioctl patchlist updated it to 5.
> * Refactors commit message.
> * Formats with clang-format.
> * Minor changes.
> ---
>  samples/landlock/sandboxer.c | 108 ++++++++++++++++++++++++++++++-----
>  1 file changed, 95 insertions(+), 13 deletions(-)
>=20
> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
> index d4dba9e4ce89..1669095f9373 100644
> --- a/samples/landlock/sandboxer.c
> +++ b/samples/landlock/sandboxer.c
> @@ -14,6 +14,7 @@
>  #include <fcntl.h>
>  #include <linux/landlock.h>
>  #include <linux/prctl.h>
> +#include <linux/socket.h>
>  #include <stddef.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> @@ -55,8 +56,11 @@ static inline int landlock_restrict_self(const int rul=
eset_fd,
>  #define ENV_FS_RW_NAME "LL_FS_RW"
>  #define ENV_TCP_BIND_NAME "LL_TCP_BIND"
>  #define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
> +#define ENV_SOCKET_CREATE_NAME "LL_SOCKET_CREATE"
>  #define ENV_DELIMITER ":"
> =20
> +#define ENV_TOKEN_INTERNAL_DELIMITER "."
> +
>  static int parse_path(char *env_path, const char ***const path_list)
>  {
>  	int i, num_paths =3D 0;
> @@ -209,6 +213,65 @@ static int populate_ruleset_net(const char *const en=
v_var, const int ruleset_fd,
>  	return ret;
>  }
> =20
> +static int populate_ruleset_socket(const char *const env_var,
> +				   const int ruleset_fd,
> +				   const __u64 allowed_access)
> +{
> +	int ret =3D 1;
> +	char *env_protocol_name, *strprotocol, *strfamily, *strtype;
> +	unsigned long long family_ull, type_ull;
> +	struct landlock_socket_attr protocol =3D {
> +		.allowed_access =3D allowed_access,
> +	};
> +
> +	env_protocol_name =3D getenv(env_var);
> +	if (!env_protocol_name)
> +		return 0;
> +	env_protocol_name =3D strdup(env_protocol_name);
> +	unsetenv(env_var);
> +
> +	while ((strprotocol =3D strsep(&env_protocol_name, ENV_DELIMITER))) {
> +		strfamily =3D strsep(&strprotocol, ENV_TOKEN_INTERNAL_DELIMITER);
> +		strtype =3D strsep(&strprotocol, ENV_TOKEN_INTERNAL_DELIMITER);

This works with strings such as "123:456:foobar", because you are using str=
sep()
twice on strprotocol; this looks unintentional?


> +
> +		if (!strtype) {
> +			fprintf(stderr,
> +				"Failed to extract socket protocol with "
> +				"unspecified type value\n");
> +			goto out_free_name;
> +		}
> +
> +		if (str2num(strfamily, &family_ull)) {
> +			fprintf(stderr,
> +				"Failed to convert \"%s\" into a number\n",
> +				strfamily);
> +			goto out_free_name;
> +		}
> +		if (str2num(strtype, &type_ull)) {
> +			fprintf(stderr,
> +				"Failed to convert \"%s\" into a number\n",
> +				strtype);
> +			goto out_free_name;
> +		}
> +		protocol.family =3D (int)family_ull;
> +		protocol.type =3D (int)type_ull;
> +
> +		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				      &protocol, 0)) {
> +			fprintf(stderr,
> +				"Failed to update the ruleset with "
> +				"family \"%s\" and type \"%s\": %s\n",
> +				strfamily, strtype, strerror(errno));
> +			goto out_free_name;
> +		}
> +	}
> +	ret =3D 0;
> +
> +out_free_name:
> +	free(env_protocol_name);
> +	return ret;
> +}
> +
>  /* clang-format off */
> =20
>  #define ACCESS_FS_ROUGHLY_READ ( \
> @@ -233,14 +296,14 @@ static int populate_ruleset_net(const char *const e=
nv_var, const int ruleset_fd,
> =20
>  /* clang-format on */
> =20
> -#define LANDLOCK_ABI_LAST 5
> +#define LANDLOCK_ABI_LAST 6
> =20
>  int main(const int argc, char *const argv[], char *const *const envp)
>  {
>  	const char *cmd_path;
>  	char *const *cmd_argv;
>  	int ruleset_fd, abi;
> -	char *env_port_name;
> +	char *env_optional_name;
>  	__u64 access_fs_ro =3D ACCESS_FS_ROUGHLY_READ,
>  	      access_fs_rw =3D ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE=
;
> =20
> @@ -248,18 +311,19 @@ int main(const int argc, char *const argv[], char *=
const *const envp)
>  		.handled_access_fs =3D access_fs_rw,
>  		.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
>  				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
>  	};
> =20
>  	if (argc < 2) {
>  		fprintf(stderr,
> -			"usage: %s=3D\"...\" %s=3D\"...\" %s=3D\"...\" %s=3D\"...\"%s "
> +			"usage: %s=3D\"...\" %s=3D\"...\" %s=3D\"...\" %s=3D\"...\" %s=3D\"..=
.\"%s "
>  			"<cmd> [args]...\n\n",
>  			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
> -			ENV_TCP_CONNECT_NAME, argv[0]);
> +			ENV_TCP_CONNECT_NAME, ENV_SOCKET_CREATE_NAME, argv[0]);
>  		fprintf(stderr,
>  			"Execute a command in a restricted environment.\n\n");
>  		fprintf(stderr,
> -			"Environment variables containing paths and ports "
> +			"Environment variables containing paths, ports and protocols "
>  			"each separated by a colon:\n");
>  		fprintf(stderr,
>  			"* %s: list of paths allowed to be used in a read-only way.\n",
> @@ -268,7 +332,7 @@ int main(const int argc, char *const argv[], char *co=
nst *const envp)
>  			"* %s: list of paths allowed to be used in a read-write way.\n\n",
>  			ENV_FS_RW_NAME);
>  		fprintf(stderr,
> -			"Environment variables containing ports are optional "
> +			"Environment variables containing ports or protocols are optional "
>  			"and could be skipped.\n");
>  		fprintf(stderr,
>  			"* %s: list of ports allowed to bind (server).\n",
> @@ -276,15 +340,19 @@ int main(const int argc, char *const argv[], char *=
const *const envp)
>  		fprintf(stderr,
>  			"* %s: list of ports allowed to connect (client).\n",
>  			ENV_TCP_CONNECT_NAME);
> +		fprintf(stderr,
> +			"* %s: list of socket protocols allowed to be created.\n",
> +			ENV_SOCKET_CREATE_NAME);

Might be worth listing some example values for this parameter, e.g. for TCP=
/IP
and UDP/IP?  This is also needed to make it clear that these can't be given=
 by
name, but only by number.


>  		fprintf(stderr,
>  			"\nexample:\n"
>  			"%s=3D\"${PATH}:/lib:/usr:/proc:/etc:/dev/urandom\" "
>  			"%s=3D\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
>  			"%s=3D\"9418\" "
>  			"%s=3D\"80:443\" "
> +			"%s=3D\"10.2:1.1\" "
>  			"%s bash -i\n\n",
>  			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
> -			ENV_TCP_CONNECT_NAME, argv[0]);
> +			ENV_TCP_CONNECT_NAME, ENV_SOCKET_CREATE_NAME, argv[0]);
>  		fprintf(stderr,
>  			"This sandboxer can use Landlock features "
>  			"up to ABI version %d.\n",
> @@ -351,7 +419,11 @@ int main(const int argc, char *const argv[], char *c=
onst *const envp)
>  	case 4:
>  		/* Removes LANDLOCK_ACCESS_FS_IOCTL_DEV for ABI < 5 */
>  		ruleset_attr.handled_access_fs &=3D ~LANDLOCK_ACCESS_FS_IOCTL_DEV;
> -
> +		__attribute__((fallthrough));
> +	case 5:
> +		/* Removes socket support for ABI < 6 */
> +		ruleset_attr.handled_access_socket &=3D
> +			~LANDLOCK_ACCESS_SOCKET_CREATE;
>  		fprintf(stderr,
>  			"Hint: You should update the running kernel "
>  			"to leverage Landlock features "
> @@ -371,18 +443,23 @@ int main(const int argc, char *const argv[], char *=
const *const envp)
>  	access_fs_rw &=3D ruleset_attr.handled_access_fs;
> =20
>  	/* Removes bind access attribute if not supported by a user. */
> -	env_port_name =3D getenv(ENV_TCP_BIND_NAME);
> -	if (!env_port_name) {
> +	env_optional_name =3D getenv(ENV_TCP_BIND_NAME);
> +	if (!env_optional_name) {
>  		ruleset_attr.handled_access_net &=3D
>  			~LANDLOCK_ACCESS_NET_BIND_TCP;
>  	}
>  	/* Removes connect access attribute if not supported by a user. */
> -	env_port_name =3D getenv(ENV_TCP_CONNECT_NAME);
> -	if (!env_port_name) {
> +	env_optional_name =3D getenv(ENV_TCP_CONNECT_NAME);
> +	if (!env_optional_name) {
>  		ruleset_attr.handled_access_net &=3D
>  			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>  	}
> -
> +	/* Removes socket create access attribute if not supported by a user. *=
/

Phrasing nit: I would say "requested by a user"?

(And maybe also in the two cases above)


> +	env_optional_name =3D getenv(ENV_SOCKET_CREATE_NAME);
> +	if (!env_optional_name) {
> +		ruleset_attr.handled_access_socket &=3D
> +			~LANDLOCK_ACCESS_SOCKET_CREATE;
> +	}
>  	ruleset_fd =3D
>  		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>  	if (ruleset_fd < 0) {
> @@ -406,6 +483,11 @@ int main(const int argc, char *const argv[], char *c=
onst *const envp)
>  		goto err_close_ruleset;
>  	}
> =20
> +	if (populate_ruleset_socket(ENV_SOCKET_CREATE_NAME, ruleset_fd,
> +				    LANDLOCK_ACCESS_SOCKET_CREATE)) {
> +		goto err_close_ruleset;
> +	}
> +
>  	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>  		perror("Failed to restrict privileges");
>  		goto err_close_ruleset;
> --=20
> 2.34.1
>=20

As I also said on the Documentation patch, please remember to double check =
the
places where the ABI number is mentioned, after rebasing on Tahera's "scope=
d"
patches.

=E2=80=94G=C3=BCnther
