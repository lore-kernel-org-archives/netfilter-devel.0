From: "Julien DHERSIN" <dhersin@gmail.com>
Subject: Re: libnetfilter_queue man page
Date: Fri, 2 Mar 2007 14:15:45 +0100
Message-ID: <2e25cc380703020515h3c1724aclf5381c94a500d199@mail.gmail.com>
References: <2e25cc380702270005sfdf44a3q50305cdfa65b4732@mail.gmail.com>
	<45E578EC.2060803@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E578EC.2060803@netfilter.org>
Content-Disposition: inline
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

Thanks for your answers.
But, I still have some troubles with this library.
My following code doesn't seem to work. Have you any idea ?

static int read_pkt (struct nfq_data *nfa) {
	int payload_len;
	struct ip6_hdr * ip6_hdrs;
	char * payload;
	struct in6_addr * ip6_dest;
	char dst[16];	/* char dst[INET6_ADDRSTRLEN]; */

	payload_len = nfq_get_payload(nfa, &payload);
 	if (payload_len == -1)
		printf("Error : nfq_get_payload\n");
 	printf("Length : %d\n", payload_len);

 	ip6_hdrs = malloc(payload_len);
 	if(!ip6_hdrs)
 		printf("Error : malloc\n");

	if(!memcpy(ip6_hdrs, payload, payload_len))
		printf("Error : memcpy\n");

	if (!inet_ntop(AF_INET6, &(ip6_hdrs)->ip6_dst, dst, sizeof(dst)))
		fprintf(stdout, "dest: %s\n", dst);

	free(ip6_hdrs);
}

And I didn't find any way to cast my payload to cmsg structure (in
order to use the routine defined in RFC3542). Then, I would use some
functions such as inet6_rth_init() to add options in the Hop-by-hop
extension. But maybe I'm on the wrong way.

Thanks for your help.

cu,
Julien

2007/2/28, Pablo Neira Ayuso <pablo@netfilter.org>:
> Julien DHERSIN wrote:
> > But, I still have a question : I would like to add an extension in
> > filtered IPv6
> > multicast packets headers. Do you think, I can do this in the userspace
> > using libnetfilter queue ? And, how precisely does it work ? Is it
> > something like this :
>
> Yes, you can process packets from userspace via libnetfilter_queue.
>
> > 1. Activate the hook NF_IP6_LOCAL_OUT with an iptables rule
>
> ip6tables -I OUTPUT -j NFQUEUE
>
> > 2. Launch my software with libnetfilter_queue
> > 3. Modify the header
> > 4. Return the whole packet to netfilter
>
> Correct.
>
> > Do I have tocreate a specific kernel module ?
>
> Not necessarily, you can do it from userspace, anyway this question also
> depends on your needs.
>
> --
> The dawn of the fourth age of Linux firewalling is coming; a time of
> great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
>
