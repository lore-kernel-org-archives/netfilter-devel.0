From: Pablo Neira <pablo@netfilter.org>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Thu, 08 Sep 2005 01:43:34 +0200
Message-ID: <431F7B26.4040302@netfilter.org>
References: <m2zmqoscc5.fsf@cerbere.dyndns.info>
	<m2slwgsc4p.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samir Bellabes <sbellabes@mandriva.com>
In-Reply-To: <m2slwgsc4p.fsf@cerbere.dyndns.info>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Samir Bellabes wrote:
>  	for (i = 0; i < ports_c; i++) {
> +		/* don't allow bad port values */
> +		if (ports[i] < 1 || ports[i] > 65535) {
> +			printk(KERN_WARNING "ip_ct_ftp: ERROR port"
> +			       "should be between 1 and 65535\n");
> +			fini();
> +			return -EINVAL;
> +		}

Better something like this?
 
                                      -static int ports[MAX_PORTS]; 
                                               +static short 
ports[MAX_PORTS]; 
static int ports_c; 
        -module_param_array(ports, int, &ports_c, 0400); 
                 +module_param_array(ports, short, &ports_c, 0400); 
 


--
Pablo
