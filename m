From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4/2.5]
Date: Sun, 29 Jun 2003 22:56:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EFF5267.2080808@trash.net>
References: <1056913883.1068.70.camel@exile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@interlinx.bc.ca,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
In-Reply-To: <1056913883.1068.70.camel@exile>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Filip,
you should remove the memsets, they are currently beeing removed from the
others helpers.

Best regards,
Patrick

Filip Sneppe (Cronos) wrote:

>-	if (ret) {
>-		printk("ip_ct_amanda: ERROR registering helper\n");
>-		fini();
>-		return -EBUSY;
>+	for(i = 0; (i < MAX_PORTS) && ports[i]; i++) {
>+		memset(&amanda_helper[i], 0, sizeof(struct ip_conntrack_helper));
>+		amanda_helper[i].tuple.src.u.udp.port = htons(ports[i]);
>+		amanda_helper[i].tuple.dst.protonum = IPPROTO_UDP;
>
>  
>
