From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Conntrack & NAT question
Date: Thu, 15 Jul 2004 17:42:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F6A5C8.8030700@eurodev.net>
References: <1089882225.2556.10.camel@nienna.balabit> <40F69EC8.80903@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40F69EC8.80903@eurodev.net>
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

sorry I meant this part:

>RCS file: /cvspublic/netfilter-ha/ct_sync/ct_sync_main.c,v
>retrieving revision 1.30
>diff -u -r1.30 ct_sync_main.c
>--- ct_sync_main.c	13 Jul 2004 14:53:41 -0000	1.30
>+++ ct_sync_main.c	15 Jul 2004 14:14:58 -0000
>@@ -164,6 +164,9 @@
> 	hdr->resource = CT_SYNC_RES_CONNTRACK;
> 	hdr->len = __constant_htons(sizeof(*sct));
> 
>+	memset(&sct->orig, 0, sizeof(struct ip_conntrack_tuple));
>+	memset(&sct->reply, 0, sizeof(struct ip_conntrack_tuple));
>+
> 	/* copy data from conntrack struct */
> 	memcpy(&sct->orig, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, 
> 		sizeof(sct->orig));
>  
>

regards,
Pablo
