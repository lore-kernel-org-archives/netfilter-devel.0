From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] complete nfnl_talk
Date: Mon, 02 Jun 2003 21:48:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EDBAA25.9090808@trash.net>
References: <3EDB99E2.8050100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <3EDB99E2.8050100@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

One tought about the patch:

> int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,
> 	      unsigned groups, struct nlmsghdr *answer,
> 	      int (*junk)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
> 	      void *jarg)
> 
>
...

> 
>+			if (h->nlmsg_type == NLMSG_ERROR) {
>+				struct nlmsgerr *err = NLMSG_DATA(h);
>+				if (l < sizeof(struct nlmsgerr))
>+					nfnl_error("ERROR truncated\n");
>+				else {
>+					errno = -err->error;
>+					if (errno == 0) {
>+						if (answer)
>+							memcpy(answer, h, h->nlmsg_len);
>+						return 0;
>+					}
>+					perror("CTNETLINK answers");
>+				}
>+				return -1;
>  
>

applications might want to handle the error themselves, an alternative 
would be:

errno = -err->error;
if (anwer) {
        memcpy(answer, h, h->nlmsg_len);
        return errno;
} else if (errno)
        perror("CTNETLINK answers);
return errno;

What do you think ?
Patrick
