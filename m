From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: Re: nat and conntrack helper howto question
Date: 28 Jul 2003 01:28:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059348524.1680.14.camel@exile>
References: <200307271955.h6RJtMCq000572@alpha.medz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephan Jager <netfilter@medz.org>
In-Reply-To: <200307271955.h6RJtMCq000572@alpha.medz.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-07-27 at 21:55, Stephan Jager wrote:
> I only need to fix data in a udp package (ip address), no expect_related 
> connections. Must I use the ip_conntrack as well or can I only use the 
> ip_nat? 
> 
> As far as I could see, the ip_nat_xxx module is depended on the 
> ip_conntrack. Can I make an ip_conntrack_xxx which does do nothing and 
> only fires the ip_nat to fix the address or can I change data in the 
> ip_conntrack_xxx as well?
> 
> Hope somebody can give me some pointers.
> 

Hi Stephan,

Take a look at the CuSeeMe NAT helper in netfilter CVS - 
it is just a NAT helper without a conntrack part since
the CuSeeMe protocol doesn't open any additional connections,
just like your protocol, I guess.

The key is to pass the "IP_NAT_HELPER_F_STANDALONE"
flag when registering the NAT helper. This is also
menstioned in the netfilter hacking howto.

Regards,
Filip
