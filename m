From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Unable to receive data Netlinks sockets
Date: Thu, 25 Mar 2004 11:10:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4062B003.9030206@eurodev.net>
References: <s06245ee.076@prv-mail25.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Swaroop Ashish <sashish@novell.com>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <s06245ee.076@prv-mail25.provo.novell.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Swaroop Ashish wrote:

>Thanks Pablo,
>  
>
you're welcome.

>I have already used libipq successfully, but I want to play around with
>Netlink sockets now. I have a problem in recieving packets through
>Netlink sockets. Any help on that will be really great :-)
>  
>
In that case, have a look at how libipq does and the netlink sockets 
overview: http://qos.ittc.ukans.edu/netlink/html/. This could help you out.

BTW, I prefer recvfrom instead recvmsg as libipq does.

regards,
Pablo
