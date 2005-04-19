From: Amin Azez <azez@ufomechanic.net>
Subject: Re: nfnetlink/ctnetlink - OOPS&panic
Date: Tue, 19 Apr 2005 15:11:24 +0100
Message-ID: <4265118C.9010905@ufomechanic.net>
References: <Pine.LNX.4.62.0504191220390.27543@bizon.gios.gov.pl>	<4264F3B6.9010408@eurodev.net>
	<Pine.LNX.4.62.0504191531390.2730@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0504191531390.2730@bizon.gios.gov.pl>
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
> OK. So I have just checked modular configuration 
> (CONFIG_IP_NF_CONNTRACK_NETLINK=m & CONFIG_NETFILTER_NETLINK=m)
> 
> # modprobe nfnetlink
> FATAL: Error inserting nfnetlink 
> (/lib/modules/2.6.11.7/kernel/net/netfilter/nfnetlink.ko): Operation not 
> permitted
> 
> dmesg shows:
> Netfilter messages via NETLINK v0.12.
> cannot initialize nfnetlink!

You probably need to do:
rmmod ip_queue

first, as they both try and connect to the same notification socket.

Sam Azez
