From: Pablo Neira <pablo@eurodev.net>
Subject: Re: sctp conntrack
Date: Mon, 02 Aug 2004 13:37:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <410E277A.3050202@eurodev.net>
References: <20040722191649.GJ14946@obroa-skai.de.gnumonks.org> <200407271348.34615.immidi@spymac.com> <20040801165005.GA14539@sunbeam2> <200408021555.38315.immidi@spymac.com> <20040802110522.GN18758@sunbeam2> <410E26DB.2070307@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 Kiran Kumar <immidi_kiran@yahoo.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <410E26DB.2070307@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again,

I forgot something...

Pablo Neira wrote:

>-#define NET_IP_CONNTRACK_MAX 2089
>-
> static ctl_table ip_ct_netfilter_table[] = {
> 	{
> 		.ctl_name	= NET_IPV4_NETFILTER,
>@@ -460,14 +458,6 @@
> 		.mode		= 0555,
> 		.child		= ip_ct_sysctl_table,
> 	},
>-	{
>-		.ctl_name	= NET_IP_CONNTRACK_MAX,
>-		.procname	= "ip_conntrack_max",
>-		.data		= &ip_conntrack_max,
>-		.maxlen		= sizeof(int),
>-		.mode		= 0644,
>-		.proc_handler	= &proc_dointvec
>-	},
> 	{ .ctl_name = 0 }
> };
> 
>  
>

ip_conntrack_max is duplicated, is there any reason to do so? that's why 
I remove that entry in the sysctl table.

regards,
Pablo
