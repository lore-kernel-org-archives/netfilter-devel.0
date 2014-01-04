From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] src: new error reporting approach for
 XML/JSON parsers
Date: Sat, 4 Jan 2014 01:42:15 +0100
Message-ID: <20140104004215.GB23504@localhost>
References: <20131231112747.11095.53072.stgit@Ph0enix>
 <20131231112754.11095.95241.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42736 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaADAmZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:42:25 -0500
Content-Disposition: inline
In-Reply-To: <20131231112754.11095.95241.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alvaro,

Several comments on this patch.

On Tue, Dec 31, 2013 at 12:27:54PM +0100, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> I have added a new structure for reporting some errors that
> we can't consider with errno.

Please, longer/better descriptions are required. Examples are very
useful to show how errors are displayed if you use this new API.

> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  examples/nft-chain-json-add.c |   11 +++++
>  examples/nft-chain-xml-add.c  |   11 +++++
>  examples/nft-rule-json-add.c  |   11 +++++
>  examples/nft-rule-xml-add.c   |   11 +++++
>  examples/nft-set-json-add.c   |   12 +++++
>  examples/nft-table-json-add.c |   11 +++++
>  examples/nft-table-xml-add.c  |   12 +++++
>  include/libnftables/chain.h   |    3 +
>  include/libnftables/common.h  |   11 +++++
>  include/libnftables/rule.h    |    3 +
>  include/libnftables/ruleset.h |    3 +
>  include/libnftables/set.h     |    6 ++-
>  include/libnftables/table.h   |    3 +
>  src/Makefile.am               |    1=20
>  src/chain.c                   |   75 ++++++++++++++++++++-----------=
---
>  src/common.c                  |   33 +++++++++++++++
>  src/expr/bitwise.c            |   26 ++++++------
>  src/expr/byteorder.c          |   27 +++++++-----
>  src/expr/cmp.c                |   20 +++++----
>  src/expr/counter.c            |   16 +++++--
>  src/expr/ct.c                 |   19 +++++----
>  src/expr/data_reg.c           |   54 ++++++++++++++-----------
>  src/expr/data_reg.h           |    6 ++-
>  src/expr/exthdr.c             |   23 ++++++----
>  src/expr/immediate.c          |   14 ++++--
>  src/expr/limit.c              |   17 +++++---
>  src/expr/log.c                |   27 ++++++++----
>  src/expr/lookup.c             |   18 +++++---
>  src/expr/match.c              |   10 +++--
>  src/expr/meta.c               |   14 ++++--
>  src/expr/nat.c                |   30 +++++++-------
>  src/expr/payload.c            |   24 ++++++-----
>  src/expr/reject.c             |   16 +++++--
>  src/expr/target.c             |   10 +++--
>  src/expr_ops.h                |    6 ++-
>  src/internal.h                |   90 +++++++++++++++++++++++++++++--=
----------
>  src/jansson.c                 |   83 ++++++++++++++++++++++++++-----=
-------
>  src/libnftables.map           |    5 ++
>  src/mxml.c                    |   81 +++++++++++++++++++++++++++----=
------
>  src/rule.c                    |   69 ++++++++++++++++++-------------
>  src/ruleset.c                 |   72 +++++++++++++++++++------------=
--
>  src/set.c                     |   70 ++++++++++++++++++-------------=
-
>  src/set_elem.c                |   21 +++++-----
>  src/table.c                   |   44 ++++++++++++--------
>  tests/nft-parsing-test.c      |   37 ++++++++++-------
>  45 files changed, 759 insertions(+), 407 deletions(-)
>=20
> diff --git a/examples/nft-chain-json-add.c b/examples/nft-chain-json-=
add.c
> index 50cb29f..384729c 100644
> --- a/examples/nft-chain-json-add.c
> +++ b/examples/nft-chain-json-add.c
> @@ -39,6 +39,7 @@ int main(int argc, char *argv[])
>  	uint16_t family;
>  	char json[4096];
>  	char reprint[4096];
> +	struct nft_parse_err *err;
> =20
>  	if (argc < 2) {
>  		printf("Usage: %s <json-file>\n", argv[0]);
> @@ -63,10 +64,17 @@ int main(int argc, char *argv[])
>  		exit(EXIT_FAILURE);
>  	}
> =20
> +	err =3D nft_err_alloc();

