From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] libnftnl: tests: Use getopt_long to parse the
 command-line arguments.
Date: Thu, 3 Apr 2014 14:52:32 +0200
Message-ID: <20140403125232.GA29035@localhost>
References: <3e44e7f0295e9f77d935a6587a24ccba4de20b57.1396528105.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41888 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbaDCMwi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:52:38 -0400
Content-Disposition: inline
In-Reply-To: <3e44e7f0295e9f77d935a6587a24ccba4de20b57.1396528105.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 03, 2014 at 02:40:13PM +0200, Ana Rey wrote:
> Use getopt_long to parse the command-line arguments and prepare it to
> add new arguments in next patches.
> 
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
> [Change in v2]
> 
> Delete some references to second command-line argument (-u). I'll add it in
> other patch.
> 
> 
>  tests/nft-parsing-test.c | 52 +++++++++++++++++++++++++++++++++++++++++-------
>  tests/test-script.sh     |  4 ++--
>  2 files changed, 47 insertions(+), 9 deletions(-)
> 
> diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
> index 1786cb6..808ecfb 100644
> --- a/tests/nft-parsing-test.c
> +++ b/tests/nft-parsing-test.c
> @@ -4,6 +4,7 @@
>  #include <dirent.h>
>  #include <limits.h>
>  #include <errno.h>
> +#include <getopt.h>
>  
>  #include <libmnl/libmnl.h> /*nlmsghdr*/
>  #include <libnftnl/ruleset.h>
> @@ -161,7 +162,7 @@ failparsing:
>  	return -1;
>  }
>  
> -int main(int argc, char *argv[])
> +static int execute_test(const char *dir_name)
>  {
>  	DIR *d;
>  	struct dirent *dent;
> @@ -169,12 +170,8 @@ int main(int argc, char *argv[])
>  	int ret = 0, exit_code = 0;
>  	struct nft_parse_err *err;
>  
> -	if (argc != 2) {
> -		fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
> -		exit(EXIT_FAILURE);
> -	}
> +	d = opendir(dir_name);
>  

remove this empty line.

> -	d = opendir(argv[1]);
>  	if (d == NULL) {
>  		perror("opendir");
>  		exit(EXIT_FAILURE);
> @@ -193,7 +190,7 @@ int main(int argc, char *argv[])
>  		    strcmp(dent->d_name, "..") == 0)
>  			continue;
>  
> -		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
> +		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
>  
>  		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
>  			if ((ret = test_xml(path, err)) == 0) {
> @@ -219,3 +216,44 @@ int main(int argc, char *argv[])
>  
>  	return 0;
>  }
> +
> +int main(int argc, char *argv[])
> +{
> +
> +	int c;
> +	int ret = 0;
> +
> +	if (argc < 2) {
> +		fprintf(stderr, "Usage: %s -d <directory>\n", argv[0]);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	while (1) {
> +		int option_index = 0;
> +		static struct option long_options[] = {
> +			{"dir", required_argument, 0, 'd'},
> +			{0,0,0,0}
> +		};
> +		c = getopt_long(argc, argv, "d:", long_options, &option_index);
> +
> +		if (c == -1)
> +			break;
> +
> +		switch (c) {
> +		case 'd':
> +			ret = execute_test(optarg);
> +			break;
> +		default:

Just bail out if we get incorrect options, call something like

static void print_usage(...)
{
        printf("Usage description here...");
}

and stop processing.

> +			break;
> +		}
> +	}
> +
> +	if (optind < argc) {
> +		printf("non-option ARGV-elements: ");
> +		while (optind < argc)
> +			printf("%s ", argv[optind++]);
> +	printf("\nUsage: -d <directory>\n");

so you don't need to do this.
