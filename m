From: Patrick McHardy <kaber@trash.net>
Subject: Re: trying to revive rtsp
Date: Mon, 20 Feb 2006 18:36:55 +0100
Message-ID: <43F9FE37.9020109@trash.net>
References: <43F87D21.7090305@kde.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mickael Marchand <marchand@kde.org>
In-Reply-To: <43F87D21.7090305@kde.org>
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

Mickael Marchand wrote:
> Hi,
> 
> I am really a newbie to the netfilter coding world, so please forgive
> any stupid questions :)
> 
> I have mostly ported the old rtsp conntrack+nat code to recent 2.6
> kernels, compiles and loads fine into the kernel,
> but I have some problems to make it work now :)
> 
> the initial TCP connexion to the RTSP server:554 is correctly detected
> and the expectation packet seems to be properly setup :
> cat /proc/net/ip_conntrack_expect
> 255 proto=17 src=212.27.38.253 dst=10.0.0.2 sport=0 dport=33302
> 
> 212.27.38.253 is the RTSP server, 10.0.0.2 is the client, 10.0.0.1 is
> the netfilter box.
> 
> so once the TCP connexion has been established, we expect a UDP stream
> from the server going to the client port 33302.
> 
> my problem is that the expected packet does not get through the
> netfilter box, I can see the UDP stream coming from the RTSP server and
> going to my netfilter box,
> the expectation packet seems to get removed of
> /proc/net/ip_conntrack_expect as well (so basically it looks all good)
> but the netfilter box does not forward packets to 10.0.0.2.
> so it looks like a NAT problem to me, maybe the UDP packets are not
> getting NAT-ed back to the client.
> 
> my first question would be :
> is it expected to see 10.0.0.2 in the expected paquet ?
> should not it be my external IP instead ?
> 
> any tips in what direction I could look ? :)

Probably something related to the expect API changes and/or missing
initializations. Compare your helper with other helpers and make sure
you initialize all fields of struct ip_conntrack_expect properly.