nft_err_alloc() should be renamed to nft_parse_err_alloc() to make
this specific to parsing functions.

Then, nft_err_free() to nft_parse_err_free().

> +	if(err =3D=3D NULL) {
          ^
cosmetic: missing space

> +		perror("error");
> +		exit(EXIT_FAILURE);
> +	}
> +
>  	close(fd);
> =20
> -	if (nft_chain_parse(c, NFT_PARSE_JSON, json) < 0) {
> +	if (nft_chain_parse(c, NFT_PARSE_JSON, json, err) < 0) {
>  		printf("E: Unable to parse JSON file: %s\n", strerror(errno));

This line above should be removed, the error printing function should
provide enough information to make this unnecessary...

> +		nft_err_print(err);

Better replace this nft_err_print by:

int nft_parse_perror(const char *str, struct nft_parse_err *err)

then, the example invocation looks like:

nft_parse_perror("Unable to parse JSON file", err);

the output message should look like:

Unable to parse JSON file: Bad input at line ...

attaching the descriptive information that should help to locate the
problem.

>  		exit(EXIT_FAILURE);
>  	}
> =20
> @@ -82,6 +90,7 @@ int main(int argc, char *argv[])
>  	nft_chain_nlmsg_build_payload(nlh, c);
> =20
>  	nft_chain_free(c);
> +	nft_err_free(err);
> =20
>  	nl =3D mnl_socket_open(NETLINK_NETFILTER);
>  	if (nl =3D=3D NULL) {
> diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-ad=
d.c
> index 03a2950..e3dd652 100644
> --- a/examples/nft-chain-xml-add.c
> +++ b/examples/nft-chain-xml-add.c
> @@ -37,6 +37,7 @@ int main(int argc, char *argv[])
>  	uint16_t family;
>  	char xml[4096];
>  	char reprint[4096];
> +	struct nft_parse_err *err;
> =20
>  	if (argc < 2) {
>  		printf("Usage: %s <xml-file>\n", argv[0]);
> @@ -49,6 +50,12 @@ int main(int argc, char *argv[])
>  		exit(EXIT_FAILURE);
>  	}
> =20
> +	err =3D nft_err_alloc();
> +	if(err =3D=3D NULL) {

Same here and in other examples.

> +		perror("error");
> +		exit(EXIT_FAILURE);
> +	}
> +
>          fd =3D open(argv[1], O_RDONLY);
>          if (fd < 0) {
>                  perror("open");
> @@ -63,8 +70,9 @@ int main(int argc, char *argv[])
> =20
>  	close(fd);
> =20
> -	if (nft_chain_parse(c, NFT_PARSE_XML, xml) < 0) {
> +	if (nft_chain_parse(c, NFT_PARSE_XML, xml, err) < 0) {
>  		printf("E: Unable to parse XML file: %s\n", strerror(errno));
> +		nft_err_print(err);
>  		exit(EXIT_FAILURE);
>  	}
> =20
> @@ -80,6 +88,7 @@ int main(int argc, char *argv[])
>  	nft_chain_nlmsg_build_payload(nlh, c);
> =20
>  	nft_chain_free(c);
> +	nft_err_free(err);
> =20
>  	nl =3D mnl_socket_open(NETLINK_NETFILTER);
>  	if (nl =3D=3D NULL) {
> diff --git a/include/libnftables/common.h b/include/libnftables/commo=
n.h
> index 9cd92b2..b88c899 100644
> --- a/include/libnftables/common.h
> +++ b/include/libnftables/common.h
> @@ -1,6 +1,12 @@
>  #ifndef _LIBNFTABLES_COMMON_H_
>  #define _LIBNFTABLES_COMMON_H_
> =20
> +enum {
> +	NFT_EBADINPUT	=3D 0,
> +	NFT_EMISSINGNODE,
> +	NFT_EBADTYPE,

NFT_PARSE_EBADINPUT
NFT_PARSE_EMISSINGNODE
NFT_PARSE_EBADTYPE

add infix _PARSE_ so these are clearly specific to the parsing
function.

BTW, I don't see any getter function in this patch to access the privat=
e
attributes of this new nft_parse_err object, those need to be added.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
