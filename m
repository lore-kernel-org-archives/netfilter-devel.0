From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nfacct 7/29] code-refactoring changes to the "command
 menu"
Date: Tue, 16 Jul 2013 00:41:13 +0200
Message-ID: <20130715224113.GC5405@localhost>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-8-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47272 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758330Ab3GOWlU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:41:20 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-8-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 10, 2013 at 07:25:05PM +0100, Michael Zintakis wrote:
> * replace the existing "command menu" with more efficient code, which is
> clearer and easier to maintain;

Can you provide some numbers to prove that efficiency gain?

> * prevent wrong number of command-line arguments being specified
> 
> * prevent the correct command line parameters being specified more than once
> (like "nfacct list xml xml" for example)
> 
> Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
> ---
>  src/nfacct.c | 253 ++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 119 insertions(+), 134 deletions(-)
> 
> diff --git a/src/nfacct.c b/src/nfacct.c
> index bf50f50..fbf9aa6 100644
> --- a/src/nfacct.c
> +++ b/src/nfacct.c
> @@ -23,18 +23,6 @@
>  #include <libmnl/libmnl.h>
>  #include <libnetfilter_acct/libnetfilter_acct.h>
>  
> -enum {
> -	NFACCT_CMD_NONE = 0,
> -	NFACCT_CMD_LIST,
> -	NFACCT_CMD_ADD,
> -	NFACCT_CMD_DELETE,
> -	NFACCT_CMD_GET,
> -	NFACCT_CMD_FLUSH,
> -	NFACCT_CMD_VERSION,
> -	NFACCT_CMD_HELP,
> -	NFACCT_CMD_RESTORE,
> -};
> -
>  static int nfacct_cmd_list(int argc, char *argv[]);
>  static int nfacct_cmd_add(int argc, char *argv[]);
>  static int nfacct_cmd_delete(int argc, char *argv[]);
> @@ -44,9 +32,57 @@ static int nfacct_cmd_version(int argc, char *argv[]);
>  static int nfacct_cmd_help(int argc, char *argv[]);
>  static int nfacct_cmd_restore(int argc, char *argv[]);
>  
> +/* Matches two strings, including partial matches */
> +static int nfacct_matches(const char *cmd, const char *pattern)
> +{
> +	size_t len;
> +
> +	if (cmd == NULL || pattern == NULL)
> +		return 0;
> +
> +	len = strlen(cmd);
> +	if (len == 0 || len > strlen(pattern))
> +		return 0;

These checking above are superfluous.

> +	return (strncmp(cmd, pattern, len) == 0);

This shortened matching is not described in the patch description and
it does not handle clashes.

> +}
> +
> +/* main command 'menu' */
> +static const struct cmd {
> +	const char *cmd;
> +	int (*func)(int argc, char **argv);
> +} cmds[] = {
> +	{ "list", 	nfacct_cmd_list },
> +	{ "add",	nfacct_cmd_add },
> +	{ "delete",	nfacct_cmd_delete },
> +	{ "get",	nfacct_cmd_get },
> +	{ "flush",	nfacct_cmd_flush },
> +	{ "restore",	nfacct_cmd_restore },
> +	{ "version",	nfacct_cmd_version },
> +	{ "help",	nfacct_cmd_help },
> +	{ NULL, NULL }
> +};
> +
> +static int nfacct_do_cmd(const char *argv0, int argc, char **argv)
> +{
> +	const struct cmd *c;
> +
> +	for (c = cmds; c->cmd; ++c) {
> +		if (nfacct_matches(argv0, c->cmd)) {
> +			return (c->func(argc-1, argv+1));
> +		}
> +	}
> +	fprintf(stderr, "nfacct v%s: Unknown command: %s\n",
> +		VERSION, argv0);
> +	return EXIT_FAILURE;
> +}
> +
> +
> +static void usage(char *argv[]) __attribute__((noreturn));
>  static void usage(char *argv[])
>  {
>  	fprintf(stderr, "Usage: %s command [parameters]...\n", argv[0]);
> +	exit(EXIT_FAILURE);
>  }
>  
>  static void nfacct_perror(const char *msg)
> @@ -59,80 +95,24 @@ static void nfacct_perror(const char *msg)
>  	}
>  }
>  
> -/* Matches two strings, including partial matches */
> -static int nfacct_matches(const char *cmd, const char *pattern)
> -{
> -	size_t len;
> -
> -	if (cmd == NULL || pattern == NULL)
> -		return 0;
> -
> -	len = strlen(cmd);
> -	if (len == 0 || len > strlen(pattern))
> -		return 0;
> -
> -	return (strncmp(cmd, pattern, len) == 0);
> -}
> +#define NFACCT_RET_ERR(x)	nfacct_perror(x); \
> +				goto err;

