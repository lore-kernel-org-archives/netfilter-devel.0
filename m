From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RESEND PATCH 2/2] nfacct: adding quota capabilities
Date: Mon, 28 Apr 2014 10:56:25 +0200
Message-ID: <20140428085625.GA18836@localhost>
References: <1398041896-8479-1-git-send-email-mathieu.poirier@linaro.org>
 <1398041896-8479-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org
To: mathieu.poirier@linaro.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46401 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaD1I4m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:56:42 -0400
Content-Disposition: inline
In-Reply-To: <1398041896-8479-2-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 20, 2014 at 06:58:16PM -0600, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> The accounting framework now supports quota at the packet and byte
> level.  The tool is simply enhanced with two optional arguments to
> specify the whether accounting for byte of packet and the limit
> associated with each.  Also adding a monitor mode that listens for
> quota attainment notification.
> 
> Examples:
> 
> /* create an accounting object that isn't associated to a quota */
> $ nfacct add first_no_quota
> 
> /* create a quota object with byte count limited to 50 byte */
> $ nfacct add second_quota byte 50
> 
> /* create a quota object with packet count limited to 5 */
> $ nfacct add third_quota packet 5
> 
> From there the accounting objects can be used in iptables the same
> way as they did before:
> 
> /* limit the number of icmp packets allowed through the OUTPUT chain */
> $ iptables -I OUTPUT -p icmp -m nfacct --nfacct-name third_quota --jump REJECT
> 
> /* listening for quota attainment notification */
> $ nfacct listen

I'm going to rename this to 'monitor' instead.

> @@ -526,28 +569,93 @@ static int nfacct_cmd_help(int argc, char *argv[])
>  
>  static int nfacct_cmd_restore(int argc, char *argv[])
>  {
> -	uint64_t pkts, bytes;
> -	char name[512];
> -	char buffer[512];
> -	int ret;
> +	uint64_t pkts, bytes, quota;
> +	char name[512], mode[512], buffer[512];
> +	int ret, flags;
>  
>  	while (fgets(buffer, sizeof(buffer), stdin)) {
>  		char *semicolon = strchr(buffer, ';');
> +
>  		if (semicolon == NULL) {
>  			nfacct_perror("invalid line");
>  			return -1;
>  		}
> +
> +		/* a single ';' terminates the input */
> +		if (strncmp(buffer, ";", 1) == 0)
> +			break;

This chunk seems new, why is it needed there?
