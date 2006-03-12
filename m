From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter_queue reinjecting packets
Date: Sun, 12 Mar 2006 15:44:18 +0100
Message-ID: <441433C2.6010901@trash.net>
References: <1142119489.2987.61.camel@localhost>
	<20060312151054.5a2020ad.aton@packetdropped.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: aton <aton@packetdropped.org>
In-Reply-To: <20060312151054.5a2020ad.aton@packetdropped.org>
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

aton wrote:
> has anyone used netfilter_queue and successfully re-injected packets into the net?
> 
> i want to write sort of a userspace routing application. 
> 
> host A is my workstation, it has host B as default gateway.
> 
> on host B my routing application runs. 
> it receives packets from netfilter_queue using libnetfilter_queue.
> this works very well and i can display the whole packets.
> 
> now i just want to send them back into the net, so that they reach their destination.
> 
> i modified the main loop in the source of nfqnl_test.c in the libnetfilter_queue package:
> 
> 	while ((rv=recv(fd, buf, sizeof(buf), 0)) >= 0)
> 	{
> 		printf("pkt received:\n");
> 		
> 		printf("sending packet back\n");
> 		
> 		if ((sv=send(fd, buf, sizeof(buf), 0))==-1)
> 		{
> 			perror("send");
> 			exit(EXIT_FAILURE);
> 		}
> 		printf("done\n");
> 	}
> 
> this should send every packet back to... where? 
> it seems the packets are just sent into nirvana, i cannot sniff them, and i dont get an error from send().

nfnql_test already reinjects packets by the call to nfq_issue_verdict.
It seems you need to read the documentation ..