Hiding a goto in a macro is not good idea.

> +#define NFACCT_RET_ARG_ERR()	NFACCT_RET_ERR("unknown argument")
>
> +#define NFACCT_NEXT_ARG() 	do {		\
> +					argv++;	\
> +					argc--;	\
> +				} while(0)
>  
>  int main(int argc, char *argv[])
>  {
> -	int cmd = NFACCT_CMD_NONE, ret = 0;
> -
> -	if (argc < 2) {
> -		usage(argv);
> -		exit(EXIT_FAILURE);
> -	}
> -
> -	if (nfacct_matches(argv[1], "list"))
> -		cmd = NFACCT_CMD_LIST;
> -	else if (nfacct_matches(argv[1], "add"))
> -		cmd = NFACCT_CMD_ADD;
> -	else if (nfacct_matches(argv[1], "delete"))
> -		cmd = NFACCT_CMD_DELETE;
> -	else if (nfacct_matches(argv[1], "get"))
> -		cmd = NFACCT_CMD_GET;
> -	else if (nfacct_matches(argv[1], "flush"))
> -		cmd = NFACCT_CMD_FLUSH;
> -	else if (nfacct_matches(argv[1], "version"))
> -		cmd = NFACCT_CMD_VERSION;
> -	else if (nfacct_matches(argv[1], "help"))
> -		cmd = NFACCT_CMD_HELP;
> -	else if (nfacct_matches(argv[1], "restore"))
> -		cmd = NFACCT_CMD_RESTORE;
> -	else {
> -		fprintf(stderr, "nfacct v%s: Unknown command: %s\n",
> -			VERSION, argv[1]);
> -		usage(argv);
> -		exit(EXIT_FAILURE);
> -	}
> -
> -	switch(cmd) {
> -	case NFACCT_CMD_LIST:
> -		ret = nfacct_cmd_list(argc, argv);
> -		break;
> -	case NFACCT_CMD_ADD:
> -		ret = nfacct_cmd_add(argc, argv);
> -		break;
> -	case NFACCT_CMD_DELETE:
> -		ret = nfacct_cmd_delete(argc, argv);
> -		break;
> -	case NFACCT_CMD_GET:
> -		ret = nfacct_cmd_get(argc, argv);
> -		break;
> -	case NFACCT_CMD_FLUSH:
> -		ret = nfacct_cmd_flush(argc, argv);
> -		break;
> -	case NFACCT_CMD_VERSION:
> -		ret = nfacct_cmd_version(argc, argv);
> -		break;
> -	case NFACCT_CMD_HELP:
> -		ret = nfacct_cmd_help(argc, argv);
> -		break;
> -	case NFACCT_CMD_RESTORE:
> -		ret = nfacct_cmd_restore(argc, argv);
> -		break;
> -	}
> -	return ret < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
> +	int ret = 0;
> +
> +	if (argc >= 2) {
> +		ret = nfacct_do_cmd(argv[1], argc-1, argv+1);
> +		if (ret != EXIT_FAILURE)
> +			return ret < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
> +	}
> +	usage(argv);
>  }
>  
>  static bool xml_header = false;
> @@ -174,29 +154,29 @@ err:
>  
>  static int nfacct_cmd_list(int argc, char *argv[])
>  {
> -	bool zeroctr = false, xml = false;
> +	bool nfnl_msg = false, xml = false;
>  	struct mnl_socket *nl;
>  	char buf[MNL_SOCKET_BUFFER_SIZE];
>  	struct nlmsghdr *nlh;
>  	unsigned int seq, portid;
> -	int ret, i;
> +	int ret;
> +	uint8_t nfnl_cmd = NFNL_MSG_ACCT_GET;
>  
> -	for (i=2; i<argc; i++) {
> -		if (nfacct_matches(argv[i], "reset")) {
> -			zeroctr = true;
> -		} else if (nfacct_matches(argv[i], "xml")) {
> +	while (argc > 0) {
> +		if (!nfnl_msg && nfacct_matches(argv[0],"reset")) {
                                                        ^
                                                 space after comma

> +			nfnl_cmd = NFNL_MSG_ACCT_GET_CTRZERO;
> +			nfnl_msg = true;
> +		} else if (!xml && nfacct_matches(argv[0],"xml")) {
>  			xml = true;
>  		} else {
>  			nfacct_perror("unknown argument");
>  			return -1;
>  		}
> +		argc--; argv++;
>  	}
>  
>  	seq = time(NULL);
> -	nlh = nfacct_nlmsg_build_hdr(buf, zeroctr ?
> -					NFNL_MSG_ACCT_GET_CTRZERO :
> -					NFNL_MSG_ACCT_GET,
> -				     NLM_F_DUMP, seq);
> +	nlh = nfacct_nlmsg_build_hdr(buf, nfnl_cmd, NLM_F_DUMP, seq);
>  
>  	nl = mnl_socket_open(NETLINK_NETFILTER);
>  	if (nl == NULL) {
> @@ -298,15 +278,15 @@ static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
>  
>  static int nfacct_cmd_add(int argc, char *argv[])
>  {
> -	if (argc < 3 || strlen(argv[2]) == 0) {
> +	if (argc < 1 || strlen(argv[0]) == 0) {
>  		nfacct_perror("missing object name");
>  		return -1;
> -	} else if (argc > 3) {
> +	} else if (argc > 1) {
>  		nfacct_perror("too many arguments");
>  		return -1;
>  	}
>  
> -	return _nfacct_cmd_add(argv[2], 0, 0);
> +	return _nfacct_cmd_add(argv[0], 0, 0);
>  }
>  
>  static int nfacct_cmd_delete(int argc, char *argv[])
> @@ -318,10 +298,10 @@ static int nfacct_cmd_delete(int argc, char *argv[])
>  	struct nfacct *nfacct;
>  	int ret;
>  
> -	if (argc < 3 || strlen(argv[2]) == 0) {
> +	if (argc < 1 || strlen(argv[0]) == 0) {
>  		nfacct_perror("missing object name");
>  		return -1;
> -	} else if (argc > 3) {
> +	} else if (argc > 1) {
>  		nfacct_perror("too many arguments");
>  		return -1;
>  	}
> @@ -332,7 +312,7 @@ static int nfacct_cmd_delete(int argc, char *argv[])
>  		return -1;
>  	}
>  
> -	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[2]);
> +	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[0]);
>  
>  	seq = time(NULL);
>  	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_DEL,
> @@ -377,41 +357,46 @@ static int nfacct_cmd_delete(int argc, char *argv[])
>  
>  static int nfacct_cmd_get(int argc, char *argv[])
>  {
> -	bool zeroctr = false, xml = false;
> +	bool nfnl_msg = false, xml = false;
>  	struct mnl_socket *nl;
>  	char buf[MNL_SOCKET_BUFFER_SIZE];
>  	struct nlmsghdr *nlh;
>  	uint32_t portid, seq;
>  	struct nfacct *nfacct;
> -	int ret, i;
> +	int ret = -1, i;
> +	char *name;
> +	uint8_t nfnl_cmd = NFNL_MSG_ACCT_GET;
>  
> -	if (argc < 3 || strlen(argv[2]) == 0) {
> +	if (argc < 1 || strlen(argv[0]) == 0) {
>  		nfacct_perror("missing object name");
>  		return -1;
>  	}
> -	for (i=3; i<argc; i++) {
> -		if (nfacct_matches(argv[i], "reset")) {
> -			zeroctr = true;
> -		} else if (nfacct_matches(argv[i], "xml")) {
> +	name = strdup(argv[0]);
> +	if (!name) {
> +		nfacct_perror("OOM");
> +		return -1;
> +	}
> +	NFACCT_NEXT_ARG();
> +	while (argc > 0) {
> +		if (!nfnl_msg && nfacct_matches(argv[0],"reset")) {
> +			nfnl_cmd = NFNL_MSG_ACCT_GET_CTRZERO;
> +			nfnl_msg = true;
> +		} else if (!xml && nfacct_matches(argv[0],"xml")) {
>  			xml = true;
>  		} else {
> -			nfacct_perror("unknown argument");
> -			return -1;
> +			NFACCT_RET_ARG_ERR();
>  		}
> +		argc--; argv++;
>  	}
>  
>  	nfacct = nfacct_alloc();
>  	if (nfacct == NULL) {
> -		nfacct_perror("OOM");
> -		return -1;
> +		NFACCT_RET_ERR("OOM");
>  	}
> -	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[2]);
> +	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
>  
>  	seq = time(NULL);
> -	nlh = nfacct_nlmsg_build_hdr(buf, zeroctr ?
> -					NFNL_MSG_ACCT_GET_CTRZERO :
> -					NFNL_MSG_ACCT_GET,
> -				     NLM_F_ACK, seq);
> +	nlh = nfacct_nlmsg_build_hdr(buf, nfnl_cmd, NLM_F_ACK, seq);
>  
>  	nfacct_nlmsg_build_payload(nlh, nfacct);
>  
> @@ -419,38 +404,38 @@ static int nfacct_cmd_get(int argc, char *argv[])
>  
>  	nl = mnl_socket_open(NETLINK_NETFILTER);
>  	if (nl == NULL) {
> -		nfacct_perror("mnl_socket_open");
> -		return -1;
> +		NFACCT_RET_ERR("mnl_socket_open");
>  	}
>  
>  	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
> -		nfacct_perror("mnl_socket_bind");
> -		return -1;
> +		NFACCT_RET_ERR("mnl_socket_bind");
>  	}
>  	portid = mnl_socket_get_portid(nl);
>  
>  	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> -		nfacct_perror("mnl_socket_send");
> -		return -1;
> +		NFACCT_RET_ERR("mnl_socket_send");
>  	}
>  
> -	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> -	while (ret > 0) {
> -		ret = mnl_cb_run(buf, ret, seq, portid, nfacct_cb, &xml);
> -		if (ret <= 0)
> +	i = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> +	while (i > 0) {
> +		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb, &xml);
> +		if (i <= 0)
>  			break;
> -		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> +		i = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>  	}
> -	if (ret == -1) {
> -		nfacct_perror("error");
> -		return -1;
> +	if (i == -1) {
> +		NFACCT_RET_ERR("error");
>  	}
>  	mnl_socket_close(nl);
>  
>  	if (xml_header)
>  		printf("</nfacct>\n");
>  
> -	return 0;
> +	ret = 0;
> +
> +err:
> +	free(name);
> +	return ret;
>  }
>  
>  static int nfacct_cmd_flush(int argc, char *argv[])
> @@ -461,7 +446,7 @@ static int nfacct_cmd_flush(int argc, char *argv[])
>  	uint32_t portid, seq;
>  	int ret;
>  
> -	if (argc > 2) {
> +	if (argc > 0) {
>  		nfacct_perror("too many arguments");
>  		return -1;
>  	}
> @@ -522,7 +507,7 @@ static int nfacct_cmd_version(int argc, char *argv[])
>  static const char help_msg[] =
>  	"nfacct v%s: utility for the Netfilter extended accounting "
>  	"infrastructure\n"
> -	"Usage: %s command [parameters]...\n\n"
> +	"Usage: nfacct command [parameters]...\n\n"
>  	"Commands:\n"
>  	"  list [reset]\t\tList the accounting object table (and reset)\n"
>  	"  add object-name\tAdd new accounting object to table\n"
> @@ -535,7 +520,7 @@ static const char help_msg[] =
>  
>  static int nfacct_cmd_help(int argc, char *argv[])
>  {
> -	printf(help_msg, VERSION, argv[0]);
> +	printf(help_msg, VERSION);
>  	return 0;
>  }
>  
> @@ -546,7 +531,7 @@ static int nfacct_cmd_restore(int argc, char *argv[])
>  	char buffer[512];
>  	int ret;
>  
> -	if (argc > 2) {
> +	if (argc > 0) {
>  		nfacct_perror("too many arguments");
>  		return -1;
>  	}
> -- 
> 1.8.3.1
> 
