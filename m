From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem with NetBIOS name service protocol support in 2.6.15
Date: Sat, 14 Jan 2006 17:25:30 +0100
Message-ID: <43C925FA.8070400@trash.net>
References: <Pine.LNX.4.64.0601131444030.9316@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0601131444030.9316@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Hello,
> 
> I have just upgraded one of my servers to 2.6.15 and noticed that 
> computser are no longer able to browse "Network Neighbourhood".
> 
> Packets sended by workstations (for example 192.168.0.3) to the 
> broadcast address were ignored:
> 
> 14:31:56.027354 IP 192.168.0.3.138 > 192.168.0.255.138: NBT UDP PACKET(138)
> 14:31:58.027459 IP 192.168.0.3.138 > 192.168.0.255.138: NBT UDP PACKET(138)
> 14:31:58.027584 IP 192.168.0.3.138 > 192.168.0.255.138: NBT UDP PACKET(138)
> 
> What is strange that I solved this problem by recompiling and booting 
> kernel without ip_conntrack_netbios_ns enabled. Now everything works 
> fine. I thought that it should only handle UDP packets to port 137...

It does, your problem must be related to something else. Can you verify
that enabling the helper again causes the problem to reoccur?
